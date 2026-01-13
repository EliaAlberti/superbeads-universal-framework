# Python Async Skill

## Description

You MUST use this skill before implementing any async/await patterns, concurrent operations, or asyncio-based code. This applies to async functions, task management, and concurrent I/O.

---

## Purpose

Implement production-ready async code that:
- Uses asyncio correctly
- Handles concurrency safely
- Manages resources properly
- Handles cancellation gracefully
- Is testable

## When to Use

- Writing async functions
- Implementing concurrent operations
- Managing async resources
- Building async services

## Prerequisites

- Async requirements clear
- Understanding of asyncio basics
- Appropriate async libraries available

## Process

### Step 1: Basic Async Patterns

**Async Function:**

```python
"""Basic async patterns."""
from __future__ import annotations

import asyncio
from typing import Any


async def fetch_data(url: str) -> dict[str, Any]:
    """Fetch data from URL.

    Args:
        url: The URL to fetch from.

    Returns:
        Parsed JSON response.

    Raises:
        httpx.HTTPError: If request fails.
    """
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        response.raise_for_status()
        return response.json()


async def process_item(item: str) -> str:
    """Process single item asynchronously.

    Args:
        item: Item to process.

    Returns:
        Processed item.
    """
    await asyncio.sleep(0.1)  # Simulate I/O
    return item.upper()
```

**Running Async Code:**

```python
# From sync context (entry point)
async def main() -> None:
    result = await fetch_data("https://api.example.com/data")
    print(result)


if __name__ == "__main__":
    asyncio.run(main())
```

### Step 2: Concurrent Execution

**Gather (run all, collect results):**

```python
async def fetch_all(urls: list[str]) -> list[dict[str, Any]]:
    """Fetch multiple URLs concurrently.

    Args:
        urls: List of URLs to fetch.

    Returns:
        List of responses in same order as URLs.
    """
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [r.json() for r in responses]
```

**Gather with Error Handling:**

```python
async def fetch_all_safe(urls: list[str]) -> list[dict | None]:
    """Fetch URLs, returning None for failures.

    Args:
        urls: List of URLs to fetch.

    Returns:
        List of responses or None for failed requests.
    """
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        processed = []
        for result in results:
            if isinstance(result, Exception):
                processed.append(None)
            else:
                processed.append(result.json())
        return processed
```

**TaskGroup (Python 3.11+):**

```python
async def process_with_taskgroup(items: list[str]) -> list[str]:
    """Process items using TaskGroup.

    TaskGroup ensures all tasks complete or all are cancelled on error.

    Args:
        items: Items to process.

    Returns:
        Processed items.
    """
    results: list[str] = []

    async with asyncio.TaskGroup() as tg:
        for item in items:
            tg.create_task(process_and_store(item, results))

    return results


async def process_and_store(item: str, results: list[str]) -> None:
    """Process item and store result."""
    processed = await process_item(item)
    results.append(processed)
```

### Step 3: Concurrency Limits

**Semaphore for Rate Limiting:**

```python
async def fetch_with_limit(
    urls: list[str],
    max_concurrent: int = 10,
) -> list[dict[str, Any]]:
    """Fetch URLs with concurrency limit.

    Args:
        urls: URLs to fetch.
        max_concurrent: Maximum concurrent requests.

    Returns:
        List of responses.
    """
    semaphore = asyncio.Semaphore(max_concurrent)

    async def fetch_one(url: str) -> dict[str, Any]:
        async with semaphore:
            async with httpx.AsyncClient() as client:
                response = await client.get(url)
                return response.json()

    tasks = [fetch_one(url) for url in urls]
    return await asyncio.gather(*tasks)
```

**Generic Concurrency Limiter:**

```python
from typing import TypeVar, Coroutine, Any

T = TypeVar("T")


async def gather_with_concurrency(
    n: int,
    *coros: Coroutine[Any, Any, T],
) -> list[T]:
    """Run coroutines with maximum concurrency.

    Args:
        n: Maximum concurrent coroutines.
        *coros: Coroutines to run.

    Returns:
        Results in order.
    """
    semaphore = asyncio.Semaphore(n)

    async def limited_coro(coro: Coroutine[Any, Any, T]) -> T:
        async with semaphore:
            return await coro

    return await asyncio.gather(*(limited_coro(c) for c in coros))


# Usage
results = await gather_with_concurrency(
    5,
    fetch("url1"),
    fetch("url2"),
    fetch("url3"),
    # ... more
)
```

### Step 4: Timeouts

**Operation Timeout:**

```python
async def fetch_with_timeout(
    url: str,
    timeout_seconds: float = 30.0,
) -> dict[str, Any]:
    """Fetch with timeout.

    Args:
        url: URL to fetch.
        timeout_seconds: Timeout in seconds.

    Returns:
        Response data.

    Raises:
        asyncio.TimeoutError: If operation times out.
    """
    async with asyncio.timeout(timeout_seconds):
        async with httpx.AsyncClient() as client:
            response = await client.get(url)
            return response.json()
```

**Timeout with Fallback:**

```python
async def fetch_with_fallback(
    url: str,
    fallback: dict[str, Any],
    timeout_seconds: float = 5.0,
) -> dict[str, Any]:
    """Fetch with timeout, returning fallback on failure.

    Args:
        url: URL to fetch.
        fallback: Value to return on timeout.
        timeout_seconds: Timeout in seconds.

    Returns:
        Response data or fallback.
    """
    try:
        async with asyncio.timeout(timeout_seconds):
            async with httpx.AsyncClient() as client:
                response = await client.get(url)
                return response.json()
    except asyncio.TimeoutError:
        return fallback
```

