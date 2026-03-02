from fastapi import FastAPI
from .database import engine
from . import models
from .routes import game, users, auth

# Create all tables in the database.
# This should ideally be handled by a migration tool like Alembic in production.
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Pixel Life Simulator API",
    description="API for the Pixel Life Simulator financial literacy game.",
    version="0.1.0",
)

app.include_router(auth.router)
app.include_router(game.router)
app.include_router(users.router)


@app.get("/", tags=["Root"])
async def read_root():
    """
    A simple endpoint to check if the API is running.
    """
    return {"message": "Welcome to the Pixel Life Simulator API!"}

# Further endpoints for game logic will be added here.
