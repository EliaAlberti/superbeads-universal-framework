# Web Testing Skill

## Description

You MUST use this skill before writing any tests for React components, hooks, or pages. This applies to unit tests, integration tests, and component tests.

---

## Purpose

Write complete, production-ready tests that:
- Use Testing Library best practices
- Test user behavior, not implementation
- Are maintainable and readable
- Cover important use cases
- Run reliably in CI

## When to Use

- Writing tests for new components
- Adding tests to existing code
- Creating test fixtures
- Testing hooks and utilities

## Prerequisites

- Vitest and Testing Library installed
- Code to test exists
- Understanding of what to test

## Process

### Step 1: Set Up Test File

```tsx
// components/ui/button.test.tsx
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import { Button } from "./button";
```

### Step 2: Write Component Tests

**Basic Rendering:**
```tsx
describe("Button", () => {
  it("renders with text", () => {
    render(<Button>Click me</Button>);

    expect(screen.getByRole("button", { name: /click me/i })).toBeInTheDocument();
  });

  it("renders with custom className", () => {
    render(<Button className="custom-class">Button</Button>);

    expect(screen.getByRole("button")).toHaveClass("custom-class");
  });

  it("is disabled when disabled prop is true", () => {
    render(<Button disabled>Button</Button>);

    expect(screen.getByRole("button")).toBeDisabled();
  });
});
```

**User Interactions:**
```tsx
describe("Button interactions", () => {
  it("calls onClick when clicked", async () => {
    const user = userEvent.setup();
    const handleClick = vi.fn();

    render(<Button onClick={handleClick}>Click me</Button>);

    await user.click(screen.getByRole("button"));

    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it("does not call onClick when disabled", async () => {
    const user = userEvent.setup();
    const handleClick = vi.fn();

    render(
      <Button onClick={handleClick} disabled>
        Click me
      </Button>
    );

    await user.click(screen.getByRole("button"));

    expect(handleClick).not.toHaveBeenCalled();
  });

  it("shows loading spinner when isLoading", () => {
    render(<Button isLoading>Submit</Button>);

    expect(screen.getByRole("button")).toBeDisabled();
    expect(screen.getByTestId("spinner")).toBeInTheDocument();
  });
});
```

**Variant Testing:**
```tsx
describe("Button variants", () => {
  it.each([
    ["primary", "bg-primary"],
    ["secondary", "bg-secondary"],
    ["destructive", "bg-destructive"],
  ])("applies %s variant styles", (variant, expectedClass) => {
    render(<Button variant={variant as any}>Button</Button>);

    expect(screen.getByRole("button")).toHaveClass(expectedClass);
  });
});
```

### Step 3: Test Forms

```tsx
// components/contact-form.test.tsx
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { describe, it, expect, vi } from "vitest";
import { ContactForm } from "./contact-form";

describe("ContactForm", () => {
  it("submits form with valid data", async () => {
    const user = userEvent.setup();
    const handleSubmit = vi.fn();

    render(<ContactForm onSubmit={handleSubmit} />);

    await user.type(screen.getByLabelText(/name/i), "John Doe");
    await user.type(screen.getByLabelText(/email/i), "john@example.com");
    await user.type(screen.getByLabelText(/message/i), "Hello!");

    await user.click(screen.getByRole("button", { name: /submit/i }));

    await waitFor(() => {
      expect(handleSubmit).toHaveBeenCalledWith({
        name: "John Doe",
        email: "john@example.com",
        message: "Hello!",
      });
    });
  });

  it("shows validation errors for empty fields", async () => {
    const user = userEvent.setup();

    render(<ContactForm onSubmit={vi.fn()} />);

    await user.click(screen.getByRole("button", { name: /submit/i }));

    expect(await screen.findByText(/name is required/i)).toBeInTheDocument();
    expect(screen.getByText(/email is required/i)).toBeInTheDocument();
  });

  it("shows error for invalid email", async () => {
    const user = userEvent.setup();

    render(<ContactForm onSubmit={vi.fn()} />);

    await user.type(screen.getByLabelText(/name/i), "John");
    await user.type(screen.getByLabelText(/email/i), "invalid");
    await user.click(screen.getByRole("button", { name: /submit/i }));

    expect(await screen.findByText(/invalid email/i)).toBeInTheDocument();
  });
});
```

