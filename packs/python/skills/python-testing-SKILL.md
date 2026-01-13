# Python Testing Skill

## Description

You MUST use this skill before writing any tests. This applies to unit tests, integration tests, API tests, and any pytest-based testing.

---

## Purpose

Write complete, production-ready tests that:
- Follow pytest best practices
- Are maintainable and readable
- Cover edge cases
- Use appropriate fixtures
- Run reliably in CI

## When to Use

- Writing tests for new code
- Adding tests to existing code
- Creating test fixtures
- Setting up integration tests

## Prerequisites

- Code to test exists
- pytest and pytest-asyncio installed
- Understanding of what to test

## Process

### Step 1: Create Test File

```python
"""Tests for user service."""
from __future__ import annotations

from typing import TYPE_CHECKING

import pytest

from myproject.services.user import UserService
from myproject.models.user import User

if TYPE_CHECKING:
    from unittest.mock import Mock
```

### Step 2: Write Fixtures

```python
"""Test fixtures in conftest.py or test file."""
import pytest
from unittest.mock import AsyncMock, Mock


@pytest.fixture
def mock_repository() -> Mock:
    """Provide mock repository."""
    repo = Mock()
    repo.get = AsyncMock(return_value=None)
    repo.create = AsyncMock()
    repo.update = AsyncMock()
    repo.delete = AsyncMock(return_value=True)
    return repo


@pytest.fixture
def service(mock_repository: Mock) -> UserService:
    """Provide service instance with mocked dependencies."""
    return UserService(repository=mock_repository)


@pytest.fixture
def sample_user() -> User:
    """Provide sample user for testing."""
    return User(
        id=1,
        email="test@example.com",
        name="Test User",
    )


@pytest.fixture
def user_data() -> dict[str, str]:
    """Provide sample user creation data."""
    return {
        "email": "new@example.com",
        "name": "New User",
        "password": "SecurePass1",
    }
```

### Step 3: Write Test Classes

**Group related tests in classes:**

```python
class TestUserServiceCreate:
    """Tests for UserService.create method."""

    async def test_creates_user_with_valid_data(
        self,
        service: UserService,
        mock_repository: Mock,
        user_data: dict[str, str],
    ) -> None:
        """Valid data creates user successfully."""
        mock_repository.create.return_value = User(
            id=1,
            email=user_data["email"],
            name=user_data["name"],
        )

        result = await service.create(**user_data)

        assert result.email == user_data["email"]
        assert result.name == user_data["name"]
        mock_repository.create.assert_called_once()

    async def test_raises_on_empty_email(
        self, service: UserService
    ) -> None:
        """Empty email raises ValueError."""
        with pytest.raises(ValueError, match="email.*required"):
            await service.create(email="", name="Test", password="Pass1234")

    async def test_raises_on_duplicate_email(
        self,
        service: UserService,
        mock_repository: Mock,
    ) -> None:
        """Duplicate email raises DuplicateError."""
        mock_repository.create.side_effect = DuplicateEmailError("exists")

        with pytest.raises(DuplicateEmailError):
            await service.create(
                email="dupe@example.com",
                name="Test",
                password="Pass1234",
            )


class TestUserServiceGet:
    """Tests for UserService.get method."""

    async def test_returns_user_when_exists(
        self,
        service: UserService,
        mock_repository: Mock,
        sample_user: User,
    ) -> None:
        """Returns user when found."""
        mock_repository.get.return_value = sample_user

        result = await service.get(1)

        assert result == sample_user
        mock_repository.get.assert_called_once_with(1)

    async def test_returns_none_when_missing(
        self,
        service: UserService,
        mock_repository: Mock,
    ) -> None:
        """Returns None when user not found."""
        mock_repository.get.return_value = None

        result = await service.get(999)

        assert result is None
```

### Step 4: Parametrized Tests

```python
class TestEmailValidation:
    """Tests for email validation."""

    @pytest.mark.parametrize(
        "email,expected_valid",
        [
            ("user@example.com", True),
            ("user.name@example.co.uk", True),
            ("user+tag@example.com", True),
            ("invalid", False),
            ("@example.com", False),
            ("user@", False),
            ("", False),
        ],
        ids=[
            "standard_email",
            "subdomain_email",
            "plus_tag_email",
            "no_at_sign",
            "no_local_part",
            "no_domain",
            "empty_string",
        ],
    )
    def test_validates_email_format(
        self, email: str, expected_valid: bool
    ) -> None:
        """Email validation correctly identifies valid/invalid emails."""
        if expected_valid:
            assert validate_email(email) is True
        else:
            with pytest.raises(ValueError):
                validate_email(email)
```

