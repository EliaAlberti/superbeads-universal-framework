# Web Create Hook Skill

## Description

You MUST use this skill before creating any custom React hook. This applies to data fetching hooks, state management hooks, utility hooks, and any reusable hook logic.

---

## Purpose

Generate complete, production-ready React hooks that:
- Follow React hook rules
- Are properly typed with TypeScript
- Are testable
- Handle edge cases
- Are reusable

## When to Use

- Creating data fetching logic
- Encapsulating stateful behavior
- Creating utility hooks
- Abstracting complex state

## Prerequisites

- Hook purpose clear
- Return value defined
- Dependencies understood

## Process

### Step 1: Define Hook Interface

```tsx
// Define what the hook returns
interface UseCounterReturn {
  count: number;
  increment: () => void;
  decrement: () => void;
  reset: () => void;
}

// Define parameters if needed
interface UseCounterOptions {
  initialValue?: number;
  min?: number;
  max?: number;
}
```

### Step 2: Create Hook

**Basic Hook:**
```tsx
// hooks/use-counter.ts
import { useState, useCallback } from "react";

interface UseCounterOptions {
  initialValue?: number;
  min?: number;
  max?: number;
}

interface UseCounterReturn {
  count: number;
  increment: () => void;
  decrement: () => void;
  reset: () => void;
}

export function useCounter(options: UseCounterOptions = {}): UseCounterReturn {
  const { initialValue = 0, min, max } = options;
  const [count, setCount] = useState(initialValue);

  const increment = useCallback(() => {
    setCount((c) => {
      const next = c + 1;
      return max !== undefined ? Math.min(next, max) : next;
    });
  }, [max]);

  const decrement = useCallback(() => {
    setCount((c) => {
      const next = c - 1;
      return min !== undefined ? Math.max(next, min) : next;
    });
  }, [min]);

  const reset = useCallback(() => {
    setCount(initialValue);
  }, [initialValue]);

  return { count, increment, decrement, reset };
}
```

**Data Fetching Hook:**
```tsx
// hooks/use-user.ts
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";

interface User {
  id: string;
  name: string;
  email: string;
}

interface UseUserOptions {
  userId: string;
  enabled?: boolean;
}

async function fetchUser(userId: string): Promise<User> {
  const res = await fetch(`/api/users/${userId}`);
  if (!res.ok) throw new Error("Failed to fetch user");
  return res.json();
}

async function updateUser(userId: string, data: Partial<User>): Promise<User> {
  const res = await fetch(`/api/users/${userId}`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to update user");
  return res.json();
}

export function useUser({ userId, enabled = true }: UseUserOptions) {
  const queryClient = useQueryClient();

  const query = useQuery({
    queryKey: ["user", userId],
    queryFn: () => fetchUser(userId),
    enabled,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });

  const mutation = useMutation({
    mutationFn: (data: Partial<User>) => updateUser(userId, data),
    onSuccess: (updatedUser) => {
      queryClient.setQueryData(["user", userId], updatedUser);
    },
  });

  return {
    user: query.data,
    isLoading: query.isLoading,
    error: query.error,
    updateUser: mutation.mutate,
    isUpdating: mutation.isPending,
    updateError: mutation.error,
  };
}
```

**Local Storage Hook:**
```tsx
// hooks/use-local-storage.ts
import { useState, useEffect, useCallback } from "react";

export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T | ((prev: T) => T)) => void] {
  // Get initial value from storage or use default
  const [storedValue, setStoredValue] = useState<T>(() => {
    if (typeof window === "undefined") {
      return initialValue;
    }
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      console.error(`Error reading localStorage key "${key}":`, error);
      return initialValue;
    }
  });

  // Update localStorage when value changes
  const setValue = useCallback(
    (value: T | ((prev: T) => T)) => {
      try {
        const valueToStore =
          value instanceof Function ? value(storedValue) : value;
        setStoredValue(valueToStore);
        if (typeof window !== "undefined") {
          window.localStorage.setItem(key, JSON.stringify(valueToStore));
        }
      } catch (error) {
        console.error(`Error setting localStorage key "${key}":`, error);
      }
    },
    [key, storedValue]
  );

  return [storedValue, setValue];
}
```

