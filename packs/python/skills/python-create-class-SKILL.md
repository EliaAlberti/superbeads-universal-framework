# Python Create Class Skill

## Description

You MUST use this skill before creating any Python class. This applies to data classes, service classes, base classes, mixins, and any object-oriented constructs.

---

## Purpose

Generate complete, production-ready Python classes that:
- Follow SOLID principles
- Include comprehensive type hints
- Have proper docstrings
- Are testable with clear interfaces
- Use appropriate patterns (dataclass, Protocol, ABC)

## When to Use

- Creating any new class
- Building service/repository classes
- Creating data transfer objects
- Implementing design patterns
- Building base classes or mixins

## Prerequisites

- Class purpose clear
- Interface requirements defined
- Relationship to existing classes understood

## Process

### Step 1: Choose Class Type

| Need | Use |
|------|-----|
| Data container | `dataclass` or Pydantic |
| Service with methods | Regular class |
| Interface contract | `Protocol` |
| Shared behavior | ABC or mixin |
| Singleton | Module-level instance |

### Step 2: Implement Based on Type

#### Standard Class

```python
"""Module containing MyService."""
from __future__ import annotations

import logging
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .repository import Repository
    from .models import Item

logger = logging.getLogger(__name__)


class MyService:
    """Service for handling item operations.

    This service provides business logic for creating, updating,
    and managing items.

    Attributes:
        repository: The data repository for persistence.

    Example:
        >>> service = MyService(repository)
        >>> item = await service.create(name="New Item")
    """

    def __init__(self, repository: Repository) -> None:
        """Initialize MyService.

        Args:
            repository: Repository for data access.
        """
        self._repository = repository

    @property
    def repository(self) -> Repository:
        """Get the repository instance."""
        return self._repository

    async def create(self, name: str) -> Item:
        """Create a new item.

        Args:
            name: Name for the new item.

        Returns:
            The created item.

        Raises:
            ValueError: If name is empty.
            DuplicateError: If item with name exists.
        """
        if not name:
            raise ValueError("Name cannot be empty")

        logger.info("Creating item: %s", name)
        return await self._repository.create(name=name)

    async def get_by_id(self, item_id: int) -> Item | None:
        """Get item by ID.

        Args:
            item_id: The item's unique identifier.

        Returns:
            The item if found, None otherwise.
        """
        return await self._repository.get(item_id)
```

#### Dataclass

```python
"""Data models for the application."""
from __future__ import annotations

from dataclasses import dataclass, field
from datetime import datetime
from typing import Self


@dataclass
class Item:
    """Represents an item in the system.

    Attributes:
        id: Unique identifier.
        name: Item name.
        created_at: Creation timestamp.
        tags: List of associated tags.
    """

    id: int
    name: str
    created_at: datetime = field(default_factory=datetime.now)
    tags: list[str] = field(default_factory=list)

    def with_tag(self, tag: str) -> Self:
        """Return new item with added tag.

        Args:
            tag: Tag to add.

        Returns:
            New Item instance with the tag added.
        """
        return Item(
            id=self.id,
            name=self.name,
            created_at=self.created_at,
            tags=[*self.tags, tag],
        )


@dataclass(frozen=True)
class ImmutableConfig:
    """Immutable configuration object.

    Attributes:
        host: Server host.
        port: Server port.
        debug: Debug mode flag.
    """

    host: str
    port: int = 8080
    debug: bool = False

    def __post_init__(self) -> None:
        """Validate configuration after initialization."""
        if self.port < 1 or self.port > 65535:
            raise ValueError(f"Invalid port: {self.port}")
```

#### Protocol (Interface)

```python
"""Protocols for dependency injection."""
from __future__ import annotations

from typing import Protocol, runtime_checkable


@runtime_checkable
class Repository(Protocol):
    """Interface for data repositories."""

    async def get(self, id: int) -> Item | None:
        """Get item by ID."""
        ...

    async def create(self, **kwargs: Any) -> Item:
        """Create new item."""
        ...

    async def delete(self, id: int) -> bool:
        """Delete item by ID."""
        ...


class Cacheable(Protocol):
    """Interface for cacheable objects."""

    @property
    def cache_key(self) -> str:
        """Get cache key for this object."""
        ...

    @property
    def cache_ttl(self) -> int:
        """Get cache TTL in seconds."""
        ...
```

#### Abstract Base Class

```python
"""Base classes for the application."""
from __future__ import annotations

from abc import ABC, abstractmethod
from typing import Generic, TypeVar

T = TypeVar("T")


class BaseRepository(ABC, Generic[T]):
    """Abstract base for all repositories.

    Subclasses must implement all abstract methods.

    Type Parameters:
        T: The entity type this repository manages.
    """

    @abstractmethod
    async def get(self, id: int) -> T | None:
        """Get entity by ID.

        Args:
            id: Entity identifier.

        Returns:
            Entity if found, None otherwise.
        """
        ...

    @abstractmethod
    async def save(self, entity: T) -> T:
        """Save entity.

        Args:
            entity: Entity to save.

        Returns:
            Saved entity (may have updated fields).
        """
        ...

    async def get_or_raise(self, id: int) -> T:
        """Get entity by ID or raise.

        Args:
            id: Entity identifier.

        Returns:
            The found entity.

        Raises:
            NotFoundError: If entity doesn't exist.
        """
        entity = await self.get(id)
        if entity is None:
            raise NotFoundError(f"Entity {id} not found")
        return entity
```

