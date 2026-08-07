# time-logger

A personal time tracker: a Go gRPC server, a Cobra CLI, and a Flutter client.

The server and the CLI are the same binary. `time-logger serve` runs the
server; every other verb is a gRPC client talking to it.

## Why it is built this way

- **gRPC only.** There is no REST gateway. Both clients are first-party and
  speak protobuf, so an HTTP/JSON translation layer would be pure overhead and
  a second, unauthenticated path into the data.
- **Tailscale for identity.** The server has no passwords, tokens or API keys.
  On the tailnet it identifies each caller by their Tailscale login and creates
  the user record on first contact. Authorization is row scoping: every query
  is filtered by user ID.
- **SQLite.** Single user, single instance, one file to back up.
- **UTC storage, per-user timezone for interpretation.** Every instant is
  stored in UTC; day boundaries for reports and date-only inputs are resolved
  in the user's configured timezone. An entry at 00:30 belongs to a different
  day depending on that setting, so it matters more than it appears.

## Layout

| Path | Purpose |
|---|---|
| `main.go` | Entry point |
| `cmd/` | Cobra CLI: `serve` plus every client verb |
| `internal/` | gRPC service implementations, interceptors, observability |
| `database/` | GORM models and schema migration |
| `proto/timelogger/v1/` | Protobuf definitions and generated Go |
| `mobile/` | Flutter app |
| `documentation/` | Architecture diagram |

## Domain model

- **Project** — the top-level grouping. Optional on an entry.
- **Task** — an optional second level, nested inside a project.
- **Tag** — a free-form label, related to entries through a join table so a
  rename propagates everywhere.
- **TimeEntry** — a unit of tracked work.
- **Goal** — a target number of hours per day, week or month, optionally scoped
  to a project or task and to a date window.
- **UserSetting** — timezone, first day of week, rounding, default project.

### The running timer

A running timer is a `TimeEntry` whose `end_time` is NULL. Stopping it just
fills that field in, so the stopwatch shares all of its storage, filtering and
reporting behaviour with manually entered work.

At most one timer may run per user. Starting a second one **fails** rather than
silently stopping the first: an accidental start would otherwise truncate work
in progress, and the mistake would stay invisible until a report looked wrong.

The rule is enforced twice. The handler checks, and a partial unique index on
`time_entries (user_id) WHERE end_time IS NULL AND deleted_at IS NULL` catches
the race where two concurrent calls both pass that check.

### Specifying time

An entry is defined by any two of start, end and duration; the server derives
the third.

| Given | Derived |
|---|---|
| start + end | duration |
| start + duration | end |
| end + duration | start |
| date + duration | start is local midnight, end follows |
| start only | the entry is left running |
| duration only | an entry of that length ending now |

All three may be supplied together, but only if they agree — a mismatch is
rejected rather than silently preferring one, because there is no way to know
which was meant.

## Running the server

```sh
# Local development. Every request is treated as a single local user.
go run . serve --database ./time-logger.db --port 8080

# On the tailnet, with per-user Tailscale identity and TLS.
time-logger serve \
  --database /data/timelogger.db \
  --hostname time-logger \
  --ts-state-dir /data/tailscale \
  --port 443
```

Flags fall back to Viper, so `TIME_LOGGER_DATABASE`, `TIME_LOGGER_PORT` and so
on work too, as does `~/.time-logger.yaml`.

The server registers gRPC reflection and the standard health service, so
`grpcurl -plaintext localhost:8080 list` works without a copy of the protos.

### Telemetry

Traces, metrics and logs are exported over OTLP to GCP using Application
Default Credentials. It is entirely optional: set `OTEL_SDK_DISABLED=true` to
turn it off, and a failure to reach GCP is logged but never prevents the server
from starting.

## Using the CLI

```sh
# Point the CLI at a server once.
echo 'service: time-logger.some-name.ts.net:443' > ~/.time-logger.yaml

# The stopwatch.
time-logger start "reviewing the migration plan" --project 3 --tag billable
time-logger status
time-logger stop

# Logging work after the fact. A bare number is minutes, so this is 90 minutes.
time-logger create entry "code review" --project 3 --duration 90
time-logger create entry "standup" --start '2026-08-07 09:00' --end '2026-08-07 09:15'
time-logger create entry "planning" --date yesterday --duration 2h

# Looking at it.
time-logger list entries --from today
time-logger report weekly --group-by project
time-logger report goals
time-logger report streaks
time-logger report heatmap --from 2026-01-01

# Scripting. --fields can also name hidden machine-friendly columns such as
# `seconds`, which sit alongside the pretty `duration`.
time-logger list entries --from 2026-08-01 --format csv --fields date,seconds,project
time-logger report weekly --format json --fields label,seconds
```

Every command accepts `--format text|json|csv` and `--fields`.

## The Flutter app

`mobile/` holds a Riverpod app targeting Android, iOS, macOS, Linux and
Windows. Riverpod rather than `setState` because the running timer has to stay
consistent across several screens at once.

It works offline: projects, tasks and tags are cached in SQLite so the pickers
still work, and entries created while disconnected are queued and replayed one
at a time when the server comes back. Uploading individually rather than as a
batch means one broken entry cannot block the rest of the queue behind it.

A queued entry is only ever deleted once the server confirms it stored it; a
failed upload records the error and keeps the entry.

## Development

```sh
task            # list every task
task test       # Go and Flutter tests
task lint       # golangci-lint, buf lint, dart analyze
task proto      # regenerate Go and Dart from the protos
task run        # server against a scratch database
task run-flutter
```

Protobuf generation uses `buf`, which is declared as a Go tool dependency, so
`go tool buf generate` works with nothing else installed. The Dart plugin
(`protoc-gen-dart`) does need to be on `PATH`:

```sh
dart pub global activate protoc_plugin
```

## Deployment

The server ships as a Docker image and runs from
`../cluster/docker-compose.yml`, joining the tailnet and terminating TLS on
port 443. It needs `.env_time_logger` on the host holding the Tailscale auth
key.

Cloud Build (`cloudbuild.yaml`) is tag-triggered: it runs the tests, builds and
pushes the image, and builds a signed APK.
