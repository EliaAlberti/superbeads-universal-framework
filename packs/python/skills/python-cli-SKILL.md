# Python CLI Skill

## Description

You MUST use this skill before creating any command-line interface. This applies to CLI applications using Typer, Click, or argparse.

---

## Purpose

Create complete, production-ready CLI applications that:
- Use Typer for modern CLI development
- Include proper help text and documentation
- Handle errors gracefully
- Support configuration and options
- Are testable

## When to Use

- Creating a new CLI application
- Adding commands to existing CLI
- Building developer tools
- Creating automation scripts

## Prerequisites

- CLI requirements clear
- Commands and options defined
- Typer installed

## Process

### Step 1: Basic CLI Structure

```python
"""MyTool CLI - Description of what it does."""
from __future__ import annotations

import typer

app = typer.Typer(
    name="mytool",
    help="A helpful description of your CLI tool.",
    no_args_is_help=True,
)


@app.command()
def main(
    name: str = typer.Argument(..., help="The name to greet"),
    count: int = typer.Option(1, "--count", "-c", help="Number of greetings"),
    uppercase: bool = typer.Option(False, "--uppercase", "-u", help="Uppercase the output"),
) -> None:
    """Greet someone by name.

    This command greets the specified NAME the specified number of times.
    """
    greeting = f"Hello, {name}!"
    if uppercase:
        greeting = greeting.upper()

    for _ in range(count):
        typer.echo(greeting)


if __name__ == "__main__":
    app()
```

### Step 2: Multiple Commands

```python
"""Multi-command CLI application."""
from __future__ import annotations

from pathlib import Path
from typing import Annotated

import typer

app = typer.Typer(
    name="myapp",
    help="Application with multiple commands.",
    no_args_is_help=True,
)


@app.command()
def init(
    path: Annotated[
        Path,
        typer.Argument(help="Directory to initialize"),
    ] = Path("."),
    force: Annotated[
        bool,
        typer.Option("--force", "-f", help="Overwrite existing files"),
    ] = False,
) -> None:
    """Initialize a new project.

    Creates the necessary directory structure and configuration files.
    """
    if path.exists() and not force:
        typer.echo(f"Directory {path} already exists. Use --force to overwrite.")
        raise typer.Exit(code=1)

    path.mkdir(parents=True, exist_ok=True)
    typer.echo(f"Initialized project in {path}")


@app.command()
def build(
    config: Annotated[
        Path,
        typer.Option("--config", "-c", help="Configuration file"),
    ] = Path("config.toml"),
    verbose: Annotated[
        bool,
        typer.Option("--verbose", "-v", help="Verbose output"),
    ] = False,
) -> None:
    """Build the project.

    Reads configuration and builds all artifacts.
    """
    if not config.exists():
        typer.echo(f"Config file {config} not found", err=True)
        raise typer.Exit(code=1)

    if verbose:
        typer.echo(f"Using config: {config}")

    typer.echo("Building...")
    typer.echo("Build complete!")


@app.command()
def clean(
    all_files: Annotated[
        bool,
        typer.Option("--all", "-a", help="Remove all generated files"),
    ] = False,
) -> None:
    """Clean build artifacts.

    Removes generated files and directories.
    """
    typer.echo("Cleaning...")
    if all_files:
        typer.echo("Removing all generated files")
    typer.echo("Clean complete!")


if __name__ == "__main__":
    app()
```

### Step 3: Command Groups

```python
"""CLI with command groups (subcommands)."""
from __future__ import annotations

import typer

# Main app
app = typer.Typer(help="Main application")

# User commands group
users_app = typer.Typer(help="User management commands")
app.add_typer(users_app, name="users")

# Database commands group
db_app = typer.Typer(help="Database commands")
app.add_typer(db_app, name="db")


@users_app.command("list")
def list_users(
    limit: int = typer.Option(10, "--limit", "-l"),
) -> None:
    """List all users."""
    typer.echo(f"Listing up to {limit} users...")


@users_app.command("create")
def create_user(
    name: str = typer.Argument(...),
    email: str = typer.Option(..., "--email", "-e"),
) -> None:
    """Create a new user."""
    typer.echo(f"Creating user: {name} <{email}>")


@users_app.command("delete")
def delete_user(
    user_id: int = typer.Argument(...),
    force: bool = typer.Option(False, "--force", "-f"),
) -> None:
    """Delete a user by ID."""
    if not force:
        confirm = typer.confirm(f"Delete user {user_id}?")
        if not confirm:
            raise typer.Abort()
    typer.echo(f"Deleted user {user_id}")


@db_app.command("migrate")
def migrate(
    target: str = typer.Option("head", "--target", "-t"),
) -> None:
    """Run database migrations."""
    typer.echo(f"Migrating to: {target}")


@db_app.command("reset")
def reset() -> None:
    """Reset database to initial state."""
    confirm = typer.confirm("This will delete all data. Continue?", abort=True)
    typer.echo("Database reset complete")


# Usage: myapp users list
#        myapp users create "John" --email john@example.com
#        myapp db migrate
```

### Step 4: Rich Output

