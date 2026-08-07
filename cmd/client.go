package cmd

import (
	"context"
	"fmt"
	"os"
	"strings"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/credentials/insecure"

	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// dialTimeout bounds how long a client command waits for the connection and
// the RPC combined, so a CLI invocation against an unreachable server fails
// promptly instead of hanging.
const dialTimeout = 30 * time.Second

// exit is indirected so tests can observe the exit code instead of terminating
// the test binary.
var exit = os.Exit

// requireSecureConnection reports whether TLS should be used for a given
// service address.
//
// Loopback addresses are assumed to be a developer running the server locally
// without certificates; everything else is assumed to be the tailnet, where
// the server terminates TLS with a Let's Encrypt certificate that the OS trust
// store already validates.
func requireSecureConnection(url string) bool {
	if url == "" ||
		strings.Contains(url, "localhost") ||
		strings.Contains(url, "127.0.0.1") ||
		strings.Contains(url, "[::1]") {
		return false
	}
	return true
}

// getConnectionCredentials returns TLS credentials backed by the operating
// system's trust store, or plaintext credentials when security is not required.
func getConnectionCredentials(secure bool) credentials.TransportCredentials {
	if secure {
		return credentials.NewClientTLSFromCert(nil, "")
	}
	return insecure.NewCredentials()
}

// dial opens a connection to the configured server.
//
// The --insecure flag only ever downgrades the connection; it cannot upgrade
// one, so a user cannot accidentally believe they are protected when they are
// not.
func dial() (*grpc.ClientConn, error) {
	if rootOpts.serviceURI == "" {
		return nil, fmt.Errorf(
			"no server configured: pass --service host:port, set %s_SERVICE, "+
				"or add `service:` to ~/.%s.yaml",
			strings.ToUpper(envPrefix), AppName,
		)
	}

	secure := requireSecureConnection(rootOpts.serviceURI) && !rootOpts.allowInsecureConnection

	conn, err := grpc.NewClient(
		rootOpts.serviceURI,
		grpc.WithTransportCredentials(getConnectionCredentials(secure)),
	)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to %s: %w", rootOpts.serviceURI, err)
	}
	return conn, nil
}

// clientContext returns a context bounded by dialTimeout.
func clientContext() (context.Context, context.CancelFunc) {
	return context.WithTimeout(context.Background(), dialTimeout)
}

// withClient dials, runs fn with the connection and a bounded context, and
// always closes the connection. Every client command funnels through this so
// connection handling is written once.
func withClient(fn func(ctx context.Context, conn *grpc.ClientConn) error) error {
	conn, err := dial()
	if err != nil {
		return err
	}
	defer func() { _ = conn.Close() }()

	ctx, cancel := clientContext()
	defer cancel()

	return fn(ctx, conn)
}

// --- Typed client accessors ------------------------------------------------
//
// Thin wrappers so command files read as `client.Projects(conn)` rather than
// repeating the generated constructor names.

func projectClient(conn *grpc.ClientConn) timeloggerv1.ProjectServiceClient {
	return timeloggerv1.NewProjectServiceClient(conn)
}

func taskClient(conn *grpc.ClientConn) timeloggerv1.TaskServiceClient {
	return timeloggerv1.NewTaskServiceClient(conn)
}

func tagClient(conn *grpc.ClientConn) timeloggerv1.TagServiceClient {
	return timeloggerv1.NewTagServiceClient(conn)
}

func entryClient(conn *grpc.ClientConn) timeloggerv1.TimeEntryServiceClient {
	return timeloggerv1.NewTimeEntryServiceClient(conn)
}

func timerClient(conn *grpc.ClientConn) timeloggerv1.TimerServiceClient {
	return timeloggerv1.NewTimerServiceClient(conn)
}

func goalClient(conn *grpc.ClientConn) timeloggerv1.GoalServiceClient {
	return timeloggerv1.NewGoalServiceClient(conn)
}

func reportClient(conn *grpc.ClientConn) timeloggerv1.ReportServiceClient {
	return timeloggerv1.NewReportServiceClient(conn)
}

func settingsClient(conn *grpc.ClientConn) timeloggerv1.SettingsServiceClient {
	return timeloggerv1.NewSettingsServiceClient(conn)
}
