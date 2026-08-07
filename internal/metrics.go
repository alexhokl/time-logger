package internal

import (
	"context"

	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/metric"
)

const meterName = "time-logger"

// appMetrics is the package-level handle to the registered application
// metrics. It is populated by SetupOTel once the global MeterProvider has been
// installed, and read by the gRPC handlers and the authentication interceptors
// when they record business-level measurements. It remains nil when telemetry
// is disabled (OTEL_SDK_DISABLED=true) or when instrument registration fails;
// every recording site guards against a nil value so a missing meter never
// panics the request path.
var appMetrics *Metrics

// Metrics holds the OpenTelemetry instruments used to record application-level
// measurements. They complement the automatic rpc.server.* metrics emitted by
// the otelgrpc stats handler with dimensions the stats handler cannot see:
// how many records a List RPC returned, how long a report took to compute, and
// how the stopwatch is actually being used.
type Metrics struct {
	// AuthAttempts counts every authentication attempt observed by the
	// authentication interceptors, labelled by mode (tailscale or dummy) and
	// outcome (success or failure).
	AuthAttempts metric.Int64Counter

	// RecordsReturned records how many records each List RPC returned,
	// labelled by method and entity kind. A histogram rather than a counter so
	// dashboards can show p50/p95 page sizes as well as totals.
	RecordsReturned metric.Int64Histogram

	// BulkBatchSize records the number of items in each bulk request
	// (CreateEntries, CopyEntries).
	BulkBatchSize metric.Int64Histogram

	// ReportComputeDuration records milliseconds spent aggregating a report
	// inside the handler, labelled by report kind. This covers DB time plus
	// aggregation, complementing rpc.server.duration which also includes
	// marshalling.
	ReportComputeDuration metric.Float64Histogram

	// ReportRowsReturned records how many rows a report response contained.
	ReportRowsReturned metric.Int64Histogram

	// TimerStarts counts StartTimer calls, labelled by outcome so that
	// "already running" rejections are visible separately from successes.
	TimerStarts metric.Int64Counter

	// TimerStops counts StopTimer and CancelRunningTimer calls, labelled by
	// the action taken.
	TimerStops metric.Int64Counter

	// TrackedSeconds records the duration of each entry as it is closed or
	// created, giving a distribution of session lengths.
	TrackedSeconds metric.Int64Histogram
}

// Attribute keys used by the application metrics, centralised so the spelling
// stays consistent across recording sites.
const (
	attrAuthMode   = attribute.Key("auth.mode")
	attrAuthResult = attribute.Key("auth.result")
	attrRPCMethod  = attribute.Key("rpc.method")
	attrEntity     = attribute.Key("entity")
	attrOperation  = attribute.Key("operation")
	attrReportKind = attribute.Key("report.kind")
	attrResult     = attribute.Key("result")
)

// Explicit bucket boundaries. The SDK defaults are tuned for latency in
// seconds and produce useless buckets for counts and durations in other units,
// so every histogram overrides them.
var (
	recordsReturnedBuckets       = []float64{1, 10, 50, 100, 500, 1000}
	bulkBatchSizeBuckets         = []float64{1, 10, 50, 100, 500}
	reportComputeDurationBuckets = []float64{1, 5, 10, 50, 100, 500, 1000, 5000}
	reportRowsReturnedBuckets    = []float64{1, 10, 50, 100, 500}
	// Session lengths: 1 minute up to 12 hours.
	trackedSecondsBuckets = []float64{60, 300, 900, 1800, 3600, 7200, 14400, 28800, 43200}
)

