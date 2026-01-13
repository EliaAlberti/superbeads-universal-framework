# Python Database Skill

## Description

You MUST use this skill before setting up database integration, creating ORM models, or implementing repositories. This applies to SQLAlchemy, SQLModel, and database access patterns.

---

## Purpose

Set up complete, production-ready database integration that:
- Uses SQLAlchemy 2.0 async patterns
- Follows repository pattern
- Handles sessions properly
- Includes migrations support
- Is testable

## When to Use

- Setting up database connection
- Creating ORM models
- Implementing repositories
- Adding migrations

## Prerequisites

- Database choice made (PostgreSQL, SQLite, etc.)
- SQLAlchemy 2.0 / SQLModel
- Async support needed

## Process

### Step 1: Database Configuration

```python
"""Database configuration and session management."""
from __future__ import annotations

from typing import AsyncIterator
from sqlalchemy.ext.asyncio import (
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)
from sqlalchemy.orm import DeclarativeBase

from app.core.config import settings


class Base(DeclarativeBase):
    """Base class for all ORM models."""

    pass


# Create async engine
engine = create_async_engine(
    settings.database_url,
    echo=settings.debug,
    pool_pre_ping=True,
    pool_size=5,
    max_overflow=10,
)

# Session factory
async_session_factory = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


async def get_session() -> AsyncIterator[AsyncSession]:
    """Provide database session for dependency injection."""
    async with async_session_factory() as session:
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
```

### Step 2: Create ORM Models

```python
"""User ORM model."""
from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import String, Boolean, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base

if TYPE_CHECKING:
    from app.models.post import Post


class User(Base):
    """User database model."""

    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    email: Mapped[str] = mapped_column(
        String(255),
        unique=True,
        index=True,
        nullable=False,
    )
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
    )

    # Relationships
    posts: Mapped[list["Post"]] = relationship(
        "Post",
        back_populates="author",
        lazy="selectin",
    )

    def __repr__(self) -> str:
        return f"User(id={self.id}, email={self.email!r})"
```

**Related Model:**

```python
"""Post ORM model."""
from __future__ import annotations

from datetime import datetime
from typing import TYPE_CHECKING

from sqlalchemy import String, Text, ForeignKey, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database import Base

if TYPE_CHECKING:
    from app.models.user import User


class Post(Base):
    """Blog post database model."""

    __tablename__ = "posts"

    id: Mapped[int] = mapped_column(primary_key=True)
    title: Mapped[str] = mapped_column(String(200), nullable=False)
    content: Mapped[str] = mapped_column(Text, nullable=False)
    author_id: Mapped[int] = mapped_column(
        ForeignKey("users.id", ondelete="CASCADE"),
        index=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
    )

    # Relationships
    author: Mapped["User"] = relationship("User", back_populates="posts")
```

### Step 3: Create Repository

```python
"""User repository for database operations."""
from __future__ import annotations

from typing import Sequence

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate


class UserRepository:
    """Repository for User database operations."""

    def __init__(self, session: AsyncSession) -> None:
        """Initialize with database session."""
        self._session = session

    async def get(self, user_id: int) -> User | None:
        """Get user by ID."""
        return await self._session.get(User, user_id)

    async def get_by_email(self, email: str) -> User | None:
        """Get user by email address."""
        stmt = select(User).where(User.email == email)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()

    async def list(
        self,
        *,
        skip: int = 0,
        limit: int = 20,
    ) -> tuple[Sequence[User], int]:
        """List users with pagination."""
        # Get total count
        count_stmt = select(func.count()).select_from(User)
        total = await self._session.scalar(count_stmt) or 0

        # Get items
        stmt = select(User).offset(skip).limit(limit).order_by(User.id)
        result = await self._session.execute(stmt)
        users = result.scalars().all()

        return users, total

    async def create(self, data: UserCreate, password_hash: str) -> User:
        """Create new user."""
        user = User(
            email=data.email,
            name=data.name,
            password_hash=password_hash,
        )
        self._session.add(user)
        await self._session.flush()
        await self._session.refresh(user)
        return user

    async def update(self, user: User, data: UserUpdate) -> User:
        """Update existing user."""
        update_data = data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            setattr(user, field, value)
        await self._session.flush()
        await self._session.refresh(user)
        return user

    async def delete(self, user: User) -> None:
        """Delete user."""
        await self._session.delete(user)
        await self._session.flush()
```

### Step 4: Generic Repository Base

