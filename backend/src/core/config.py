import os
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    # JWT Settings
    SECRET_KEY: str = "your_super_secret_key_that_should_be_in_an_env_file"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    class Config:
        # If you have a .env file, it will be loaded from there
        env_file = ".env"


settings = Settings()
