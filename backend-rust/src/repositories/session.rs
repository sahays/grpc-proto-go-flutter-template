use redis::{AsyncCommands, Client, RedisResult};
use std::time::Duration;
use uuid::Uuid;

pub struct SessionRepository {
    client: Client,
}

impl SessionRepository {
    pub fn new(client: Client) -> Self {
        Self { client }
    }

    pub async fn store_refresh_token(
        &self,
        user_id: Uuid,
        token: &str,
        ttl: Duration,
    ) -> RedisResult<()> {
        let mut conn = self.client.get_multiplexed_async_connection().await?;
        let key = format!("refresh_token:{}", user_id);
        let _: () = conn.set_ex(key, token, ttl.as_secs()).await?;
        Ok(())
    }

    pub async fn check_rate_limit(&self, ip: &str, limit: usize, window: Duration) -> RedisResult<bool> {
        let mut conn = self.client.get_multiplexed_async_connection().await?;
        let key = format!("rate_limit:{}", ip);
        
        let count: usize = conn.incr(&key, 1).await?;
        if count == 1 {
             let _: bool = conn.expire(&key, window.as_secs().try_into().unwrap()).await?;
        }

        Ok(count <= limit)
    }

    pub async fn store_reset_token(&self, token: &str, user_id: Uuid, ttl: Duration) -> RedisResult<()> {
        let mut conn = self.client.get_multiplexed_async_connection().await?;
        let key = format!("reset_token:{}", token);
        let _: () = conn.set_ex(key, user_id.to_string(), ttl.as_secs()).await?;
        Ok(())
    }

    pub async fn get_user_id_from_reset_token(&self, token: &str) -> RedisResult<Option<Uuid>> {
        let mut conn = self.client.get_multiplexed_async_connection().await?;
        let key = format!("reset_token:{}", token);
        let user_id_str: Option<String> = conn.get(&key).await?;

        match user_id_str {
            Some(s) => Ok(Uuid::parse_str(&s).ok()),
            None => Ok(None),
        }
    }
}
