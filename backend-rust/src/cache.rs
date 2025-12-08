use redis::{Client, RedisError};

pub fn init_client(redis_url: &str) -> Result<Client, RedisError> {
    Client::open(redis_url)
}