```python
"""CLI with rich formatting."""
from __future__ import annotations

import typer
from rich.console import Console
from rich.table import Table
from rich.progress import track
from rich.panel import Panel
import time

console = Console()
app = typer.Typer()


@app.command()
def status() -> None:
    """Show system status."""
    table = Table(title="System Status")
    table.add_column("Component", style="cyan")
    table.add_column("Status", style="green")
    table.add_column("Details")

    table.add_row("Database", "OK", "PostgreSQL 15.2")
    table.add_row("Cache", "OK", "Redis 7.0")
    table.add_row("Queue", "Warning", "3 jobs pending")

    console.print(table)


@app.command()
def process(
    items: int = typer.Option(100, "--items", "-n"),
) -> None:
    """Process items with progress bar."""
    results = []
    for i in track(range(items), description="Processing..."):
        time.sleep(0.01)
        results.append(i)

    console.print(f"[green]Processed {len(results)} items[/green]")


@app.command()
def info() -> None:
    """Show application info."""
    console.print(Panel.fit(
        "[bold blue]MyApp[/bold blue] v1.0.0\n\n"
        "A tool for doing things.\n"
        "Visit: https://example.com",
        title="About",
        border_style="blue",
    ))


@app.command()
def confirm_action() -> None:
    """Action requiring confirmation."""
    if not typer.confirm("Are you sure?"):
        console.print("[yellow]Cancelled[/yellow]")
        raise typer.Exit()

    console.print("[green]Action completed![/green]")
```

### Step 5: Configuration and Context

```python
"""CLI with configuration and context."""
from __future__ import annotations

from pathlib import Path
from typing import Annotated
import json

import typer

app = typer.Typer()


class Config:
    """Application configuration."""

    def __init__(self, path: Path) -> None:
        self.path = path
        self._data: dict = {}
        if path.exists():
            self._data = json.loads(path.read_text())

    def get(self, key: str, default: str | None = None) -> str | None:
        return self._data.get(key, default)

    def set(self, key: str, value: str) -> None:
        self._data[key] = value
        self.path.write_text(json.dumps(self._data, indent=2))


@app.callback()
def main(
    ctx: typer.Context,
    config_file: Annotated[
        Path,
        typer.Option("--config", "-c", envvar="MYAPP_CONFIG"),
    ] = Path.home() / ".myapp.json",
    verbose: Annotated[
        bool,
        typer.Option("--verbose", "-v", envvar="MYAPP_VERBOSE"),
    ] = False,
) -> None:
    """MyApp - Application with global config."""
    ctx.ensure_object(dict)
    ctx.obj["config"] = Config(config_file)
    ctx.obj["verbose"] = verbose


@app.command()
def show_config(ctx: typer.Context) -> None:
    """Show current configuration."""
    config: Config = ctx.obj["config"]
    verbose: bool = ctx.obj["verbose"]

    if verbose:
        typer.echo(f"Config file: {config.path}")

    typer.echo(f"API URL: {config.get('api_url', 'not set')}")


@app.command()
def set_config(
    ctx: typer.Context,
    key: str = typer.Argument(...),
    value: str = typer.Argument(...),
) -> None:
    """Set configuration value."""
    config: Config = ctx.obj["config"]
    config.set(key, value)
    typer.echo(f"Set {key}={value}")
```

### Step 6: Error Handling

```python
"""CLI with proper error handling."""
from __future__ import annotations

import sys
import typer
from rich.console import Console

console = Console(stderr=True)
app = typer.Typer()


class AppError(Exception):
    """Application error with exit code."""

    def __init__(self, message: str, code: int = 1) -> None:
        self.message = message
        self.code = code
        super().__init__(message)


def error_handler(func):
    """Decorator for consistent error handling."""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except AppError as e:
            console.print(f"[red]Error:[/red] {e.message}")
            raise typer.Exit(code=e.code)
        except KeyboardInterrupt:
            console.print("\n[yellow]Interrupted[/yellow]")
            raise typer.Exit(code=130)
        except Exception as e:
            console.print(f"[red]Unexpected error:[/red] {e}")
            raise typer.Exit(code=1)
    return wrapper


@app.command()
@error_handler
def risky_command(
    fail: bool = typer.Option(False, "--fail"),
) -> None:
    """Command that might fail."""
    if fail:
        raise AppError("Something went wrong", code=2)
    typer.echo("Success!")
```

### Step 7: Testing CLI

```python
"""Tests for CLI commands."""
from typer.testing import CliRunner
import pytest

from myapp.cli import app

runner = CliRunner()


class TestInitCommand:
    """Tests for init command."""

    def test_init_creates_directory(self, tmp_path) -> None:
        """Init creates project directory."""
        target = tmp_path / "new_project"

        result = runner.invoke(app, ["init", str(target)])

        assert result.exit_code == 0
        assert target.exists()
        assert "Initialized" in result.stdout

    def test_init_fails_on_existing_directory(self, tmp_path) -> None:
        """Init fails if directory exists without --force."""
        target = tmp_path / "existing"
        target.mkdir()

        result = runner.invoke(app, ["init", str(target)])

        assert result.exit_code == 1
        assert "already exists" in result.stdout

    def test_init_force_overwrites(self, tmp_path) -> None:
        """Init with --force overwrites existing."""
        target = tmp_path / "existing"
        target.mkdir()

        result = runner.invoke(app, ["init", str(target), "--force"])

        assert result.exit_code == 0


class TestBuildCommand:
    """Tests for build command."""

    def test_build_requires_config(self, tmp_path) -> None:
        """Build fails without config file."""
        result = runner.invoke(
            app, ["build", "--config", str(tmp_path / "missing.toml")]
        )

        assert result.exit_code == 1
        assert "not found" in result.stdout
```

## Output Checklist

Before marking complete:

- [ ] Commands have help text
- [ ] Arguments and options documented
- [ ] Error handling in place
- [ ] Exit codes used correctly
- [ ] Rich output for user-facing commands
- [ ] Tests cover all commands
- [ ] Entry point configured

---

**This skill creates production-ready CLI applications with Typer, proper documentation, and testing.**
