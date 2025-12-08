use tonic::{transport::Server, Request, Response, Status};
use tracing::{info, error};
use sqlx::PgPool;
use std::sync::Arc;
use redis::Client;

mod cache;
mod config;
mod db;
mod models;
mod repositories;
mod utils;

pub mod auth {
    tonic::include_proto!("auth");
}

use auth::auth_service_server::{AuthService, AuthServiceServer};
use auth::{LoginRequest, LoginResponse, SignUpRequest, SignUpResponse, ForgotPasswordRequest, ForgotPasswordResponse, ResetPasswordRequest, ResetPasswordResponse, ValidateTokenRequest, ValidateTokenResponse};
use config::Settings;

#[derive(Debug)]
pub struct MyAuthService {
    pub pool: Arc<PgPool>,
    pub redis_client: Client,
}

#[tonic::async_trait]
impl AuthService for MyAuthService {
    async fn sign_up(&self, request: Request<SignUpRequest>) -> Result<Response<SignUpResponse>, Status> {
        info!("Got a request: {:?}", request);

        let reply = SignUpResponse {
            success: true,
            message: "User signed up successfully".into(),
            user: None,
        };

        Ok(Response::new(reply))
    }

    async fn login(&self, request: Request<LoginRequest>) -> Result<Response<LoginResponse>, Status> {
        info!("Got a request: {:?}", request);

        let reply = LoginResponse {
            access_token: "some_access_token".into(),
            refresh_token: "some_refresh_token".into(),
            expires_in: 3600,
            user: None,
        };

        Ok(Response::new(reply))
    }

    async fn forgot_password(&self, request: Request<ForgotPasswordRequest>) -> Result<Response<ForgotPasswordResponse>, Status> {
        info!("Got a request: {:?}", request);

        let reply = ForgotPasswordResponse {
            success: true,
            message: "Password reset email sent".into(),
        };

        Ok(Response::new(reply))
    }

    async fn reset_password(&self, request: Request<ResetPasswordRequest>) -> Result<Response<ResetPasswordResponse>, Status> {
        info!("Got a request: {:?}", request);

        let reply = ResetPasswordResponse {
            success: true,
            message: "Password reset successfully".into(),
        };

        Ok(Response::new(reply))
    }

    async fn validate_token(&self, request: Request<ValidateTokenRequest>) -> Result<Response<ValidateTokenResponse>, Status> {
        info!("Got a request: {:?}", request);

        let reply = ValidateTokenResponse {
            valid: true,
            user: None,
            message: "Token is valid".into(),
        };

        Ok(Response::new(reply))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // 1. Initialize logging
    tracing_subscriber::fmt::init();

    // 2. Load configuration
    let settings = Settings::new().map_err(|e| {
        error!("Failed to load configuration: {}", e);
        e
    })?;

    // 3. Initialize Database Pool
    let pool = db::init_pool(&settings.database_url).await.map_err(|e| {
        error!("Failed to connect to database: {}", e);
        e
    })?;
    
    let pool_arc = Arc::new(pool);

    // 4. Initialize Redis Client
    let redis_client = cache::init_client(&settings.redis_url).map_err(|e| {
        error!("Failed to connect to redis: {}", e);
        e
    })?;

    let addr = format!("{}:{}", settings.server_host, settings.server_port).parse()?;
    let auth_service = MyAuthService { 
        pool: pool_arc,
        redis_client,
    };

    info!("AuthService server listening on {}", addr);

    Server::builder()
        .add_service(AuthServiceServer::new(auth_service))
        .serve(addr)
        .await?;

    Ok(())
}