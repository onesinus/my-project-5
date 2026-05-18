import pytest
from unittest.mock import patch, MagicMock
from fastapi import HTTPException

from auth import (
    UserCreate,
    verify_password,
    get_password_hash,
    register_user,
    authenticate_user,
    users_db,
)


pytestmark = pytest.mark.unit


class TestPasswordHashing:
    def test_get_password_hash_returns_hash(self):
        password = "testpassword123"  # pragma: allowlist secret
        hashed = get_password_hash(password)
        assert hashed != password
        assert len(hashed) > 0

    def test_verify_password_correct(self):
        password = "testpassword123"  # pragma: allowlist secret
        hashed = get_password_hash(password)
        assert verify_password(password, hashed) is True

    def test_verify_password_incorrect(self):
        password = "testpassword123"  # pragma: allowlist secret
        wrong_password = "wrongpassword"  # pragma: allowlist secret
        hashed = get_password_hash(password)
        assert verify_password(wrong_password, hashed) is False


class TestRegisterUser:
    def setup_method(self):
        users_db.clear()

    def test_register_user_success(self):
        user_data = UserCreate(email="test@example.com", password="password123", name="Test User")
        result = register_user(user_data)

        assert result.email == "test@example.com"
        assert result.name == "Test User"
        assert result.id is not None
        assert result.created_at is not None

    def test_register_user_duplicate_email(self):
        user_data = UserCreate(email="test@example.com", password="password123")
        register_user(user_data)

        with pytest.raises(HTTPException) as exc_info:
            register_user(user_data)

        assert exc_info.value.status_code == 400
        assert exc_info.value.detail == "Email already registered"


class TestAuthenticateUser:
    def setup_method(self):
        users_db.clear()

    def test_authenticate_user_success(self):
        user_data = UserCreate(email="test@example.com", password="password123")
        register_user(user_data)

        result = authenticate_user("test@example.com", "password123")

        assert result.email == "test@example.com"
        assert result.id is not None

    def test_authenticate_user_wrong_password(self):
        user_data = UserCreate(email="test@example.com", password="password123")
        register_user(user_data)

        with pytest.raises(HTTPException) as exc_info:
            authenticate_user("test@example.com", "wrongpassword")

        assert exc_info.value.status_code == 401
        assert exc_info.value.detail == "Incorrect password"

    def test_authenticate_user_not_found(self):
        with pytest.raises(HTTPException) as exc_info:
            authenticate_user("nonexistent@example.com", "password123")

        assert exc_info.value.status_code == 401
        assert exc_info.value.detail == "User not found"
