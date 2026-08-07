# AGENTS.md

Guidance for AI agents working in this repository.

## What this is

A personal time tracker. One Go binary is both the gRPC server (`serve`) and
the CLI client (every other verb). A Flutter app in `mobile/` is the second
client. There is no REST API and none should be added — both clients speak
protobuf, and an HTTP/JSON layer would be a second, unauthenticated path to the
same data.

## Build and test

```sh
task build      # compile everything
task test       # go test ./... plus flutter test
task lint       # golangci-lint, buf lint, dart analyze
task proto      # regenerate Go and Dart from the protos
```

Always run `task lint` and `task test` before considering a change done. The
linter config is deliberately strict; do not weaken it to make a finding go
away without saying why.

## Conventions

- **Go**: standard formatting via `golangci-lint fmt`. Handlers live in
  `internal/`, one file per gRPC service. Every handler starts with
  `s.resolveUser(ctx)` and scopes every query by the returned user ID — that is
  the only authorization mechanism in the system.
- **Errors**: return domain error types from `internal/error.go` and let
  `toStatusError` map them to gRPC codes. Never return a raw database error to
  a client.
- **Protos**: `buf` with the STANDARD lint ruleset. Every RPC needs its own
  request *and* response message, even when the response is empty, so it can
  gain fields later without a breaking change. Run `task proto-breaking`
  before changing an existing message.
- **Tests**: table-driven, named so the failure output reads as a sentence.
  Handler tests use a real in-memory SQLite database rather than mocks.
- **Comments**: explain *why*, not *what*. The non-obvious decisions are worth
  documenting; a comment restating the code is not.

## Things that are easy to get wrong

- **Timezones.** Instants are stored in UTC. Day boundaries for reports and
  date-only inputs are resolved in the user's `UserSetting.Timezone`. Never
  bucket entries by a SQL date function — SQLite only offers UTC and the
  server's local zone, and neither is the user's.
- **The running timer** is a `TimeEntry` with `end_time` NULL, guarded by a
  partial unique index. Running entries are excluded from report totals because
  their final duration is not yet known; including them would make the same
  report return a different number on every call.
- **Rounding** applies only when reporting. Stored durations are always exact,
  so changing the setting is reversible.
- **Deleting a project** with entries is refused, not cascaded. Archiving is
  the intended alternative.
- **Tag names** are lowercased and trimmed on the way in. Skipping that lets
  near-duplicates accumulate past the unique index and makes tag filters
  silently miss rows.
- **The console log handler** must not be `slog.Default().Handler()`. That
  handler writes through the standard `log` package, and the GORM logger is
  built on top of the default slog handler, so reusing it deadlocks the process
  on a single mutex. See `internal/slog_gcp.go`.

