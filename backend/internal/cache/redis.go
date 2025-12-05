package cache

import (
	"context"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
	"github.com/sahays/grpc-proto-go-flutter-template/internal/config"
)

// Cache wraps the Redis client
type Cache struct {
	client *redis.Client
	config *config.Config
}

// New creates a new Redis cache client
func New(cfg *config.Config) (*Cache, error) {
	client := redis.NewClient(&redis.Options{
		Addr:         cfg.GetRedisAddr(),
		Password:     cfg.Redis.Password,
		DB:           cfg.Redis.DB,
		MaxRetries:   cfg.Redis.MaxRetries,
		PoolSize:     cfg.Redis.PoolSize,
		DialTimeout:  5 * time.Second,
		ReadTimeout:  3 * time.Second,
		WriteTimeout: 3 * time.Second,
	})

	// Verify connection
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := client.Ping(ctx).Err(); err != nil {
		return nil, fmt.Errorf("failed to connect to Redis: %w", err)
	}

	return &Cache{
		client: client,
		config: cfg,
	}, nil
}

// Close closes the Redis connection
func (c *Cache) Close() error {
	return c.client.Close()
}

// Health checks Redis health
func (c *Cache) Health(ctx context.Context) error {
	ctx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()

	if err := c.client.Ping(ctx).Err(); err != nil {
		return fmt.Errorf("Redis ping failed: %w", err)
	}

	return nil
}

// Set stores a key-value pair with TTL
func (c *Cache) Set(ctx context.Context, key string, value interface{}, ttl time.Duration) error {
	return c.client.Set(ctx, key, value, ttl).Err()
}

// Get retrieves a value by key
func (c *Cache) Get(ctx context.Context, key string) (string, error) {
	val, err := c.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return "", fmt.Errorf("key not found: %s", key)
	}
	if err != nil {
		return "", err
	}
	return val, nil
}

// Delete removes a key
func (c *Cache) Delete(ctx context.Context, keys ...string) error {
	return c.client.Del(ctx, keys...).Err()
}

// Exists checks if a key exists
func (c *Cache) Exists(ctx context.Context, key string) (bool, error) {
	count, err := c.client.Exists(ctx, key).Result()
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

// SetNX sets a key only if it doesn't exist (for distributed locks)
func (c *Cache) SetNX(ctx context.Context, key string, value interface{}, ttl time.Duration) (bool, error) {
	return c.client.SetNX(ctx, key, value, ttl).Result()
}

// Expire sets a TTL on an existing key
func (c *Cache) Expire(ctx context.Context, key string, ttl time.Duration) error {
	return c.client.Expire(ctx, key, ttl).Err()
}

// Increment increments a counter (for rate limiting)
func (c *Cache) Increment(ctx context.Context, key string) (int64, error) {
	return c.client.Incr(ctx, key).Result()
}

// IncrementBy increments a counter by a specific amount
func (c *Cache) IncrementBy(ctx context.Context, key string, value int64) (int64, error) {
	return c.client.IncrBy(ctx, key, value).Result()
}

// SetRefreshToken stores a refresh token with user ID
func (c *Cache) SetRefreshToken(ctx context.Context, tokenID, userID string, ttl time.Duration) error {
	key := fmt.Sprintf("refresh_token:%s", tokenID)
	return c.Set(ctx, key, userID, ttl)
}

// GetRefreshToken retrieves user ID from refresh token
func (c *Cache) GetRefreshToken(ctx context.Context, tokenID string) (string, error) {
	key := fmt.Sprintf("refresh_token:%s", tokenID)
	return c.Get(ctx, key)
}

// DeleteRefreshToken removes a refresh token
func (c *Cache) DeleteRefreshToken(ctx context.Context, tokenID string) error {
	key := fmt.Sprintf("refresh_token:%s", tokenID)
	return c.Delete(ctx, key)
}

// SetPasswordResetToken stores a password reset token
func (c *Cache) SetPasswordResetToken(ctx context.Context, token, userID string, ttl time.Duration) error {
	key := fmt.Sprintf("password_reset:%s", token)
	return c.Set(ctx, key, userID, ttl)
}

// GetPasswordResetToken retrieves user ID from password reset token
func (c *Cache) GetPasswordResetToken(ctx context.Context, token string) (string, error) {
	key := fmt.Sprintf("password_reset:%s", token)
	return c.Get(ctx, key)
}

// DeletePasswordResetToken removes a password reset token
func (c *Cache) DeletePasswordResetToken(ctx context.Context, token string) error {
	key := fmt.Sprintf("password_reset:%s", token)
	return c.Delete(ctx, key)
}

// TrackLoginAttempt tracks failed login attempts for rate limiting
func (c *Cache) TrackLoginAttempt(ctx context.Context, identifier string, ttl time.Duration) (int64, error) {
	key := fmt.Sprintf("login_attempts:%s", identifier)
	count, err := c.Increment(ctx, key)
	if err != nil {
		return 0, err
	}

	// Set TTL on first attempt
	if count == 1 {
		if err := c.Expire(ctx, key, ttl); err != nil {
			return count, err
		}
	}

	return count, nil
}

// ClearLoginAttempts clears login attempt tracking
func (c *Cache) ClearLoginAttempts(ctx context.Context, identifier string) error {
	key := fmt.Sprintf("login_attempts:%s", identifier)
	return c.Delete(ctx, key)
}

// Stats returns Redis statistics
func (c *Cache) Stats(ctx context.Context) *redis.PoolStats {
	return c.client.PoolStats()
}