**Debounce Hook:**
```tsx
// hooks/use-debounce.ts
import { useState, useEffect } from "react";

export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timer = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(timer);
    };
  }, [value, delay]);

  return debouncedValue;
}

// Usage example:
// const debouncedSearchTerm = useDebounce(searchTerm, 300);
// useEffect(() => {
//   search(debouncedSearchTerm);
// }, [debouncedSearchTerm]);
```

**Media Query Hook:**
```tsx
// hooks/use-media-query.ts
import { useState, useEffect } from "react";

export function useMediaQuery(query: string): boolean {
  const [matches, setMatches] = useState(false);

  useEffect(() => {
    const mediaQuery = window.matchMedia(query);
    setMatches(mediaQuery.matches);

    const handler = (event: MediaQueryListEvent) => {
      setMatches(event.matches);
    };

    mediaQuery.addEventListener("change", handler);
    return () => mediaQuery.removeEventListener("change", handler);
  }, [query]);

  return matches;
}

// Convenience hooks
export function useIsMobile(): boolean {
  return useMediaQuery("(max-width: 768px)");
}

export function usePrefersDark(): boolean {
  return useMediaQuery("(prefers-color-scheme: dark)");
}
```

**Click Outside Hook:**
```tsx
// hooks/use-click-outside.ts
import { useEffect, useRef, type RefObject } from "react";

export function useClickOutside<T extends HTMLElement>(
  handler: () => void
): RefObject<T> {
  const ref = useRef<T>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent | TouchEvent) => {
      if (ref.current && !ref.current.contains(event.target as Node)) {
        handler();
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    document.addEventListener("touchstart", handleClickOutside);

    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
      document.removeEventListener("touchstart", handleClickOutside);
    };
  }, [handler]);

  return ref;
}

// Usage:
// const dropdownRef = useClickOutside<HTMLDivElement>(() => setOpen(false));
// <div ref={dropdownRef}>...</div>
```

### Step 3: Add Tests

```tsx
// hooks/use-counter.test.ts
import { renderHook, act } from "@testing-library/react";
import { useCounter } from "./use-counter";

describe("useCounter", () => {
  it("initializes with default value", () => {
    const { result } = renderHook(() => useCounter());
    expect(result.current.count).toBe(0);
  });

  it("initializes with custom value", () => {
    const { result } = renderHook(() =>
      useCounter({ initialValue: 10 })
    );
    expect(result.current.count).toBe(10);
  });

  it("increments count", () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });

  it("decrements count", () => {
    const { result } = renderHook(() =>
      useCounter({ initialValue: 5 })
    );

    act(() => {
      result.current.decrement();
    });

    expect(result.current.count).toBe(4);
  });

  it("respects max limit", () => {
    const { result } = renderHook(() =>
      useCounter({ initialValue: 9, max: 10 })
    );

    act(() => {
      result.current.increment();
      result.current.increment();
    });

    expect(result.current.count).toBe(10);
  });

  it("respects min limit", () => {
    const { result } = renderHook(() =>
      useCounter({ initialValue: 1, min: 0 })
    );

    act(() => {
      result.current.decrement();
      result.current.decrement();
    });

    expect(result.current.count).toBe(0);
  });

  it("resets to initial value", () => {
    const { result } = renderHook(() =>
      useCounter({ initialValue: 5 })
    );

    act(() => {
      result.current.increment();
      result.current.increment();
      result.current.reset();
    });

    expect(result.current.count).toBe(5);
  });
});
```

## Hook Rules

1. **Only call hooks at the top level** - Never inside loops, conditions, or nested functions
2. **Only call hooks from React functions** - Components or custom hooks
3. **Name must start with "use"** - `useCounter`, not `getCounter`
4. **Keep dependencies honest** - Include all values used inside

## Best Practices

### Do
- Return a consistent object shape
- Memoize callbacks with useCallback
- Handle cleanup in useEffect
- Consider SSR compatibility
- Type return values explicitly

### Don't
- Mutate state directly
- Forget cleanup functions
- Ignore dependency arrays
- Create hooks with too many responsibilities
- Call hooks conditionally

## Output Checklist

- [ ] Hook file created
- [ ] TypeScript types complete
- [ ] Return interface defined
- [ ] Callbacks memoized
- [ ] Effects have cleanup
- [ ] Tests created
- [ ] Exported from hooks/index.ts

---

**This skill creates production-ready React hooks with proper typing, testing, and React patterns.**
