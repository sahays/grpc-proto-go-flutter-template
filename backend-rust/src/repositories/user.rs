use crate::models::user::User;
use sqlx::{PgPool, Result};
use std::sync::Arc;
use uuid::Uuid;

#[derive(Debug)]
pub struct UserRepository {
    pool: Arc<PgPool>,
}

impl UserRepository {
    pub fn new(pool: Arc<PgPool>) -> Self {
        Self { pool }
    }

    pub async fn create(
        &self,
        email: &str,
        password_hash: &str,
        first_name: &str,
        last_name: &str,
    ) -> Result<User> {
        let user = sqlx::query_as::<_, User>(
            r#"
            INSERT INTO users (email, password_hash, first_name, last_name)
            VALUES ($1, $2, $3, $4)
            RETURNING *
            "#,
        )
        .bind(email)
        .bind(password_hash)
        .bind(first_name)
        .bind(last_name)
        .fetch_one(&*self.pool)
        .await?;

        Ok(user)
    }

    pub async fn find_by_email(&self, email: &str) -> Result<Option<User>> {
        let user = sqlx::query_as::<_, User>(
            r#"
            SELECT * FROM users WHERE email = $1
            "#,
        )
        .bind(email)
        .fetch_optional(&*self.pool)
        .await?;

        Ok(user)
    }

    pub async fn find_by_id(&self, id: Uuid) -> Result<Option<User>> {
        let user = sqlx::query_as::<_, User>(
            r#"
            SELECT * FROM users WHERE id = $1
            "#,
        )
        .bind(id)
        .fetch_optional(&*self.pool)
        .await?;

        Ok(user)
    }

    pub async fn update_password(&self, id: Uuid, new_password_hash: &str) -> Result<()> {
        sqlx::query(
            r#"
            UPDATE users SET password_hash = $1 WHERE id = $2
            "#,
        )
        .bind(new_password_hash)
        .bind(id)
        .execute(&*self.pool)
        .await?;

        Ok(())
    }

    pub async fn update_last_login(&self, id: Uuid) -> Result<()> {
        sqlx::query(
            r#"
            UPDATE users SET last_login_at = NOW() WHERE id = $1
            "#,
        )
        .bind(id)
        .execute(&*self.pool)
        .await?;

        Ok(())
    }
}
