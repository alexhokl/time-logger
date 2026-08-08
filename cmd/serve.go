package cmd

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"os/signal"
	"syscall"
	"time"

	pserver "github.com/alexhokl/privateserver/server"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
	"go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc"
	"golang.org/x/sync/errgroup"
	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"

	"github.com/alexhokl/time-logger/database"
	"github.com/alexhokl/time-logger/internal"
	timeloggerv1 "github.com/alexhokl/time-logger/proto/timelogger/v1"
)

// DefaultPort is the gRPC listening port. There is no REST gateway, so this is
// the only port the server exposes besides the Tailscale HTTP redirect.
const DefaultPort = 8080

// shutdownTimeout bounds how long in-flight work is given to finish after a
// termination signal.
const shutdownTimeout = 30 * time.Second

type serveOptions struct {
	Port                    int
	DatabaseFilePath        string
	Hostname                string
	TailscaleAuthKey        string
	TailscaleStateDirectory string
}

var serveOpts serveOptions

var serveCmd = &cobra.Command{
	Use:   "serve",
	Short: "Start the time-logger gRPC server",
	Long: `Start the gRPC server.

Without --hostname the server listens on a plain TCP port and treats every
request as a single local user, which is intended for development. With
--hostname it joins the tailnet, terminates TLS itself, and identifies each
caller by their Tailscale login.`,
	RunE: runServe,
	PersistentPreRun: func(cmd *cobra.Command, args []string) {
		bindEnvironmentVariablesToServeOptions(cmd, &serveOpts)
	},
}

func init() {
	rootCmd.AddCommand(serveCmd)

	flags := serveCmd.Flags()
	flags.IntVarP(&serveOpts.Port, "port", "p", DefaultPort, "port to serve gRPC on")
	flags.StringVarP(&serveOpts.DatabaseFilePath, "database", "d", "", "path to the SQLite database file")
	flags.StringVar(&serveOpts.Hostname, "hostname", "",
		"Tailscale hostname; when empty the server is not exposed on the tailnet")
	flags.StringVar(&serveOpts.TailscaleAuthKey, "ts-auth-key", "", "Tailscale auth key")
	flags.StringVar(&serveOpts.TailscaleStateDirectory, "ts-state-dir", "./tailscale-state",
		"directory in which to persist Tailscale state")
}

// bindEnvironmentVariablesToServeOptions falls back to Viper for any flag the
// user did not explicitly pass. Flags whose zero value is also a valid,
// non-default setting (Port and TailscaleStateDirectory both default to a
// non-zero value) are checked via cmd.Flags().Changed rather than a zero-value
// comparison, since the zero value is never actually reached for them once
// cobra has applied its compiled-in default.
func bindEnvironmentVariablesToServeOptions(cmd *cobra.Command, opts *serveOptions) {
	if opts.TailscaleAuthKey == "" {
		opts.TailscaleAuthKey = viper.GetString("ts_auth_key")
	}
	if opts.Hostname == "" {
		opts.Hostname = viper.GetString("hostname")
	}
	if opts.DatabaseFilePath == "" {
		opts.DatabaseFilePath = viper.GetString("database")
	}
	if !cmd.Flags().Changed("ts-state-dir") {
		if v := viper.GetString("ts_state_dir"); v != "" {
			opts.TailscaleStateDirectory = v
		}
	}
	if !cmd.Flags().Changed("port") {
		if v := viper.GetInt("port"); v != 0 {
			opts.Port = v
		}
	}
}

func runServe(cmd *cobra.Command, _ []string) error {
	if err := validateServeOptions(serveOpts); err != nil {
		return err
	}

	// Initialise OpenTelemetry first. SetupOTel only takes over the default
	// logger once every provider has been built, so a failure here is still
	// reported through the original handler and stays visible in the console.
	ctx := cmd.Context()
	if ctx == nil {
		ctx = context.Background()
	}
	otelShutdown, err := internal.SetupOTel(ctx)
	if err != nil {
		// Non-fatal: telemetry is not worth refusing to start over.
		slog.Error("failed to set up OpenTelemetry", slog.String("error", err.Error()))
	}
	defer func() {
		// SetupOTel always returns a usable shutdown function, including on
		// its error paths, where partially built providers still need closing.
		if shutdownErr := otelShutdown(context.Background()); shutdownErr != nil {
			slog.Error("error shutting down OpenTelemetry",
				slog.String("error", shutdownErr.Error()))
		}
	}()

	dbConn, err := getDatabaseConnection(serveOpts.DatabaseFilePath)
	if err != nil {
		return fmt.Errorf("failed to connect to database: %w", err)
	}

	if err := database.AutoMigrate(dbConn); err != nil {
		return fmt.Errorf("failed to migrate database schema: %w", err)
	}

	// Warm the settings cache so the first request from each user does not pay
	// for the lookup. A failure here only costs a lazy load later.
	if err := internal.LoadUserSettings(dbConn); err != nil {
		slog.Warn("failed to warm the user settings cache",
			slog.String("error", err.Error()))
	}

	privateServer, grpcListener, redirect, err := buildListeners(ctx)
	if err != nil {
		return err
	}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGTERM, syscall.SIGINT)

	g, ctx := errgroup.WithContext(ctx)

	grpcServer, healthServer := buildGrpcServer(dbConn, privateServer)

	g.Go(func() error {
		select {
		case sig := <-sigChan:
			slog.Info("received shutdown signal", slog.String("signal", sig.String()))
		case <-ctx.Done():
			return nil
		}

		slog.Info("initiating graceful shutdown")

		// Flipping the health service to NOT_SERVING before stopping lets a
		// load balancer or orchestrator take the instance out of rotation
		// before connections start being refused.
		healthServer.Shutdown()

		shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), shutdownTimeout)
		defer shutdownCancel()

		stopped := make(chan struct{})
		go func() {
			grpcServer.GracefulStop()
			close(stopped)
		}()

		select {
		case <-stopped:
			slog.Info("gRPC server stopped gracefully")
		case <-shutdownCtx.Done():
			// A client holding a connection open must not be able to block
			// shutdown indefinitely.
			slog.Warn("graceful shutdown timed out; forcing stop")
			grpcServer.Stop()
		}

		if redirect != nil {
			if err := redirect.shutdown(shutdownCtx); err != nil {
				slog.Error("error shutting down the HTTP redirect listener",
					slog.String("error", err.Error()))
			}
		}

		cancel()
		return nil
	})

	g.Go(func() error {
		slog.Info(
			"gRPC server is serving",
			slog.Int("port", serveOpts.Port),
			slog.Bool("tailscale", serveOpts.Hostname != ""),
		)

		if err := grpcServer.Serve(grpcListener); err != nil {
			// Serve returns nil after GracefulStop, but a genuine failure
			// during shutdown should not be reported as one.
			select {
			case <-ctx.Done():
				return nil
			default:
				return err
			}
		}
		return nil
	})

	if redirect != nil {
		g.Go(redirect.serve)
	}

	if err := g.Wait(); err != nil {
		return err
	}

	slog.Info("server shutdown complete")
	return nil
}

