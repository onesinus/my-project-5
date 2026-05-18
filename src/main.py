from datetime import UTC, datetime

from fastapi import FastAPI

from auth import (
    Token,
    UserCreate,
    UserResponse,
    authenticate_user,
    create_access_token,
    register_user,
)

app = FastAPI(title="my-project-5", version="0.1.0")


@app.get("/health")
async def health() -> dict[str, str]:
    return {"status": "ok", "timestamp": datetime.now(UTC).isoformat()}


@app.get("/api/hello")
async def hello() -> dict[str, str]:
    return {"message": "Hello from Flow-First SDLC!", "stack": "FastAPI + Python"}


@app.post("/api/auth/register", response_model=UserResponse, status_code=201)
async def register(user_data: UserCreate) -> UserResponse:
    return register_user(user_data)


@app.post("/api/auth/login", response_model=Token)
async def login(email: str, password: str) -> Token:
    user = authenticate_user(email, password)
    access_token = create_access_token({"sub": user.id, "email": user.email})
    return Token(access_token=access_token, token_type="bearer")