### Step 5: Async Tests

```python
"""Async test patterns."""
import asyncio
import pytest


class TestAsyncOperations:
    """Tests for async operations."""

    async def test_async_function(self) -> None:
        """Async function works correctly."""
        result = await async_function()
        assert result == expected

    async def test_concurrent_operations(self) -> None:
        """Multiple async operations run concurrently."""
        results = await asyncio.gather(
            async_op_1(),
            async_op_2(),
            async_op_3(),
        )
        assert len(results) == 3

    async def test_timeout_handling(self) -> None:
        """Operation respects timeout."""
        with pytest.raises(asyncio.TimeoutError):
            async with asyncio.timeout(0.1):
                await slow_operation()
```

### Step 6: Exception Testing

```python
class TestExceptionHandling:
    """Tests for exception scenarios."""

    def test_raises_value_error_on_invalid_input(self) -> None:
        """Invalid input raises ValueError with message."""
        with pytest.raises(ValueError) as exc_info:
            process_data(invalid_data)

        assert "invalid format" in str(exc_info.value).lower()

    def test_raises_type_error_on_wrong_type(self) -> None:
        """Wrong type raises TypeError."""
        with pytest.raises(TypeError, match="expected str"):
            process_data(123)

    async def test_retries_on_transient_error(
        self, mock_client: Mock
    ) -> None:
        """Retries operation on transient failure."""
        mock_client.fetch.side_effect = [
            TransientError("retry"),
            TransientError("retry"),
            {"data": "success"},
        ]

        result = await fetch_with_retry(mock_client)

        assert result == {"data": "success"}
        assert mock_client.fetch.call_count == 3
```

### Step 7: API Tests

```python
"""API endpoint tests."""
import pytest
from httpx import AsyncClient
from fastapi import status


class TestUserEndpoints:
    """Tests for user API endpoints."""

    async def test_create_user(self, client: AsyncClient) -> None:
        """POST /users creates user."""
        response = await client.post(
            "/users/",
            json={
                "email": "test@example.com",
                "name": "Test User",
                "password": "SecurePass1",
            },
        )

        assert response.status_code == status.HTTP_201_CREATED
        data = response.json()
        assert data["email"] == "test@example.com"
        assert "password" not in data

    async def test_get_user_not_found(self, client: AsyncClient) -> None:
        """GET /users/{id} returns 404 for missing user."""
        response = await client.get("/users/99999")

        assert response.status_code == status.HTTP_404_NOT_FOUND

    async def test_list_users_pagination(self, client: AsyncClient) -> None:
        """GET /users respects pagination params."""
        response = await client.get(
            "/users/",
            params={"page": 2, "size": 5},
        )

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert data["page"] == 2
        assert data["size"] == 5
```

## Testing Patterns

### Arrange-Act-Assert

```python
def test_user_creation() -> None:
    """User creation stores correct data."""
    # Arrange
    name = "Test User"
    email = "test@example.com"

    # Act
    user = User(name=name, email=email)

    # Assert
    assert user.name == name
    assert user.email == email
```

### Test Naming

```python
# Good: Descriptive names
def test_create_user_with_valid_email_succeeds() -> None: ...
def test_create_user_with_empty_email_raises_value_error() -> None: ...
def test_delete_user_returns_true_when_user_exists() -> None: ...

# Bad: Vague names
def test_create_user() -> None: ...
def test_error() -> None: ...
def test_1() -> None: ...
```

### Mocking Best Practices

```python
from unittest.mock import Mock, AsyncMock, patch, MagicMock

# Mock return value
mock.method.return_value = "value"

# Mock async return value
mock.async_method = AsyncMock(return_value="value")

# Mock side effect (exception)
mock.method.side_effect = ValueError("error")

# Mock side effect (sequence)
mock.method.side_effect = ["first", "second", "third"]

# Verify calls
mock.method.assert_called_once()
mock.method.assert_called_with(arg1, arg2)
mock.method.assert_not_called()

# Patch decorator
@patch("mymodule.external_function")
def test_something(mock_func: Mock) -> None:
    mock_func.return_value = "mocked"
    result = function_under_test()
    mock_func.assert_called_once()
```

## Output Checklist

Before marking complete:

- [ ] Tests are in tests/ directory
- [ ] Test file named test_*.py
- [ ] Test class named Test*
- [ ] Test methods named test_*
- [ ] Type hints on fixtures
- [ ] Docstrings describe what's tested
- [ ] Edge cases covered
- [ ] Mocks used appropriately
- [ ] Tests pass: `pytest -v`

---

**This skill creates comprehensive, maintainable tests following pytest best practices.**
