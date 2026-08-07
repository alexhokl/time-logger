// Package internal holds the gRPC service implementations, server
// interceptors, and observability wiring for the time logger.
package internal

import (
	"context"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// contextKeyUser is the context key under which the authentication
// interceptors store the authenticated user's ID. It is an unexported empty
// struct so no other package can collide with it or read it without going
// through userIDFromContext.
type contextKeyUser struct{}

// withUserID returns a context carrying the authenticated user's ID.
func withUserID(ctx context.Context, userID uint) context.Context {
	return context.WithValue(ctx, contextKeyUser{}, userID)
}

// userIDFromContext extracts the authenticated user's ID. Every handler calls
// this first: a missing value means the request bypassed an authentication
// interceptor, which is treated as unauthenticated rather than as a programming
// error, so that a misconfigured server fails closed.
func userIDFromContext(ctx context.Context) (uint, error) {
	userID, ok := ctx.Value(contextKeyUser{}).(uint)
	if !ok || userID == 0 {
		return 0, status.Error(codes.Unauthenticated, "unauthenticated")
	}
	return userID, nil
}