// buildGrpcServer constructs the server, registers every service, and returns
// the health service so the shutdown path can flip its status.
//
// Interceptor order matters and is deliberate:
//
//  1. Recovery is outermost so it also covers panics raised inside the
//     interceptors that follow it, including authentication.
//  2. Error logging sits above authentication so that rejected requests are
//     logged with their method name.
//  3. Authentication runs last, immediately before the handler, so the user ID
//     it injects is in scope for the whole handler and nothing else.
func buildGrpcServer(db *gorm.DB, privateServer *pserver.Server) (*grpc.Server, *health.Server) {
	authInterceptor := internal.DummyAuthenticationInterceptor
	if privateServer != nil {
		authInterceptor = internal.NewTailscaleAuthenticationInterceptor(db, privateServer).Intercept
	} else {
		slog.Warn("running without Tailscale: every request is treated as the local user")
	}

	server := grpc.NewServer(
		grpc.ChainUnaryInterceptor(
			internal.RecoveryInterceptor,
			internal.ErrorLoggingInterceptor,
			authInterceptor,
		),
		grpc.StatsHandler(otelgrpc.NewServerHandler()),
	)

	timeloggerv1.RegisterProjectServiceServer(server, internal.NewProjectService(db))
	timeloggerv1.RegisterTaskServiceServer(server, internal.NewTaskService(db))
	timeloggerv1.RegisterTagServiceServer(server, internal.NewTagService(db))
	timeloggerv1.RegisterTimeEntryServiceServer(server, internal.NewTimeEntryService(db))
	timeloggerv1.RegisterTimerServiceServer(server, internal.NewTimerService(db))
	timeloggerv1.RegisterGoalServiceServer(server, internal.NewGoalService(db))
	timeloggerv1.RegisterReportServiceServer(server, internal.NewReportService(db))
	timeloggerv1.RegisterSettingsServiceServer(server, internal.NewSettingsService(db))

	// The health service reports SERVING once the schema is migrated and the
	// services are registered, which is the point at which the server can
	// actually answer a request.
	healthServer := health.NewServer()
	healthServer.SetServingStatus("", healthpb.HealthCheckResponse_SERVING)
	healthpb.RegisterHealthServer(server, healthServer)

	// Reflection lets grpcurl and similar tools discover the API without a
	// copy of the protos, which is worth a great deal when debugging a
	// deployed instance.
	reflection.Register(server)

	return server, healthServer
}

func getDatabaseConnection(databaseFilePath string) (*gorm.DB, error) {
	db, err := gorm.Open(
		sqlite.Open(databaseFilePath),
		&gorm.Config{
			// TranslateError surfaces driver-specific constraint violations as
			// gorm.ErrDuplicatedKey, which the handlers map onto
			// ALREADY_EXISTS and FAILED_PRECONDITION.
			TranslateError: true,
			Logger: logger.New(
				// Route GORM's query log through the default slog handler so it
				// reaches the same OTLP sink as everything else.
				slog.NewLogLogger(slog.Default().Handler(), slog.LevelInfo),
				logger.Config{IgnoreRecordNotFoundError: true},
			),
		},
	)
	if err != nil {
		return nil, err
	}

	// WAL lets read-only consumers query the file concurrently without
	// blocking writers. It persists in the file header, so this is idempotent
	// across restarts.
	db.Exec("PRAGMA journal_mode=WAL")
	db.Exec("PRAGMA busy_timeout=5000")
	// Foreign keys are off by default in SQLite and are needed for the
	// entry/tag join table to stay consistent.
	db.Exec("PRAGMA foreign_keys=ON")

	return db, nil
}

func validateServeOptions(opts serveOptions) error {
	if opts.DatabaseFilePath == "" {
		return fmt.Errorf("a database file path is required: pass --database or set TIME_LOGGER_DATABASE")
	}
	if opts.Port <= 0 || opts.Port > 65535 {
		return fmt.Errorf("port %d is out of range", opts.Port)
	}
	if opts.Hostname != "" && opts.TailscaleStateDirectory == "" {
		return fmt.Errorf("--ts-state-dir is required when --hostname is set")
	}
	return nil
}
