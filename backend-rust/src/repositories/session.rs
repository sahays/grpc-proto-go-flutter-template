use chrono::Duration;
use redis::{AsyncCommands, Client, RedisResult};
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
        let _: () = conn.set_ex(key, token, ttl.num_seconds() as u64).await?;
        Ok(())
    }

    pub async fn store_reset_token(
        &self,
        token: &str,
        user_id: Uuid,
        ttl: Duration,
    ) -> RedisResult<()> {
        let mut conn = self.client.get_multiplexed_async_connection().await?;
        let key = format!("reset_token:{}", token);
        let _: () = conn
            .set_ex(key, user_id.to_string(), ttl.num_seconds() as u64)
            .await?;
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