### Step 5: Async Context Managers

```python
"""Async resource management."""
from __future__ import annotations

from contextlib import asynccontextmanager
from typing import AsyncIterator


@asynccontextmanager
async def managed_connection(url: str) -> AsyncIterator[Connection]:
    """Provide managed database connection.

    Args:
        url: Database connection URL.

    Yields:
        Active database connection.
    """
    conn = await connect(url)
    try:
        yield conn
    finally:
        await conn.close()


# Usage
async with managed_connection("postgres://...") as conn:
    result = await conn.execute("SELECT 1")


class AsyncDatabasePool:
    """Async database connection pool."""

    def __init__(self, url: str, size: int = 10) -> None:
        self.url = url
        self.size = size
        self._pool: asyncpg.Pool | None = None

    async def __aenter__(self) -> "AsyncDatabasePool":
        """Initialize pool on context enter."""
        self._pool = await asyncpg.create_pool(
            self.url,
            min_size=2,
            max_size=self.size,
        )
        return self

    async def __aexit__(self, *args: object) -> None:
        """Close pool on context exit."""
        if self._pool:
            await self._pool.close()

    async def execute(self, query: str) -> list[dict]:
        """Execute query using pool."""
        if not self._pool:
            raise RuntimeError("Pool not initialized")
        async with self._pool.acquire() as conn:
            return await conn.fetch(query)


# Usage
async with AsyncDatabasePool("postgres://...") as pool:
    results = await pool.execute("SELECT * FROM users")
```

### Step 6: Async Iterators

```python
"""Async iteration patterns."""
from __future__ import annotations

from typing import AsyncIterator


async def stream_data(source: str) -> AsyncIterator[dict]:
    """Stream data from source.

    Args:
        source: Data source URL.

    Yields:
        Data items as they become available.
    """
    async with httpx.AsyncClient() as client:
        async with client.stream("GET", source) as response:
            async for line in response.aiter_lines():
                if line:
                    yield json.loads(line)


async def process_stream(source: str) -> int:
    """Process streamed data.

    Args:
        source: Data source URL.

    Returns:
        Count of processed items.
    """
    count = 0
    async for item in stream_data(source):
        await process_item(item)
        count += 1
    return count


class AsyncBatcher:
    """Batch async iterator items."""

    def __init__(
        self,
        source: AsyncIterator[T],
        batch_size: int = 100,
    ) -> None:
        self.source = source
        self.batch_size = batch_size

    async def __aiter__(self) -> AsyncIterator[list[T]]:
        batch: list[T] = []
        async for item in self.source:
            batch.append(item)
            if len(batch) >= self.batch_size:
                yield batch
                batch = []
        if batch:
            yield batch


# Usage
async for batch in AsyncBatcher(stream_data(url), batch_size=50):
    await process_batch(batch)
```

### Step 7: Cancellation Handling

```python
"""Graceful cancellation handling."""
from __future__ import annotations

import asyncio
import signal


async def long_running_task() -> None:
    """Task that handles cancellation gracefully."""
    try:
        while True:
            await asyncio.sleep(1)
            # Do work...
    except asyncio.CancelledError:
        # Cleanup before exiting
        await cleanup()
        raise  # Re-raise to propagate cancellation


async def run_with_graceful_shutdown() -> None:
    """Run tasks with graceful shutdown on signals."""
    shutdown_event = asyncio.Event()

    def signal_handler() -> None:
        shutdown_event.set()

    loop = asyncio.get_running_loop()
    for sig in (signal.SIGTERM, signal.SIGINT):
        loop.add_signal_handler(sig, signal_handler)

    task = asyncio.create_task(long_running_task())

    # Wait for either task completion or shutdown signal
    done, pending = await asyncio.wait(
        [task, asyncio.create_task(shutdown_event.wait())],
        return_when=asyncio.FIRST_COMPLETED,
    )

    # Cancel pending tasks
    for t in pending:
        t.cancel()
        try:
            await t
        except asyncio.CancelledError:
            pass
```

### Step 8: Testing Async Code

```python
"""Tests for async code."""
import pytest
import asyncio


class TestAsyncFunctions:
    """Tests for async functions."""

    async def test_fetch_returns_data(self) -> None:
        """Fetch returns expected data structure."""
        result = await fetch_data("https://api.example.com/data")
        assert "id" in result

    async def test_process_all_items(self) -> None:
        """All items are processed."""
        items = ["a", "b", "c"]
        results = await asyncio.gather(*[process_item(i) for i in items])
        assert results == ["A", "B", "C"]

    async def test_timeout_raises(self) -> None:
        """Timeout raises TimeoutError."""
        with pytest.raises(asyncio.TimeoutError):
            async with asyncio.timeout(0.01):
                await asyncio.sleep(1)

    async def test_cancellation_cleanup(self) -> None:
        """Cancellation triggers cleanup."""
        cleanup_called = False

        async def task_with_cleanup() -> None:
            nonlocal cleanup_called
            try:
                await asyncio.sleep(10)
            except asyncio.CancelledError:
                cleanup_called = True
                raise

        task = asyncio.create_task(task_with_cleanup())
        await asyncio.sleep(0.01)
        task.cancel()

        with pytest.raises(asyncio.CancelledError):
            await task

        assert cleanup_called
```

## Output Checklist

Before marking complete:

- [ ] Async functions properly typed
- [ ] Concurrency limits where needed
- [ ] Timeouts on I/O operations
- [ ] Resources properly managed
- [ ] Cancellation handled
- [ ] Tests cover async behavior
- [ ] No blocking calls in async code

---

**This skill creates production-ready async code with proper concurrency, resource management, and error handling.**
