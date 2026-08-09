package internal

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"time"

	"github.com/alexhokl/helper/telemetry"
	slogmulti "github.com/samber/slog-multi"
	"go.opentelemetry.io/contrib/bridges/otelslog"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	sdklog "go.opentelemetry.io/otel/sdk/log"
	semconv "go.opentelemetry.io/otel/semconv/v1.26.0"
)

// credentialTimeout bounds Application Default Credentials resolution. On GCE
// the metadata server answers in milliseconds; off it, the probe would
// otherwise stall start-up until a network timeout expires.
const credentialTimeout = 10 * time.Second

// SetupOTel initialises the global OpenTelemetry TracerProvider, MeterProvider,
// and LoggerProvider. All three signals are exported via a single shared
// gRPC connection to GCP's managed OTel collector (telemetry.googleapis.com),
// authenticated using Application Default Credentials (ADC).
//
// ADC credential resolution order:
//  1. GOOGLE_APPLICATION_CREDENTIALS env var — path to a service account key
//     JSON file; use this for non-GCE environments (local dev, non-GCP servers)
//  2. gcloud auth application-default login — credentials on the local machine
//  3. GCE / Cloud Run metadata server — zero-config for VM-hosted workloads;
//     tokens are fetched and refreshed automatically via the metadata server
//
// Logs are fanned out to both the console (see telemetry.NewGCPConsoleHandler)
// and the OTLP bridge, so that application logs remain visible even if OTLP
// export is rejected, throttled, or unreachable.
//
// Once the MeterProvider is installed, the application-level instruments
// (see metrics.go) are registered on the global meter and stashed in the
// package-level appMetrics variable, which the gRPC handlers and
// authentication interceptors read when recording business measurements.
// Registration failure is non-fatal: the metrics are simply absent and every
// recording site no-ops on a nil handle.
//
// The returned shutdown function must be deferred by the caller; it flushes
// and shuts down all three providers and closes the shared gRPC connection.
// It is always non-nil, including on the error paths.
//
// Required environment variables:
//
//	OTEL_SERVICE_NAME  – e.g. time-logger; telemetry.Setup returns an error if
//	                     this is unset
//
// Optional:
//
//	OTEL_SDK_DISABLED               – set to "true" to disable telemetry entirely
//	GOOGLE_APPLICATION_CREDENTIALS – path to service account key JSON (non-GCE only)
//	GOOGLE_CLOUD_PROJECT            – GCP project ID (included in OTel resource)
//	OTEL_TRACES_SAMPLER             – e.g. parentbased_always_on (SDK default)
//	OTEL_METRIC_EXPORT_INTERVAL     – metric push interval in ms (default 60000)
func SetupOTel(ctx context.Context) (shutdown func(context.Context) error, err error) {
	if telemetry.IsSDKDisabled() {
		slog.Debug("OpenTelemetry is disabled via OTEL_SDK_DISABLED")
		return func(context.Context) error { return nil }, nil
	}

	// Resolving Application Default Credentials can block for a long time when
	// none are available: outside GCE the metadata server is unreachable
	// rather than absent, so the probe waits for a network timeout. Bounding
	// it here means a developer running the server locally without credentials
	// gets a working server after a short delay instead of a process that
	// never finishes starting.
	dialCtx, cancelDial := context.WithTimeout(ctx, credentialTimeout)
	defer cancelDial()

	conn, err := telemetry.NewGCPGRPCConn(dialCtx)
	if err != nil {
		return func(context.Context) error { return nil }, fmt.Errorf("failed to build GCP gRPC connection: %w", err)
	}

	shutdown, err = telemetry.Setup(
		ctx,
		telemetry.WithGRPCConn(conn),
		telemetry.WithResourceAttributes(gcpResourceAttributes()...),
		// Gating already happened above via IsSDKDisabled; Setup's default
		// gate (IsOTLPConfigured) checks for OTEL_EXPORTER_OTLP_* variables,
		// which time-logger never sets since it talks directly to GCP's
		// managed endpoint, so it must be disabled here.
		telemetry.WithDisabledCheck(func() bool { return false }),
		telemetry.WithLogFanout(func(lp *sdklog.LoggerProvider) slog.Handler {
			// Note that the non-GCP fallback is a fresh text handler on
			// stderr rather than slog.Default().Handler(). The default
			// handler delegates to the standard log package, and the GORM
			// logger is in turn built on top of the default slog handler;
			// reusing it would therefore route a GORM log statement back
			// into the same log.Logger that is already emitting it,
			// deadlocking the process on that logger's mutex. Writing
			// straight to stderr breaks the cycle.
			return slogmulti.Fanout(
				// telemetry.NewGCPConsoleHandler(slog.NewTextHandler(os.Stderr, nil)),
				otelslog.NewHandler(telemetry.ServiceName(), otelslog.WithLoggerProvider(lp)),
			)
		}),
	)
	if err != nil {
		return shutdown, err
	}

	// Register the application-level instruments on the global meter. The
	// handle is stashed in the package-level appMetrics variable, which the
	// gRPC handlers and authentication interceptors read when recording
	// business measurements. Registration failure is non-fatal: the metrics
	// are simply absent and every recording site no-ops on a nil handle.
	m, merr := NewMetrics(otel.Meter(meterName))
	if merr != nil {
		slog.Error("failed to register application metrics", slog.String("error", merr.Error()))
	} else {
		appMetrics = m
	}

	return shutdown, nil
}

// gcpResourceAttributes returns additional OTel resource attributes
// describing the GCP project/region this process is running in, when known.
func gcpResourceAttributes() []attribute.KeyValue {
	var attrs []attribute.KeyValue
	if project := os.Getenv("GOOGLE_CLOUD_PROJECT"); project != "" {
		attrs = append(
			attrs,
			semconv.CloudProviderGCP,
			semconv.CloudAccountID(project),
			attribute.String("gcp.project_id", project),
		)
	}
	if region := os.Getenv("GOOGLE_CLOUD_REGION"); region != "" {
		attrs = append(attrs, semconv.CloudRegion(region))
	}
	return attrs
}
