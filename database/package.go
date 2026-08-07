// Package database defines the GORM models and schema operations for the time
// logger. Every user-owned model carries a UserID; handlers are responsible for
// scoping their queries by it, which is the only authorization mechanism in the
// system.
package database
