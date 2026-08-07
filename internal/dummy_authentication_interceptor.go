package internal

import (
	"context"

	"google.golang.org/grpc"
)

// DummyAuthenticationInterceptor is a placeholder for an authentication interceptor.
func DummyAuthenticationInterceptor(
	ctx context.Context,
	req any,
	info *grpc.UnaryServerInfo,
	handler grpc.UnaryHandler,
) (any, error) {
	ctx = withUserID(ctx, uint(1))
	resp, err := handler(ctx, req)
	if err != nil {
		recordAuthAttempt(ctx, "dummy", "failure")
	} else {
		recordAuthAttempt(ctx, "dummy", "success")
	}
	return resp, err
}
