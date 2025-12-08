use chrono::{Duration, Utc};
use jsonwebtoken::{DecodingKey, EncodingKey, Header, Validation, decode, encode};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

#[derive(Debug, Serialize, Deserialize)]
pub struct Claims {
    pub sub: String, // Subject (User ID)
    pub exp: usize,  // Expiration time (as UTC timestamp)
    pub iat: usize,  // Issued at (as UTC timestamp)
}

pub struct TokenManager {
    secret: String,
}

impl TokenManager {
    pub fn new(secret: String) -> Self {
        Self { secret }
    }

    pub fn generate_access_token(
        &self,
        user_id: Uuid,
    ) -> Result<(String, usize), jsonwebtoken::errors::Error> {
        let now = Utc::now();
        let expiration = now + Duration::hours(1); // 1 hour expiration for access token
        let exp = expiration.timestamp() as usize;
        let iat = now.timestamp() as usize;

        let claims = Claims {
            sub: user_id.to_string(),
            exp,
            iat,
        };

        let token = encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(self.secret.as_bytes()),
        )?;

        Ok((token, exp))
    }

    pub fn generate_refresh_token(
        &self,
        user_id: Uuid,
    ) -> Result<(String, usize), jsonwebtoken::errors::Error> {
        let now = Utc::now();
        let expiration = now + Duration::days(7); // 7 days expiration for refresh token
        let exp = expiration.timestamp() as usize;
        let iat = now.timestamp() as usize;

        let claims = Claims {
            sub: user_id.to_string(),
            exp,
            iat,
        };

        // Note: Ideally, refresh tokens might use a different secret or be opaque strings stored in DB.
        // For parity with common JWT setups, we'll sign it.
        let token = encode(
            &Header::default(),
            &claims,
            &EncodingKey::from_secret(self.secret.as_bytes()),
        )?;

        Ok((token, exp))
    }

    pub fn validate_token(&self, token: &str) -> Result<Claims, jsonwebtoken::errors::Error> {
        let token_data = decode::<Claims>(
            token,
            &DecodingKey::from_secret(self.secret.as_bytes()),
            &Validation::default(),
        )?;

        Ok(token_data.claims)
    }
}