// NewMetrics registers every application instrument on the provided meter. The
// meter must be the global one (otel.Meter(meterName)) so that the
// PeriodicReader configured in SetupOTel exports the recorded data points;
// passing a separate meter would silently orphan the instruments.
//
// Registration errors are returned so the caller can log them and continue,
// matching the non-fatal telemetry policy in SetupOTel.
func NewMetrics(meter metric.Meter) (*Metrics, error) {
	authAttempts, err := meter.Int64Counter(
		"time_logger.auth.attempts",
		metric.WithDescription("Number of authentication attempts observed by the auth interceptors"),
	)
	if err != nil {
		return nil, err
	}

	recordsReturned, err := meter.Int64Histogram(
		"time_logger.records.returned",
		metric.WithDescription("Number of records returned by List RPCs"),
		metric.WithExplicitBucketBoundaries(recordsReturnedBuckets...),
	)
	if err != nil {
		return nil, err
	}

	bulkBatchSize, err := meter.Int64Histogram(
		"time_logger.bulk.batch_size",
		metric.WithDescription("Number of items in each bulk operation request"),
		metric.WithExplicitBucketBoundaries(bulkBatchSizeBuckets...),
	)
	if err != nil {
		return nil, err
	}

	reportComputeDuration, err := meter.Float64Histogram(
		"time_logger.report.compute_duration",
		metric.WithDescription("Wall-clock time spent computing a report response"),
		metric.WithUnit("ms"),
		metric.WithExplicitBucketBoundaries(reportComputeDurationBuckets...),
	)
	if err != nil {
		return nil, err
	}

	reportRowsReturned, err := meter.Int64Histogram(
		"time_logger.report.rows_returned",
		metric.WithDescription("Number of rows in a report response"),
		metric.WithExplicitBucketBoundaries(reportRowsReturnedBuckets...),
	)
	if err != nil {
		return nil, err
	}

	timerStarts, err := meter.Int64Counter(
		"time_logger.timer.starts",
		metric.WithDescription("Number of StartTimer calls, labelled by outcome"),
	)
	if err != nil {
		return nil, err
	}

	timerStops, err := meter.Int64Counter(
		"time_logger.timer.stops",
		metric.WithDescription("Number of timer stop or cancel calls, labelled by action"),
	)
	if err != nil {
		return nil, err
	}

	trackedSeconds, err := meter.Int64Histogram(
		"time_logger.entry.tracked_seconds",
		metric.WithDescription("Duration of each time entry as it is recorded"),
		metric.WithUnit("s"),
		metric.WithExplicitBucketBoundaries(trackedSecondsBuckets...),
	)
	if err != nil {
		return nil, err
	}

	return &Metrics{
		AuthAttempts:          authAttempts,
		RecordsReturned:       recordsReturned,
		BulkBatchSize:         bulkBatchSize,
		ReportComputeDuration: reportComputeDuration,
		ReportRowsReturned:    reportRowsReturned,
		TimerStarts:           timerStarts,
		TimerStops:            timerStops,
		TrackedSeconds:        trackedSeconds,
	}, nil
}

// --- Recording helpers -------------------------------------------------
//
// Each helper no-ops when appMetrics is nil. The nil check lives inside the
// helper rather than at every call site so handlers stay focused on business
// logic; a missing meter must never panic the request path.

func recordAuthAttempt(ctx context.Context, mode, result string) {
	if appMetrics == nil {
		return
	}
	appMetrics.AuthAttempts.Add(ctx, 1, metric.WithAttributes(
		attrAuthMode.String(mode),
		attrAuthResult.String(result),
	))
}

func recordRecordsReturned(ctx context.Context, method, entity string, count int) {
	if appMetrics == nil {
		return
	}
	appMetrics.RecordsReturned.Record(ctx, int64(count), metric.WithAttributes(
		attrRPCMethod.String(method),
		attrEntity.String(entity),
	))
}

func recordBulkBatchSize(ctx context.Context, method, operation string, count int) {
	if appMetrics == nil {
		return
	}
	appMetrics.BulkBatchSize.Record(ctx, int64(count), metric.WithAttributes(
		attrRPCMethod.String(method),
		attrOperation.String(operation),
	))
}

func recordReportComputeDuration(ctx context.Context, kind string, durationMs float64) {
	if appMetrics == nil {
		return
	}
	appMetrics.ReportComputeDuration.Record(ctx, durationMs, metric.WithAttributes(
		attrReportKind.String(kind),
	))
}

func recordReportRowsReturned(ctx context.Context, kind string, count int) {
	if appMetrics == nil {
		return
	}
	appMetrics.ReportRowsReturned.Record(ctx, int64(count), metric.WithAttributes(
		attrReportKind.String(kind),
	))
}

func recordTimerStart(ctx context.Context, result string) {
	if appMetrics == nil {
		return
	}
	appMetrics.TimerStarts.Add(ctx, 1, metric.WithAttributes(attrResult.String(result)))
}

func recordTimerStop(ctx context.Context, action string) {
	if appMetrics == nil {
		return
	}
	appMetrics.TimerStops.Add(ctx, 1, metric.WithAttributes(attrOperation.String(action)))
}

func recordTrackedSeconds(ctx context.Context, seconds int64) {
	if appMetrics == nil {
		return
	}
	appMetrics.TrackedSeconds.Record(ctx, seconds)
}
