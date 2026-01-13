# Python Data Models Skill

## Description

You MUST use this skill before creating any Pydantic models, dataclasses, or data transfer objects. This applies to request/response schemas, domain models, and configuration objects.

---

## Purpose

Generate complete, production-ready data models that:
- Use Pydantic v2 for validation
- Include proper type hints
- Have comprehensive validation
- Are serializable
- Support both input and output use cases

## When to Use

- Creating request/response schemas
- Building domain models
- Creating configuration objects
- Defining DTOs

## Prerequisites

- Data structure requirements clear
- Validation rules defined
- Serialization needs understood

## Process

### Step 1: Choose Model Type

| Need | Use |
|------|-----|
| Validation + serialization | Pydantic BaseModel |
| Simple data container | dataclass |
| Immutable config | Pydantic with frozen=True |
| ORM integration | SQLModel or Pydantic with from_attributes |

### Step 2: Create Pydantic Models

**Basic Model:**

```python
"""User-related data models."""
from __future__ import annotations

from datetime import datetime
from typing import Annotated

from pydantic import BaseModel, Field, EmailStr, ConfigDict


class UserBase(BaseModel):
    """Base user model with shared fields."""

    email: EmailStr = Field(..., description="User's email address")
    name: str = Field(
        ...,
        min_length=1,
        max_length=100,
        description="User's display name",
    )


class UserCreate(UserBase):
    """Model for creating a new user."""

    password: str = Field(
        ...,
        min_length=8,
        max_length=128,
        description="Password (8-128 characters)",
    )


class UserUpdate(BaseModel):
    """Model for updating a user (all fields optional)."""

    email: EmailStr | None = None
    name: str | None = Field(None, min_length=1, max_length=100)


class User(UserBase):
    """Complete user model with all fields."""

    id: int
    created_at: datetime
    updated_at: datetime
    is_active: bool = True

    model_config = ConfigDict(from_attributes=True)
```

### Step 3: Add Validators

**Field Validators:**

```python
from pydantic import BaseModel, Field, field_validator, model_validator
import re


class UserCreate(BaseModel):
    """User creation with validation."""

    username: str = Field(..., min_length=3, max_length=30)
    email: EmailStr
    password: str = Field(..., min_length=8)
    password_confirm: str

    @field_validator("username")
    @classmethod
    def username_alphanumeric(cls, v: str) -> str:
        """Username must be alphanumeric."""
        if not v.isalnum():
            raise ValueError("Username must be alphanumeric")
        return v.lower()

    @field_validator("password")
    @classmethod
    def password_complexity(cls, v: str) -> str:
        """Password must meet complexity requirements."""
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain uppercase letter")
        if not re.search(r"[a-z]", v):
            raise ValueError("Password must contain lowercase letter")
        if not re.search(r"\d", v):
            raise ValueError("Password must contain digit")
        return v

    @model_validator(mode="after")
    def passwords_match(self) -> "UserCreate":
        """Ensure passwords match."""
        if self.password != self.password_confirm:
            raise ValueError("Passwords do not match")
        return self
```

**Before Validator (preprocessing):**

```python
from pydantic import field_validator


class SearchQuery(BaseModel):
    """Search query with preprocessing."""

    query: str
    tags: list[str] = []

    @field_validator("query", mode="before")
    @classmethod
    def strip_query(cls, v: str) -> str:
        """Strip whitespace from query."""
        if isinstance(v, str):
            return v.strip()
        return v

    @field_validator("tags", mode="before")
    @classmethod
    def parse_tags(cls, v: str | list[str]) -> list[str]:
        """Parse comma-separated tags."""
        if isinstance(v, str):
            return [t.strip().lower() for t in v.split(",") if t.strip()]
        return [t.lower() for t in v]
```

### Step 4: Complex Types

**Nested Models:**

```python
class Address(BaseModel):
    """Physical address."""

    street: str
    city: str
    country: str
    postal_code: str


class Company(BaseModel):
    """Company information."""

    name: str
    address: Address
    employees: list[User] = []


# Usage
company = Company(
    name="Acme",
    address={"street": "123 Main", "city": "NYC", "country": "USA", "postal_code": "10001"},
    employees=[],
)
```

**Generic Models:**

