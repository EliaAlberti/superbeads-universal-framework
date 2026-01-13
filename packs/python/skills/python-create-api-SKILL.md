# Python Create API Skill

## Description

You MUST use this skill before creating any API endpoint, router, or HTTP handler. This applies to FastAPI, Flask, or any web framework endpoints.

---

## Purpose

Generate complete, production-ready API endpoints that:
- Follow REST conventions
- Include proper validation
- Have comprehensive error handling
- Are documented with OpenAPI
- Are testable

## When to Use

- Creating new API endpoints
- Adding routers/blueprints
- Implementing CRUD operations
- Building webhook handlers

## Prerequisites

- Framework identified (FastAPI, Flask, etc.)
- Endpoint requirements clear
- Request/response schemas defined

## Process

### Step 1: Define Schemas

**Request/Response models (Pydantic):**

```python
"""Schemas for user endpoints."""
from __future__ import annotations

from datetime import datetime
from pydantic import BaseModel, Field, EmailStr, field_validator


class UserCreate(BaseModel):
    """Request body for creating a user."""

    email: EmailStr = Field(..., description="User's email address")
    name: str = Field(..., min_length=1, max_length=100, description="User's name")
    password: str = Field(..., min_length=8, description="Password (min 8 chars)")

    @field_validator("password")
    @classmethod
    def validate_password(cls, v: str) -> str:
        """Ensure password meets complexity requirements."""
        if not any(c.isupper() for c in v):
            raise ValueError("Password must contain uppercase letter")
        if not any(c.isdigit() for c in v):
            raise ValueError("Password must contain digit")
        return v


class UserUpdate(BaseModel):
    """Request body for updating a user."""

    name: str | None = Field(None, min_length=1, max_length=100)
    email: EmailStr | None = None


class UserResponse(BaseModel):
    """Response body for user data."""

    id: int
    email: str
    name: str
    created_at: datetime

    model_config = {"from_attributes": True}


class UserList(BaseModel):
    """Paginated list of users."""

    items: list[UserResponse]
    total: int
    page: int
    size: int


class ErrorResponse(BaseModel):
    """Standard error response."""

    detail: str
    code: str | None = None
```

### Step 2: Create Router (FastAPI)

```python
"""User API endpoints."""
from __future__ import annotations

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.dependencies import get_user_service
from app.services.user import UserService
from app.schemas.user import (
    UserCreate,
    UserUpdate,
    UserResponse,
    UserList,
    ErrorResponse,
)

router = APIRouter(prefix="/users", tags=["users"])


@router.post(
    "/",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
    responses={
        409: {"model": ErrorResponse, "description": "Email already exists"},
    },
)
async def create_user(
    data: UserCreate,
    service: Annotated[UserService, Depends(get_user_service)],
) -> UserResponse:
    """Create a new user.

    Creates a new user account with the provided information.
    Email must be unique across all users.
    """
    try:
        user = await service.create(data)
        return UserResponse.model_validate(user)
    except DuplicateEmailError as e:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=str(e),
        )


@router.get(
    "/",
    response_model=UserList,
)
async def list_users(
    service: Annotated[UserService, Depends(get_user_service)],
    page: Annotated[int, Query(ge=1)] = 1,
    size: Annotated[int, Query(ge=1, le=100)] = 20,
) -> UserList:
    """List all users with pagination.

    Returns a paginated list of users. Default page size is 20.
    """
    users, total = await service.list(page=page, size=size)
    return UserList(
        items=[UserResponse.model_validate(u) for u in users],
        total=total,
        page=page,
        size=size,
    )


@router.get(
    "/{user_id}",
    response_model=UserResponse,
    responses={
        404: {"model": ErrorResponse, "description": "User not found"},
    },
)
async def get_user(
    user_id: int,
    service: Annotated[UserService, Depends(get_user_service)],
) -> UserResponse:
    """Get a user by ID.

    Returns the user with the specified ID.
    """
    user = await service.get(user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User {user_id} not found",
        )
    return UserResponse.model_validate(user)


@router.patch(
    "/{user_id}",
    response_model=UserResponse,
    responses={
        404: {"model": ErrorResponse, "description": "User not found"},
    },
)
async def update_user(
    user_id: int,
    data: UserUpdate,
    service: Annotated[UserService, Depends(get_user_service)],
) -> UserResponse:
    """Update a user.

    Partially updates the user with the provided fields.
    Only non-null fields are updated.
    """
    user = await service.update(user_id, data)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User {user_id} not found",
        )
    return UserResponse.model_validate(user)


@router.delete(
    "/{user_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    responses={
        404: {"model": ErrorResponse, "description": "User not found"},
    },
)
async def delete_user(
    user_id: int,
    service: Annotated[UserService, Depends(get_user_service)],
) -> None:
    """Delete a user.

    Permanently removes the user from the system.
    """
    deleted = await service.delete(user_id)
    if not deleted:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User {user_id} not found",
        )
```

