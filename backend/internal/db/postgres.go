package db

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"github.com/sahays/grpc-proto-go-flutter-template/internal/config"
	_ "github.com/lib/pq"
)

// DB wraps the database connection
type DB struct {
	*sql.DB
	config *config.Config
}

// New creates a new database connection
func New(cfg *config.Config) (*DB, error) {
	dsn := cfg.GetDatabaseDSN()

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %w", err)
	}

	// Set connection pool settings
	db.SetMaxOpenConns(cfg.Database.MaxOpenConns)
	db.SetMaxIdleConns(cfg.Database.MaxIdleConns)
	db.SetConnMaxLifetime(cfg.Database.ConnMaxLifetime)

	// Verify connection
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := db.PingContext(ctx); err != nil {
		return nil, fmt.Errorf("failed to ping database: %w", err)
	}

	return &DB{
		DB:     db,
		config: cfg,
	}, nil
}

// Close closes the database connection
func (db *DB) Close() error {
	return db.DB.Close()
}

// Health checks database health
func (db *DB) Health(ctx context.Context) error {
	ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()

	if err := db.PingContext(ctx); err != nil {
		return fmt.Errorf("database ping failed: %w", err)
	}

	// Check if we can execute a simple query
	var result int
	err := db.QueryRowContext(ctx, "SELECT 1").Scan(&result)
	if err != nil {
		return fmt.Errorf("database query failed: %w", err)
	}

	return nil
}

// Stats returns database statistics
func (db *DB) Stats() sql.DBStats {
	return db.DB.Stats()
}

// RunMigrations runs database migrations
// Note: In production, use migrate CLI or a migration library
func (db *DB) RunMigrations(ctx context.Context) error {
	// This is a placeholder - actual migrations should be run using golang-migrate CLI
	// or a migration library in production

	// For now, just check if migrations table exists
	var exists bool
	query := `
		SELECT EXISTS (
			SELECT FROM information_schema.tables
			WHERE table_schema = 'public'
			AND table_name = 'users'
		)
	`

	err := db.QueryRowContext(ctx, query).Scan(&exists)
	if err != nil {
		return fmt.Errorf("failed to check migrations: %w", err)
	}

	return nil
}
