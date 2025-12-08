use crate::auth::{
    ForgotPasswordRequest, LoginRequest, ResetPasswordRequest, SignUpRequest, ValidateTokenRequest,
};
use validator::Validate;

#[derive(Debug, Validate)]
pub struct SignUpRequestDto {
    #[validate(email)]
    pub email: String,
    #[validate(length(min = 8, message = "Password must be at least 8 characters"))]
    pub password: String,
    #[validate(length(min = 1, message = "First name is required"))]
    pub first_name: String,
    #[validate(length(min = 1, message = "Last name is required"))]
    pub last_name: String,
}

impl TryFrom<SignUpRequest> for SignUpRequestDto {
    type Error = validator::ValidationErrors;

    fn try_from(req: SignUpRequest) -> Result<Self, Self::Error> {
        let dto = SignUpRequestDto {
            email: req.email,
            password: req.password,
            first_name: req.first_name,
            last_name: req.last_name,
        };
        dto.validate()?;
        Ok(dto)
    }
}

#[derive(Debug, Validate)]
pub struct LoginRequestDto {
    #[validate(email)]
    pub email: String,
    #[validate(length(min = 1, message = "Password is required"))]
    pub password: String,
}

impl TryFrom<LoginRequest> for LoginRequestDto {
    type Error = validator::ValidationErrors;

    fn try_from(req: LoginRequest) -> Result<Self, Self::Error> {
        let dto = LoginRequestDto {
            email: req.email,
            password: req.password,
        };
        dto.validate()?;
        Ok(dto)
    }
}

#[derive(Debug, Validate)]
pub struct ForgotPasswordRequestDto {
    #[validate(email)]
    pub email: String,
}

impl TryFrom<ForgotPasswordRequest> for ForgotPasswordRequestDto {
    type Error = validator::ValidationErrors;

    fn try_from(req: ForgotPasswordRequest) -> Result<Self, Self::Error> {
        let dto = ForgotPasswordRequestDto { email: req.email };
        dto.validate()?;
        Ok(dto)
    }
}

#[derive(Debug, Validate)]
pub struct ResetPasswordRequestDto {
    #[validate(length(min = 1, message = "Token is required"))]
    pub token: String,
    #[validate(length(min = 8, message = "New password must be at least 8 characters"))]
    pub new_password: String,
}

impl TryFrom<ResetPasswordRequest> for ResetPasswordRequestDto {
    type Error = validator::ValidationErrors;

    fn try_from(req: ResetPasswordRequest) -> Result<Self, Self::Error> {
        let dto = ResetPasswordRequestDto {
            token: req.token,
            new_password: req.new_password,
        };
        dto.validate()?;
        Ok(dto)
    }
}

#[derive(Debug, Validate)]
pub struct ValidateTokenRequestDto {
    #[validate(length(min = 1, message = "Token is required"))]
    pub access_token: String,
}

impl TryFrom<ValidateTokenRequest> for ValidateTokenRequestDto {
    type Error = validator::ValidationErrors;

    fn try_from(req: ValidateTokenRequest) -> Result<Self, Self::Error> {
        let dto = ValidateTokenRequestDto {
            access_token: req.access_token,
        };
        dto.validate()?;
        Ok(dto)
    }
}
