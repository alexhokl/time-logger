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

## Android Device Setup

### Enable Developer Options

1. On the Android device, go to `Settings` → `About phone`
2. Tap **Build number** 7 times until you see "You are now a developer!"
3. Go back to `Settings` → **Developer options**
4. Enable **USB debugging**

### Pair an Android device using Android Studio

1. On the Android device, go to `Settings` → `Developer options` → enable **Wireless debugging**
2. Tap **Pair device with pairing code** — note the IP address, port, and pairing code shown
3. In Android Studio, open the device dropdown in the toolbar and select **Pair Devices Using Wi-Fi**
4. Click **Pair using pairing code** and enter the IP address, port, and pairing code from the device
5. Once paired, the device will appear in the device list and can be selected for running/debugging

### Uninstall the app from a connected Android device using adb

To remove the existing installation (required when the signing key has changed):

```sh
adb uninstall dev.alexho.time_logger
```

### Install the app on a connected Android device using adb

Build the APK with `task apk`, then ensure the device is connected via USB with
USB debugging enabled and appears in:

```sh
adb devices
```

Then install the APK:

```sh
adb install mobile/build/app/outputs/flutter-apk/app-release.apk
```

If upgrading an existing installation signed with the same key, use the `-r` flag:

```sh
adb install -r mobile/build/app/outputs/flutter-apk/app-release.apk
```

## Android Intents

The Android app can be opened from the launcher and from other apps to start a
timer or log time quickly. Every intent only pre-fills a form: nothing is
recorded until you tap **Start** or **Save**, so a link on a web page cannot
change your data.

| Intent | How to use | Result |
|--------|------------|--------|
| App shortcuts | Long-press the app icon | **Timer**, **New entry**, **Entries** or **Reports** |
| `PROCESS_TEXT` | Select text in any app (e.g. a ticket title) and choose **Log time** | See below |
| `SEND` (`text/plain`) | Share text to **time_logger** | See below |
| `VIEW` deep link | Open a `timelogger://` link (e.g. from Tasker, an NFC tag or a Gallery skill) | See below |

### Pre-filling from text

Text that contains a duration with a unit, such as `Code review 1h30m` or
`standup 15 min`, opens the entry editor with that duration ending now; the
rest of the text becomes the description. Any other text, such as
`PROJ-123 Fix login`, becomes the description on the timer page. A bare number
is not treated as a duration, because in free text it is more often a ticket or
room number.

### Deep links

| Link | Opens |
|------|-------|
| `timelogger://timer?description=&project=&task=&tags=` | Timer page, pre-filled. Refused with a message while a timer is running |
| `timelogger://entry/new?description=&project=&task=&tags=&date=&start=&end=&duration=` | Entry editor, pre-filled |
| `timelogger://entries` | Entries |
| `timelogger://reports` | Reports |

All parameters are optional.

- `project` and `task` are names, matched ignoring case. A name that matches
  nothing is reported and left unset.
- `tags` is comma separated and lowercased.
- `date` is `YYYY-MM-DD`; `start` and `end` are 24-hour `HH:MM` in the
  device's time zone.
- `duration` follows the CLI: a bare number is minutes, and `2h`, `1h30m` and
  `1.5h` also work. With only a duration, the entry ends now (at the current
  time of day on `date`); with a start or end, it runs from that.
- An invalid parameter is dropped on its own; the rest of the link still
  applies.

### Testing intents with adb

```sh
# deep link; quote the whole command so the device shell does not treat & as a separator
adb shell "am start -a android.intent.action.VIEW \
  -d 'timelogger://entry/new?description=code%20review&project=acme&duration=90&tags=billable'"

# share text
adb shell am start -a android.intent.action.SEND -t text/plain \
  --es android.intent.extra.TEXT "'standup 15 min'" \
  -n dev.alexho.time_logger/.MainActivity
```

The shortcuts in `mobile/android/app/src/main/res/xml/shortcuts.xml` refer to
the application ID and activity `dev.alexho.time_logger.MainActivity`; update
them if either changes.

### Google AI Edge Gallery skills

[`google-ai-edge-gallery-skills/`](google-ai-edge-gallery-skills) contains
[Agent Skills](https://github.com/google-ai-edge/gallery/blob/main/skills/README.md)
for the Google AI Edge Gallery app, so an on-device model can open a pre-filled
timer or entry from a sentence, or schedule a reminder that opens one.

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