### Step 3: Create Dependencies

```python
"""FastAPI dependencies."""
from __future__ import annotations

from typing import Annotated, AsyncIterator

from fastapi import Depends

from app.database import get_session
from app.services.user import UserService
from app.repositories.user import UserRepository


async def get_user_repository(
    session: Annotated[AsyncSession, Depends(get_session)],
) -> UserRepository:
    """Get user repository instance."""
    return UserRepository(session)


async def get_user_service(
    repository: Annotated[UserRepository, Depends(get_user_repository)],
) -> UserService:
    """Get user service instance."""
    return UserService(repository)
```

### Step 4: Register Router

```python
"""Application factory."""
from fastapi import FastAPI

from app.routers import users, items, auth


def create_app() -> FastAPI:
    """Create and configure FastAPI application."""
    app = FastAPI(
        title="My API",
        description="API for managing resources",
        version="1.0.0",
    )

    # Register routers
    app.include_router(users.router)
    app.include_router(items.router)
    app.include_router(auth.router)

    return app
```

### Step 5: Write Tests

```python
"""Tests for user endpoints."""
from __future__ import annotations

import pytest
from httpx import AsyncClient
from fastapi import status

from app.main import app


@pytest.fixture
async def client() -> AsyncClient:
    """Provide test client."""
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client


class TestCreateUser:
    """Tests for POST /users."""

    async def test_creates_user_with_valid_data(
        self, client: AsyncClient
    ) -> None:
        """Valid data creates user and returns 201."""
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
        assert data["name"] == "Test User"
        assert "id" in data
        assert "created_at" in data
        assert "password" not in data

    async def test_rejects_invalid_email(self, client: AsyncClient) -> None:
        """Invalid email returns 422."""
        response = await client.post(
            "/users/",
            json={
                "email": "not-an-email",
                "name": "Test",
                "password": "SecurePass1",
            },
        )

        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY

    async def test_rejects_weak_password(self, client: AsyncClient) -> None:
        """Weak password returns 422."""
        response = await client.post(
            "/users/",
            json={
                "email": "test@example.com",
                "name": "Test",
                "password": "weak",
            },
        )

        assert response.status_code == status.HTTP_422_UNPROCESSABLE_ENTITY


class TestGetUser:
    """Tests for GET /users/{user_id}."""

    async def test_returns_existing_user(self, client: AsyncClient) -> None:
        """Returns user data for existing user."""
        # Create user first
        create_response = await client.post(
            "/users/",
            json={
                "email": "get@example.com",
                "name": "Get Test",
                "password": "SecurePass1",
            },
        )
        user_id = create_response.json()["id"]

        # Get user
        response = await client.get(f"/users/{user_id}")

        assert response.status_code == status.HTTP_200_OK
        assert response.json()["id"] == user_id

    async def test_returns_404_for_missing_user(
        self, client: AsyncClient
    ) -> None:
        """Returns 404 for non-existent user."""
        response = await client.get("/users/99999")

        assert response.status_code == status.HTTP_404_NOT_FOUND
        assert "not found" in response.json()["detail"].lower()


class TestListUsers:
    """Tests for GET /users."""

    async def test_returns_paginated_list(self, client: AsyncClient) -> None:
        """Returns paginated user list."""
        response = await client.get("/users/", params={"page": 1, "size": 10})

        assert response.status_code == status.HTTP_200_OK
        data = response.json()
        assert "items" in data
        assert "total" in data
        assert data["page"] == 1
        assert data["size"] == 10
```

## REST Conventions

| Action | Method | Path | Status |
|--------|--------|------|--------|
| Create | POST | /resources | 201 |
| List | GET | /resources | 200 |
| Get | GET | /resources/{id} | 200 |
| Update | PATCH | /resources/{id} | 200 |
| Replace | PUT | /resources/{id} | 200 |
| Delete | DELETE | /resources/{id} | 204 |

## Error Handling

```python
from fastapi import HTTPException, status

# 400 Bad Request - Client error
raise HTTPException(status_code=400, detail="Invalid request format")

# 401 Unauthorized - Not authenticated
raise HTTPException(status_code=401, detail="Not authenticated")

# 403 Forbidden - Not authorized
raise HTTPException(status_code=403, detail="Not authorized")

# 404 Not Found - Resource missing
raise HTTPException(status_code=404, detail="Resource not found")

# 409 Conflict - State conflict
raise HTTPException(status_code=409, detail="Resource already exists")

# 422 Validation Error - Handled by Pydantic

# 500 Internal Error - Let exception propagate
```

## Output Checklist

Before marking complete:

- [ ] Schemas defined with validation
- [ ] Router created with proper tags
- [ ] All CRUD operations implemented
- [ ] Error responses documented
- [ ] Dependencies injected properly
- [ ] Tests cover success and error cases
- [ ] OpenAPI docs accurate

---

**This skill creates production-ready API endpoints with proper validation, error handling, and documentation.**
