FROM golang:1.26-alpine3.22 AS builder

# git is needed for module downloads; build-base supplies the C toolchain that
# the SQLite driver requires.
RUN apk update && apk upgrade && \
    apk add --no-cache git build-base

# The SQLite driver is cgo-based, so cgo cannot be disabled here.
ENV CGO_ENABLED=1
ENV app_name=time-logger
ENV repo=github.com/alexhokl/${app_name}

WORKDIR /go/src/${repo}

# Copy the module files first so the dependency download is cached
# independently of the source, which changes far more often.
COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

# The musl tag selects the SQLite build appropriate for Alpine's libc.
RUN go install -tags musl

FROM alpine:3.22 AS dev

# tzdata provides the IANA timezone database. Without it every date-only input
# and every report boundary would silently fall back to UTC, which is exactly
# the bug the per-user timezone setting exists to avoid. ca-certificates is
# needed for the OTLP exporter's TLS connection to GCP.
RUN apk add --no-cache tzdata ca-certificates

ENV USERNAME=appuser
ENV UID=1001
ENV GROUP=appgroup
ENV HOME=/home/${USERNAME}

RUN addgroup -g ${UID} -S ${GROUP} && adduser -u ${UID} -S -G ${GROUP} ${USERNAME}

WORKDIR $HOME

RUN mkdir ./data ./tailscale

COPY --from=builder --chown=appuser:appgroup /go/bin/time-logger .

RUN chown -R appuser:appgroup $HOME

# The gRPC port. There is no REST gateway, so this is the only application
# port; the Tailscale integration additionally opens port 80 for its
# HTTP-to-HTTPS redirect when a hostname is configured.
EXPOSE 8080

ENTRYPOINT ["./time-logger"]

FROM dev AS production

USER ${USERNAME}