#### Mixin

```python
"""Mixins for common functionality."""
from __future__ import annotations

import logging
from datetime import datetime


class LoggingMixin:
    """Mixin that provides logging capabilities.

    Classes using this mixin get a configured logger.
    """

    @property
    def logger(self) -> logging.Logger:
        """Get logger for this class."""
        return logging.getLogger(self.__class__.__name__)

    def log_info(self, message: str, *args: object) -> None:
        """Log info message."""
        self.logger.info(message, *args)


class TimestampMixin:
    """Mixin for timestamp tracking.

    Provides created_at and updated_at tracking.
    """

    created_at: datetime
    updated_at: datetime

    def touch(self) -> None:
        """Update the updated_at timestamp."""
        self.updated_at = datetime.now()


class UserService(LoggingMixin):
    """Service using logging mixin."""

    def create_user(self, name: str) -> None:
        self.log_info("Creating user: %s", name)
        # ... implementation
```

### Step 3: Add Proper Initialization

```python
class ComplexService:
    """Service with complex initialization."""

    def __init__(
        self,
        repository: Repository,
        cache: Cache,
        *,  # Force keyword arguments after this
        timeout: int = 30,
        max_retries: int = 3,
    ) -> None:
        """Initialize ComplexService.

        Args:
            repository: Data repository.
            cache: Cache instance.
            timeout: Operation timeout in seconds.
            max_retries: Maximum retry attempts.

        Raises:
            ValueError: If timeout or max_retries is negative.
        """
        if timeout < 0:
            raise ValueError("Timeout must be non-negative")
        if max_retries < 0:
            raise ValueError("max_retries must be non-negative")

        self._repository = repository
        self._cache = cache
        self._timeout = timeout
        self._max_retries = max_retries
```

### Step 4: Implement Magic Methods (if needed)

```python
@dataclass
class Money:
    """Represents monetary value."""

    amount: int  # In cents
    currency: str = "USD"

    def __str__(self) -> str:
        """Human-readable representation."""
        dollars = self.amount / 100
        return f"{self.currency} {dollars:.2f}"

    def __repr__(self) -> str:
        """Debug representation."""
        return f"Money(amount={self.amount}, currency={self.currency!r})"

    def __eq__(self, other: object) -> bool:
        """Check equality."""
        if not isinstance(other, Money):
            return NotImplemented
        return self.amount == other.amount and self.currency == other.currency

    def __lt__(self, other: Money) -> bool:
        """Compare values (same currency only)."""
        if self.currency != other.currency:
            raise ValueError("Cannot compare different currencies")
        return self.amount < other.amount

    def __add__(self, other: Money) -> Money:
        """Add two Money values."""
        if self.currency != other.currency:
            raise ValueError("Cannot add different currencies")
        return Money(self.amount + other.amount, self.currency)

    def __hash__(self) -> int:
        """Make hashable for use in sets/dicts."""
        return hash((self.amount, self.currency))
```

### Step 5: Write Tests

```python
"""Tests for MyService."""
import pytest
from unittest.mock import AsyncMock, Mock

from myapp.services import MyService
from myapp.models import Item


class TestMyService:
    """Tests for MyService class."""

    @pytest.fixture
    def mock_repository(self) -> Mock:
        """Provide mock repository."""
        repo = Mock()
        repo.create = AsyncMock(return_value=Item(id=1, name="Test"))
        repo.get = AsyncMock(return_value=None)
        return repo

    @pytest.fixture
    def service(self, mock_repository: Mock) -> MyService:
        """Provide service instance."""
        return MyService(repository=mock_repository)

    async def test_create_returns_item(self, service: MyService) -> None:
        """Create returns the created item."""
        item = await service.create(name="Test")
        assert item.name == "Test"

    async def test_create_empty_name_raises(self, service: MyService) -> None:
        """Create with empty name raises ValueError."""
        with pytest.raises(ValueError, match="cannot be empty"):
            await service.create(name="")

    async def test_get_by_id_returns_none_when_missing(
        self, service: MyService
    ) -> None:
        """Get returns None for missing items."""
        result = await service.get_by_id(999)
        assert result is None
```

## Best Practices

### Do
- Use `@dataclass` for data containers
- Use `Protocol` for interfaces (duck typing)
- Use `ABC` when you need shared implementation
- Keep classes focused (single responsibility)
- Prefer composition over inheritance
- Use dependency injection

### Don't
- Create God classes
- Use multiple inheritance of concrete classes
- Put business logic in dataclasses
- Use class attributes for instance state
- Create deep inheritance hierarchies

## Output Checklist

Before marking complete:

- [ ] Class has docstring
- [ ] All methods typed
- [ ] `__init__` documented
- [ ] Appropriate class type chosen
- [ ] Tests created
- [ ] ruff check passes
- [ ] mypy passes

---

**This skill creates production-ready Python classes following best practices and SOLID principles.**
