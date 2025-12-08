use config::ConfigError;
use thiserror::Error;
use tonic::Status;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("Database error: {0}")]
    DbError(#[from] sqlx::Error),
    #[error("Redis error: {0}")]
    RedisError(#[from] redis::RedisError),
    #[error("Validation error: {0}")]
    ValidationError(#[from] validator::ValidationErrors),
    #[error("Password hashing error: {0}")]
    PasswordHashError(String),
    #[error("JWT error: {0}")]
    JwtError(#[from] jsonwebtoken::errors::Error),
    #[error("Unauthorized: {0}")]
    Unauthorized(String),
    #[error("Bad Request: {0}")]
    BadRequest(String),
    #[error("Not Found: {0}")]
    NotFound(String),
    #[error("Internal server error: {0}")]
    Internal(String),
    #[error("Configuration error: {0}")]
    ConfigError(String),
    #[error("Transport error: {0}")]
    TransportError(#[from] tonic::transport::Error),
    #[error("Address parse error: {0}")]
    AddrParseError(String),
}

impl From<argon2::password_hash::Error> for AppError {
    fn from(err: argon2::password_hash::Error) -> Self {
        AppError::PasswordHashError(err.to_string())
    }
}

impl From<config::ConfigError> for AppError {
    fn from(err: config::ConfigError) -> Self {
        AppError::ConfigError(err.to_string())
    }
}

impl From<std::net::AddrParseError> for AppError {
    fn from(err: std::net::AddrParseError) -> Self {
        AppError::AddrParseError(err.to_string())
    }
}

impl From<AppError> for Status {
    fn from(err: AppError) -> Self {
        match err {
            AppError::DbError(e) => Status::internal(format!("Database error: {}", e)),
            AppError::RedisError(e) => Status::internal(format!("Redis error: {}", e)),
            AppError::ValidationError(e) => {
                Status::invalid_argument(format!("Validation error: {}", e))
            }
            AppError::PasswordHashError(e) => {
                Status::internal(format!("Password hashing error: {}", e))
            }
            AppError::JwtError(e) => Status::unauthenticated(format!("JWT error: {}", e)),
            AppError::Unauthorized(msg) => Status::unauthenticated(msg),
            AppError::BadRequest(msg) => Status::invalid_argument(msg),
            AppError::NotFound(msg) => Status::not_found(msg),
            AppError::Internal(msg) => Status::internal(msg),
            AppError::ConfigError(msg) => Status::internal(format!("Configuration error: {}", msg)),
            AppError::TransportError(e) => Status::internal(format!("Transport error: {}", e)),
            AppError::AddrParseError(msg) => {
                Status::internal(format!("Address parse error: {}", msg))
            }
        }
    }
}