```python
from typing import Generic, TypeVar

T = TypeVar("T")


class PaginatedResponse(BaseModel, Generic[T]):
    """Generic paginated response."""

    items: list[T]
    total: int
    page: int
    size: int
    pages: int

    @classmethod
    def create(
        cls, items: list[T], total: int, page: int, size: int
    ) -> "PaginatedResponse[T]":
        """Create paginated response."""
        return cls(
            items=items,
            total=total,
            page=page,
            size=size,
            pages=(total + size - 1) // size,
        )


# Usage
response: PaginatedResponse[User] = PaginatedResponse.create(
    items=users, total=100, page=1, size=20
)
```

**Discriminated Unions:**

```python
from typing import Literal, Union
from pydantic import BaseModel


class EmailNotification(BaseModel):
    """Email notification type."""

    type: Literal["email"] = "email"
    to: EmailStr
    subject: str
    body: str


class SMSNotification(BaseModel):
    """SMS notification type."""

    type: Literal["sms"] = "sms"
    phone: str
    message: str


class PushNotification(BaseModel):
    """Push notification type."""

    type: Literal["push"] = "push"
    device_id: str
    title: str
    body: str


Notification = Union[EmailNotification, SMSNotification, PushNotification]


class NotificationRequest(BaseModel):
    """Request containing any notification type."""

    notification: Notification = Field(..., discriminator="type")
```

### Step 5: Serialization Control

```python
from pydantic import BaseModel, Field, ConfigDict, field_serializer
from datetime import datetime


class User(BaseModel):
    """User with controlled serialization."""

    id: int
    email: str
    password_hash: str = Field(..., exclude=True)  # Never serialize
    created_at: datetime

    model_config = ConfigDict(
        from_attributes=True,
        json_schema_extra={
            "example": {
                "id": 1,
                "email": "user@example.com",
                "created_at": "2024-01-15T10:30:00Z",
            }
        },
    )

    @field_serializer("created_at")
    def serialize_datetime(self, v: datetime) -> str:
        """Serialize datetime as ISO format."""
        return v.isoformat()


# Selective serialization
user.model_dump()  # All fields except excluded
user.model_dump(include={"id", "email"})  # Only these fields
user.model_dump(exclude={"created_at"})  # Exclude these
user.model_dump_json()  # As JSON string
```

### Step 6: Settings/Config Models

```python
"""Application configuration."""
from pydantic import Field, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class DatabaseSettings(BaseSettings):
    """Database configuration."""

    host: str = "localhost"
    port: int = 5432
    name: str = "myapp"
    user: str = "postgres"
    password: SecretStr

    model_config = SettingsConfigDict(env_prefix="DB_")

    @property
    def url(self) -> str:
        """Get database URL."""
        password = self.password.get_secret_value()
        return f"postgresql://{self.user}:{password}@{self.host}:{self.port}/{self.name}"


class Settings(BaseSettings):
    """Application settings."""

    app_name: str = "MyApp"
    debug: bool = False
    secret_key: SecretStr
    database: DatabaseSettings = Field(default_factory=DatabaseSettings)

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        env_nested_delimiter="__",
    )


settings = Settings()
```

## Common Patterns

### Request/Response Pairs

```python
# Create request (input)
class ItemCreate(BaseModel):
    name: str
    price: float

# Update request (partial)
class ItemUpdate(BaseModel):
    name: str | None = None
    price: float | None = None

# Response (output)
class ItemResponse(BaseModel):
    id: int
    name: str
    price: float
    created_at: datetime

    model_config = ConfigDict(from_attributes=True)
```

### Immutable Models

```python
class Config(BaseModel):
    """Immutable configuration."""

    api_key: str
    timeout: int = 30

    model_config = ConfigDict(frozen=True)

# This will raise
config = Config(api_key="xxx")
config.timeout = 60  # Error: Instance is frozen
```

## Output Checklist

Before marking complete:

- [ ] Models have docstrings
- [ ] All fields typed
- [ ] Validation rules defined
- [ ] Serialization tested
- [ ] model_config set appropriately
- [ ] Tests cover validation
- [ ] mypy passes

---

**This skill creates production-ready Pydantic models with comprehensive validation and serialization.**
