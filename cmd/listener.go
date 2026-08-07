package cmd

import (
	"context"
	"fmt"
	"log/slog"
	"net"
	"net/http"

	pserver "github.com/alexhokl/privateserver/server"
)

// redirectServer wraps the plain-HTTP listener the Tailscale integration
// provides, which answers port 80 with a redirect to HTTPS.
type redirectServer struct {
	listener net.Listener
	server   *http.Server
}

func (r *redirectServer) serve() error {
	slog.Info("HTTP redirect listener is serving",
		slog.String("addr", r.listener.Addr().String()))

	if err := r.server.Serve(r.listener); err != nil && err != http.ErrServerClosed {
		return err
	}
	return nil
}

func (r *redirectServer) shutdown(ctx context.Context) error {
	return r.server.Shutdown(ctx)
}

// buildListeners creates the gRPC listener, joining the tailnet when a
// hostname is configured.
//
// On the tailnet the private server terminates TLS itself using a certificate
// issued for the node's FQDN, so no certificate management is needed here.
// Without a hostname the server falls back to a plain TCP listener, which is
// only appropriate for local development because the dummy authentication
// interceptor treats every caller as the same user.
func buildListeners(ctx context.Context) (*pserver.Server, net.Listener, *redirectServer, error) {
	if serveOpts.Hostname == "" {
		// A ListenConfig is used rather than net.Listen so the bind honours
		// the caller's context and does not outlive a cancelled start-up.
		var config net.ListenConfig
		listener, err := config.Listen(ctx, "tcp", fmt.Sprintf(":%d", serveOpts.Port))
		if err != nil {
			return nil, nil, nil, fmt.Errorf(
				"failed to listen on port %d: %w", serveOpts.Port, err)
		}
		return nil, listener, nil, nil
	}

	privateServer, err := pserver.NewServer(&pserver.ServerConfig{
		Hostname:                serveOpts.Hostname,
		TailscaleAuthKey:        serveOpts.TailscaleAuthKey,
		TailscaleStateDirectory: serveOpts.TailscaleStateDirectory,
	})
	if err != nil {
		return nil, nil, nil, fmt.Errorf("failed to create the Tailscale server: %w", err)
	}

	listeners, redirectListener, redirectHandler, err := privateServer.Listen([]int{serveOpts.Port})
	if err != nil {
		return nil, nil, nil, fmt.Errorf("failed to start the Tailscale listener: %w", err)
	}

	slog.Info("Tailscale is enabled",
		slog.String("hostname", serveOpts.Hostname),
		slog.String("fqdn", privateServer.FQDN()),
	)

	var redirect *redirectServer
	if redirectListener != nil && redirectHandler != nil {
		redirect = &redirectServer{
			listener: redirectListener,
			server:   &http.Server{Handler: redirectHandler},
		}
	}

	return privateServer, listeners[0], redirect, nil
}
