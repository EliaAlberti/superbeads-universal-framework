# Python Setup Project Skill

## Description

You MUST use this skill before setting up any new Python project or significantly restructuring an existing one. This applies to creating project structure, configuring build tools, and establishing development workflow.

---

## Purpose

Set up complete, production-ready Python projects that:
- Use modern tooling (pyproject.toml, ruff, mypy)
- Have proper package structure
- Include development dependencies
- Are ready for CI/CD

## When to Use

- Creating a new Python project
- Migrating from setup.py to pyproject.toml
- Adding tooling to existing project
- Setting up development environment

## Prerequisites

- Project name and purpose clear
- Python version determined (3.11+)
- Package manager preference (uv, pip, poetry)

## Process

### Step 1: Create Directory Structure

**Application Structure:**
```
myproject/
├── src/
│   └── myproject/
│       ├── __init__.py
│       ├── main.py
│       ├── models/
│       │   ├── __init__.py
│       │   └── user.py
│       ├── services/
│       │   ├── __init__.py
│       │   └── user.py
│       ├── routers/
│       │   ├── __init__.py
│       │   └── users.py
│       └── core/
│           ├── __init__.py
│           ├── config.py
│           └── exceptions.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   ├── test_models/
│   └── test_services/
├── scripts/
│   └── verify.sh
├── pyproject.toml
├── README.md
└── .gitignore
```

**Library Structure:**
```
mylib/
├── src/
│   └── mylib/
│       ├── __init__.py
│       ├── core.py
│       └── utils.py
├── tests/
├── docs/
├── pyproject.toml
└── README.md
```

### Step 2: Create pyproject.toml

```toml
[project]
name = "myproject"
version = "0.1.0"
description = "A brief description of the project"
readme = "README.md"
license = { text = "MIT" }
requires-python = ">=3.11"
authors = [
    { name = "Your Name", email = "you@example.com" }
]
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]
dependencies = [
    "pydantic>=2.0",
    "httpx>=0.25",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-cov>=4.0",
    "pytest-asyncio>=0.21",
    "mypy>=1.0",
    "ruff>=0.1",
]

[project.scripts]
myproject = "myproject.main:main"

[project.urls]
Homepage = "https://github.com/user/myproject"
Documentation = "https://github.com/user/myproject#readme"
Repository = "https://github.com/user/myproject"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/myproject"]

# Ruff configuration
[tool.ruff]
target-version = "py311"
line-length = 88
src = ["src", "tests"]

[tool.ruff.lint]
select = [
    "E",      # pycodestyle errors
    "W",      # pycodestyle warnings
    "F",      # Pyflakes
    "I",      # isort
    "B",      # flake8-bugbear
    "C4",     # flake8-comprehensions
    "UP",     # pyupgrade
    "ARG",    # flake8-unused-arguments
    "SIM",    # flake8-simplify
]
ignore = [
    "E501",   # line too long (handled by formatter)
]

[tool.ruff.lint.isort]
known-first-party = ["myproject"]

[tool.ruff.format]
quote-style = "double"

# Mypy configuration
[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_ignores = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_configs = true
show_error_codes = true
files = ["src", "tests"]

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

# Pytest configuration
[tool.pytest.ini_options]
testpaths = ["tests"]
asyncio_mode = "auto"
addopts = [
    "-ra",
    "-q",
    "--strict-markers",
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
]

# Coverage configuration
[tool.coverage.run]
source = ["src"]
branch = true

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise NotImplementedError",
    "if TYPE_CHECKING:",
    "if __name__ == .__main__.:",
]
```

### Step 3: Create Package __init__.py

```python
"""MyProject: Brief description.

This package provides X functionality.
"""
from myproject.core.config import settings
from myproject.models.user import User

__version__ = "0.1.0"
__all__ = ["settings", "User", "__version__"]
```

### Step 4: Create conftest.py

```python
"""Pytest configuration and fixtures."""
from __future__ import annotations

from typing import AsyncIterator

import pytest
from httpx import AsyncClient

from myproject.main import app


@pytest.fixture
def anyio_backend() -> str:
    """Use asyncio backend for tests."""
    return "asyncio"


@pytest.fixture
async def client() -> AsyncIterator[AsyncClient]:
    """Provide async HTTP client for testing."""
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client


@pytest.fixture
def sample_user_data() -> dict[str, str]:
    """Provide sample user data for tests."""
    return {
        "email": "test@example.com",
        "name": "Test User",
        "password": "SecurePass1",
    }
```

### Step 5: Create verify.sh

```bash
#!/usr/bin/env bash
#
# verify.sh - Run all verification checks
#

set -e

echo "=== Python Project Verification ==="
echo

# Check Python version
echo "1. Checking Python version..."
python --version
echo

# Lint
echo "2. Running linter (ruff)..."
ruff check .
echo "   Lint: PASS"
echo

# Format check
echo "3. Checking formatting..."
ruff format --check .
echo "   Format: PASS"
echo

# Type check
echo "4. Running type checker (mypy)..."
mypy .
echo "   Types: PASS"
echo

# Tests
echo "5. Running tests..."
pytest --cov --cov-report=term-missing
echo "   Tests: PASS"
echo

echo "=== All Checks Passed ==="
```

### Step 6: Create .gitignore

```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Distribution / packaging
dist/
build/
*.egg-info/
.eggs/

# Virtual environments
.venv/
venv/
ENV/

# IDE
.idea/
.vscode/
*.swp
*.swo

# Testing
.coverage
htmlcov/
.pytest_cache/
.mypy_cache/

# Project specific
.env
*.log
```

### Step 7: Initialize Environment

```bash
# Using uv (recommended)
uv venv
source .venv/bin/activate
uv pip install -e ".[dev]"

# Using pip
python -m venv .venv
source .venv/bin/activate
pip install -e ".[dev]"

# Make verify.sh executable
chmod +x scripts/verify.sh
```

## Project Patterns

### FastAPI Application

```python
# src/myproject/main.py
"""FastAPI application entry point."""
from fastapi import FastAPI

from myproject.routers import users, items
from myproject.core.config import settings

app = FastAPI(
    title=settings.app_name,
    version="1.0.0",
)

app.include_router(users.router)
app.include_router(items.router)


def main() -> None:
    """Run development server."""
    import uvicorn
    uvicorn.run("myproject.main:app", reload=True)


if __name__ == "__main__":
    main()
```

### CLI Application

```python
# src/myproject/main.py
"""CLI entry point."""
import typer

app = typer.Typer(help="MyProject CLI")


@app.command()
def run(name: str = typer.Option(..., help="Name to greet")) -> None:
    """Run the main command."""
    typer.echo(f"Hello, {name}!")


def main() -> None:
    """Entry point."""
    app()


if __name__ == "__main__":
    main()
```

### Library Package

```python
# src/mylib/__init__.py
"""MyLib: A helpful library.

Example:
    >>> from mylib import process
    >>> result = process("data")
"""
from mylib.core import process, transform
from mylib.utils import helper

__version__ = "1.0.0"
__all__ = ["process", "transform", "helper", "__version__"]
```

## Output Checklist

Before marking complete:

- [ ] Directory structure created
- [ ] pyproject.toml configured
- [ ] Package __init__.py created
- [ ] Test conftest.py set up
- [ ] verify.sh script created
- [ ] .gitignore in place
- [ ] Virtual environment works
- [ ] `ruff check` passes
- [ ] `mypy` passes
- [ ] `pytest` runs

---

**This skill sets up complete, modern Python projects ready for development and production.**
