package internal

import (
	"context"
	"fmt"
	"log/slog"
	"runtime/debug"

	"github.com/alexhokl/helper/telemetry"
	"go.opentelemetry.io/otel/trace"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// RecoveryInterceptor converts a panic in a handler into an INTERNAL gRPC
// error instead of letting it unwind through the gRPC server goroutine and
// terminate the process.
//
// It is deliberately the outermost interceptor in the chain so that it also
// covers panics raised by the interceptors that run after it, including the
// authentication interceptors. The panic value and stack trace are logged and
// recorded on the active span, but never returned to the client: the message
// could contain internal state, and a client can do nothing useful with it.
func RecoveryInterceptor(
	ctx context.Context,
	req any,
	info *grpc.UnaryServerInfo,
	handler grpc.UnaryHandler,
) (resp any, err error) {
	defer func() {
		recovered := recover()
		if recovered == nil {
			return
		}

		stack := debug.Stack()
		panicErr := fmt.Errorf("panic recovered in %s: %v", info.FullMethod, recovered)

		span := trace.SpanFromContext(ctx)
		telemetry.RecordSpanError(span, panicErr)

		slog.ErrorContext(
			ctx,
			"panic recovered in gRPC handler",
			slog.String("method", info.FullMethod),
			slog.Any("panic", recovered),
			slog.String("stack", string(stack)),
		)

		// Discard any partially built response so a half-populated message is
		// never sent alongside an error.
		resp = nil
		err = status.Error(codes.Internal, "internal server error")
	}()

	return handler(ctx, req)
}
