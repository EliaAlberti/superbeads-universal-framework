# Python Create Module Skill

## Description

You MUST use this skill before creating any Python module, package, or standalone file. This applies to creating new functionality, adding utility modules, and organizing code into proper package structures.

---

## Purpose

Generate complete, production-ready Python modules that:
- Follow PEP 8 and project conventions
- Include proper type hints throughout
- Have comprehensive docstrings
- Are testable and maintainable
- Integrate cleanly with existing codebase

## When to Use

- Creating any new Python module (.py file)
- Adding a new package (directory with `__init__.py`)
- Creating utility/helper modules
- Adding new functionality as a module

## Prerequisites

- Project structure understood
- Dependencies identified
- Module purpose clear

## Process

### Step 1: Gather Context

**From task:**
- Module name and purpose
- Public API (functions/classes to expose)
- Dependencies needed

**From codebase:**
- Existing patterns
- Import conventions
- Docstring format

### Step 2: Create Module Structure

```python
"""Module docstring: One-line summary.

Extended description if needed. Explain what this module provides,
when to use it, and any important notes.

Example:
    >>> from module import function
    >>> result = function(arg)

Attributes:
    MODULE_CONSTANT: Description of module-level constant.
"""
from __future__ import annotations

# Standard library imports (alphabetical)
import logging
from pathlib import Path
from typing import TYPE_CHECKING

# Third-party imports (alphabetical)
from pydantic import BaseModel

# Local imports (alphabetical)
from .base import BaseClass

if TYPE_CHECKING:
    # Type-only imports to avoid circular imports
    from .other import OtherClass

# Module-level constants
DEFAULT_VALUE = 100
logger = logging.getLogger(__name__)

# Public API
__all__ = ["PublicClass", "public_function"]


class PublicClass:
    """Class docstring.

    Describe what this class represents and how to use it.

    Attributes:
        attr1: Description of attr1.
        attr2: Description of attr2.

    Example:
        >>> obj = PublicClass(value=10)
        >>> obj.process()
    """

    def __init__(self, value: int) -> None:
        """Initialize PublicClass.

        Args:
            value: The initial value.
        """
        self.value = value

    def process(self) -> int:
        """Process and return result.

        Returns:
            The processed value.

        Raises:
            ValueError: If value is negative.
        """
        if self.value < 0:
            raise ValueError("Value cannot be negative")
        return self.value * 2


def public_function(arg: str) -> str:
    """One-line description of function.

    Extended description if needed.

    Args:
        arg: Description of argument.

    Returns:
        Description of return value.

    Raises:
        ValueError: When arg is empty.

    Example:
        >>> public_function("hello")
        'HELLO'
    """
    if not arg:
        raise ValueError("Argument cannot be empty")
    return arg.upper()


def _private_helper(x: int) -> int:
    """Private helper function (no extensive docs needed)."""
    return x + 1
```

### Step 3: Create Package (if needed)

```
mypackage/
├── __init__.py
├── core.py
├── utils.py
└── exceptions.py
```

**`__init__.py`:**
```python
"""MyPackage: Brief description.

This package provides X functionality for Y purpose.
"""
from .core import MainClass, main_function
from .exceptions import MyError

__all__ = ["MainClass", "main_function", "MyError"]
__version__ = "1.0.0"
```

### Step 4: Add Type Hints

**All public API must be typed:**

```python
from typing import Any
from collections.abc import Sequence, Mapping, Iterator

def process_items(
    items: Sequence[str],
    options: Mapping[str, Any] | None = None,
) -> Iterator[str]:
    """Process items with optional configuration."""
    options = options or {}
    for item in items:
        yield item.strip()
```

**Complex types:**
```python
from typing import TypeVar, Generic, Callable

T = TypeVar("T")
K = TypeVar("K")
V = TypeVar("V")

# Generic class
class Cache(Generic[K, V]):
    def get(self, key: K) -> V | None: ...
    def set(self, key: K, value: V) -> None: ...

# Callable types
Handler = Callable[[str, int], bool]
AsyncHandler = Callable[[str], Coroutine[Any, Any, bool]]
```

### Step 5: Write Tests

Create corresponding test module:

```python
"""Tests for mymodule."""
import pytest
from mypackage.mymodule import PublicClass, public_function


class TestPublicClass:
    """Tests for PublicClass."""

    def test_init_stores_value(self) -> None:
        """Initialization stores the provided value."""
        obj = PublicClass(value=42)
        assert obj.value == 42

    def test_process_doubles_value(self) -> None:
        """Process returns doubled value."""
        obj = PublicClass(value=10)
        assert obj.process() == 20

    def test_process_negative_raises(self) -> None:
        """Process raises ValueError for negative values."""
        obj = PublicClass(value=-1)
        with pytest.raises(ValueError, match="cannot be negative"):
            obj.process()


class TestPublicFunction:
    """Tests for public_function."""

    def test_uppercases_string(self) -> None:
        """Returns uppercase version of input."""
        assert public_function("hello") == "HELLO"

    def test_empty_string_raises(self) -> None:
        """Empty string raises ValueError."""
        with pytest.raises(ValueError, match="cannot be empty"):
            public_function("")
```

## Best Practices

### Do
- Use `from __future__ import annotations` for modern type syntax
- Group imports: stdlib, third-party, local
- Define `__all__` for public API
- Use `TYPE_CHECKING` for type-only imports
- Keep modules focused (single responsibility)
- Use descriptive names

### Don't
- Create circular imports
- Mix unrelated functionality
- Skip type hints on public API
- Use `from module import *`
- Create modules with only one function (use existing module)

## Output Checklist

Before marking complete:

- [ ] Module has docstring
- [ ] All public functions/classes typed
- [ ] All public functions/classes documented
- [ ] `__all__` defined
- [ ] Imports organized
- [ ] Tests created
- [ ] ruff check passes
- [ ] mypy passes

---

**This skill creates production-ready Python modules that are typed, documented, and testable.**
