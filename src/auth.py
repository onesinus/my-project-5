from datetime import datetime, timezone
from typing import Any, cast
from uuid import uuid4

from fastapi import HTTPException, status
from passlib.context import CryptContext
from pydantic import BaseModel, EmailStr

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

users_db: dict[str, Any] = {}


class UserCreate(BaseModel):
    email: EmailStr
    password: str
    name: str | None = None


class UserResponse(BaseModel):
    id: str
    email: str
    name: str | None
    created_at: str


class Token(BaseModel):
    access_token: str
    token_type: str


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return cast(bool, pwd_context.verify(plain_password, hashed_password))


def get_password_hash(password: str) -> str:
    return cast(str, pwd_context.hash(password))


def create_access_token(data: dict[str, Any]) -> str:
    from jose import jwt

    secret_key = "development-secret-key-change-in-production"  # pragma: allowlist secret
    algorithm = "HS256"

    to_encode = data.copy()
    to_encode["sub"] = str(to_encode.get("sub", ""))
    return cast(str, jwt.encode(to_encode, secret_key, algorithm=algorithm))


def register_user(user_data: UserCreate) -> UserResponse:
    for existing in users_db.values():
        if existing["email"] == user_data.email:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Email already registered",
            )

    user_id = str(uuid4())
    hashed_password = get_password_hash(user_data.password)

    user: dict[str, Any] = {
        "id": user_id,
        "email": user_data.email,
        "name": user_data.name,
        "password_hash": hashed_password,
        "created_at": datetime.now(timezone.utc).isoformat(),  # noqa: UP017
    }
    users_db[user_id] = user

    return UserResponse(
        id=user["id"],
        email=user["email"],
        name=user["name"],
        created_at=user["created_at"],
    )


def authenticate_user(email: str, password: str) -> UserResponse:
    for user in users_db.values():
        if user["email"] == email:
            if not verify_password(password, user["password_hash"]):
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Incorrect password",
                )
            return UserResponse(
                id=user["id"],
                email=user["email"],
                name=user["name"],
                created_at=user["created_at"],
            )

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="User not found",
    )