```python
"""Generic repository base class."""
from __future__ import annotations

from typing import Generic, TypeVar, Sequence, Any

from sqlalchemy import select, func
from sqlalchemy.ext.asyncio import AsyncSession

from app.database import Base

ModelType = TypeVar("ModelType", bound=Base)


class BaseRepository(Generic[ModelType]):
    """Generic repository with common CRUD operations."""

    model: type[ModelType]

    def __init__(self, session: AsyncSession) -> None:
        """Initialize with database session."""
        self._session = session

    async def get(self, id: int) -> ModelType | None:
        """Get by primary key."""
        return await self._session.get(self.model, id)

    async def get_multi(
        self,
        *,
        skip: int = 0,
        limit: int = 100,
    ) -> Sequence[ModelType]:
        """Get multiple records."""
        stmt = select(self.model).offset(skip).limit(limit)
        result = await self._session.execute(stmt)
        return result.scalars().all()

    async def create(self, **kwargs: Any) -> ModelType:
        """Create new record."""
        obj = self.model(**kwargs)
        self._session.add(obj)
        await self._session.flush()
        await self._session.refresh(obj)
        return obj

    async def update(self, obj: ModelType, **kwargs: Any) -> ModelType:
        """Update record."""
        for field, value in kwargs.items():
            if hasattr(obj, field):
                setattr(obj, field, value)
        await self._session.flush()
        await self._session.refresh(obj)
        return obj

    async def delete(self, obj: ModelType) -> None:
        """Delete record."""
        await self._session.delete(obj)
        await self._session.flush()

    async def count(self) -> int:
        """Count all records."""
        stmt = select(func.count()).select_from(self.model)
        return await self._session.scalar(stmt) or 0


class UserRepository(BaseRepository[User]):
    """User-specific repository."""

    model = User

    async def get_by_email(self, email: str) -> User | None:
        """Get user by email."""
        stmt = select(User).where(User.email == email)
        result = await self._session.execute(stmt)
        return result.scalar_one_or_none()
```

### Step 5: Migrations (Alembic)

**alembic.ini:**
```ini
[alembic]
script_location = alembic
sqlalchemy.url = driver://user:pass@localhost/dbname
```

**alembic/env.py:**
```python
"""Alembic migration environment."""
import asyncio
from logging.config import fileConfig

from alembic import context
from sqlalchemy import pool
from sqlalchemy.ext.asyncio import async_engine_from_config

from app.database import Base
from app.core.config import settings
# Import all models to register them
from app.models import user, post  # noqa: F401

config = context.config
config.set_main_option("sqlalchemy.url", settings.database_url)

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def run_migrations_offline() -> None:
    """Run migrations in offline mode."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
    )

    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection):
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    """Run migrations in async mode."""
    connectable = async_engine_from_config(
        config.get_section(config.config_ini_section) or {},
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)

    await connectable.dispose()


def run_migrations_online() -> None:
    """Run migrations in online mode."""
    asyncio.run(run_async_migrations())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
```

### Step 6: Testing Database

```python
"""Database test fixtures."""
import pytest
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker

from app.database import Base


@pytest.fixture
async def db_session():
    """Provide test database session."""
    engine = create_async_engine(
        "sqlite+aiosqlite:///:memory:",
        echo=False,
    )

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async_session = async_sessionmaker(
        engine,
        class_=AsyncSession,
        expire_on_commit=False,
    )

    async with async_session() as session:
        yield session

    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

    await engine.dispose()


class TestUserRepository:
    """Tests for UserRepository."""

    async def test_create_user(self, db_session: AsyncSession) -> None:
        """Create stores user in database."""
        repo = UserRepository(db_session)

        user = await repo.create(
            email="test@example.com",
            name="Test",
            password_hash="hash",
        )

        assert user.id is not None
        assert user.email == "test@example.com"

    async def test_get_by_email(self, db_session: AsyncSession) -> None:
        """Get by email returns correct user."""
        repo = UserRepository(db_session)
        await repo.create(email="find@example.com", name="Find", password_hash="hash")

        user = await repo.get_by_email("find@example.com")

        assert user is not None
        assert user.email == "find@example.com"
```

## Output Checklist

Before marking complete:

- [ ] Database connection configured
- [ ] ORM models defined
- [ ] Repositories implemented
- [ ] Session management correct
- [ ] Migrations set up
- [ ] Tests use in-memory DB
- [ ] mypy passes

---

**This skill sets up production-ready database integration with SQLAlchemy 2.0 async patterns.**