### Step 4: Test Hooks

```tsx
// hooks/use-counter.test.ts
import { renderHook, act } from "@testing-library/react";
import { describe, it, expect } from "vitest";
import { useCounter } from "./use-counter";

describe("useCounter", () => {
  it("initializes with default value", () => {
    const { result } = renderHook(() => useCounter());

    expect(result.current.count).toBe(0);
  });

  it("increments count", () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });

  it("decrements count", () => {
    const { result } = renderHook(() => useCounter({ initialValue: 5 }));

    act(() => {
      result.current.decrement();
    });

    expect(result.current.count).toBe(4);
  });
});
```

### Step 5: Test Async Behavior

```tsx
// components/user-profile.test.tsx
import { render, screen, waitFor } from "@testing-library/react";
import { describe, it, expect, vi, beforeEach } from "vitest";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { UserProfile } from "./user-profile";

// Mock fetch
global.fetch = vi.fn();

function createTestQueryClient() {
  return new QueryClient({
    defaultOptions: {
      queries: {
        retry: false,
      },
    },
  });
}

function renderWithClient(ui: React.ReactElement) {
  const queryClient = createTestQueryClient();
  return render(
    <QueryClientProvider client={queryClient}>{ui}</QueryClientProvider>
  );
}

describe("UserProfile", () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it("shows loading state initially", () => {
    (fetch as any).mockImplementation(() => new Promise(() => {}));

    renderWithClient(<UserProfile userId="1" />);

    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it("shows user data when loaded", async () => {
    (fetch as any).mockResolvedValue({
      ok: true,
      json: () => Promise.resolve({ id: "1", name: "John Doe" }),
    });

    renderWithClient(<UserProfile userId="1" />);

    await waitFor(() => {
      expect(screen.getByText("John Doe")).toBeInTheDocument();
    });
  });

  it("shows error state on failure", async () => {
    (fetch as any).mockRejectedValue(new Error("Failed to fetch"));

    renderWithClient(<UserProfile userId="1" />);

    await waitFor(() => {
      expect(screen.getByText(/error/i)).toBeInTheDocument();
    });
  });
});
```

### Step 6: Test Accessibility

```tsx
import { axe, toHaveNoViolations } from "jest-axe";

expect.extend(toHaveNoViolations);

describe("Button accessibility", () => {
  it("has no accessibility violations", async () => {
    const { container } = render(<Button>Click me</Button>);

    const results = await axe(container);

    expect(results).toHaveNoViolations();
  });

  it("is keyboard accessible", async () => {
    const user = userEvent.setup();
    const handleClick = vi.fn();

    render(<Button onClick={handleClick}>Button</Button>);

    await user.tab();
    expect(screen.getByRole("button")).toHaveFocus();

    await user.keyboard("{Enter}");
    expect(handleClick).toHaveBeenCalled();
  });
});
```

## Testing Best Practices

### Query Priority

1. `getByRole` - Most preferred, tests accessibility
2. `getByLabelText` - For form elements
3. `getByPlaceholderText` - When label not available
4. `getByText` - For non-interactive elements
5. `getByTestId` - Last resort

### Do
- Test user behavior, not implementation
- Use `userEvent` over `fireEvent`
- Wait for async operations
- Test accessibility
- Keep tests focused

### Don't
- Test implementation details
- Test third-party libraries
- Write brittle selectors
- Skip cleanup
- Ignore async warnings

## Output Checklist

- [ ] Test file created
- [ ] Rendering tests
- [ ] Interaction tests
- [ ] Edge cases covered
- [ ] Async behavior tested
- [ ] No implementation details tested
- [ ] Uses proper queries

---

**This skill creates comprehensive, maintainable tests following Testing Library best practices.**
