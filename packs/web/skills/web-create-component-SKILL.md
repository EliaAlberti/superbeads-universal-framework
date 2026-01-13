# Web Create Component Skill

## Description

You MUST use this skill before creating any React component. This applies to UI components, layout components, feature components, and any reusable React elements.

---

## Purpose

Generate complete, production-ready React components that:
- Follow React best practices
- Include proper TypeScript types
- Are accessible by default
- Support dark mode
- Are testable

## When to Use

- Creating any new React component
- Building reusable UI elements
- Implementing feature components
- Creating layout components

## Prerequisites

- Component requirements clear
- Design tokens available
- Parent component context understood

## Process

### Step 1: Determine Component Type

| Type | When to Use |
|------|-------------|
| Server Component | Default - data fetching, no interactivity |
| Client Component | useState, useEffect, event handlers |
| Async Component | Server component with data fetching |

### Step 2: Create Component

**Server Component (default):**
```tsx
// components/ui/card.tsx
import { cn } from "@/lib/utils";

interface CardProps {
  /** Card title */
  title: string;
  /** Card description */
  description?: string;
  /** Card content */
  children: React.ReactNode;
  /** Additional CSS classes */
  className?: string;
}

export function Card({
  title,
  description,
  children,
  className,
}: CardProps) {
  return (
    <div
      className={cn(
        "rounded-lg border bg-card p-6 shadow-sm",
        className
      )}
    >
      <h3 className="text-lg font-semibold">{title}</h3>
      {description && (
        <p className="mt-1 text-sm text-muted-foreground">
          {description}
        </p>
      )}
      <div className="mt-4">{children}</div>
    </div>
  );
}
```

**Client Component:**
```tsx
// components/ui/toggle.tsx
"use client";

import { useState } from "react";
import { cn } from "@/lib/utils";

interface ToggleProps {
  /** Initial state */
  defaultChecked?: boolean;
  /** Callback when toggled */
  onToggle?: (checked: boolean) => void;
  /** Accessible label */
  label: string;
  /** Additional CSS classes */
  className?: string;
}

export function Toggle({
  defaultChecked = false,
  onToggle,
  label,
  className,
}: ToggleProps) {
  const [checked, setChecked] = useState(defaultChecked);

  const handleToggle = () => {
    const newValue = !checked;
    setChecked(newValue);
    onToggle?.(newValue);
  };

  return (
    <button
      type="button"
      role="switch"
      aria-checked={checked}
      aria-label={label}
      onClick={handleToggle}
      className={cn(
        "relative inline-flex h-6 w-11 items-center rounded-full transition-colors",
        checked ? "bg-primary" : "bg-gray-200 dark:bg-gray-700",
        className
      )}
    >
      <span
        className={cn(
          "inline-block h-4 w-4 transform rounded-full bg-white transition-transform",
          checked ? "translate-x-6" : "translate-x-1"
        )}
      />
    </button>
  );
}
```

### Step 3: Define Props Interface

```tsx
interface ComponentProps {
  /** Required prop - describe what it does */
  requiredProp: string;

  /** Optional prop with default */
  optionalProp?: boolean;

  /** Children content */
  children?: React.ReactNode;

  /** Additional CSS classes */
  className?: string;

  /** Event handler */
  onClick?: () => void;
}
```

### Step 4: Implement Variants

**Using cva (class-variance-authority):**
```tsx
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2",
  {
    variants: {
      variant: {
        primary: "bg-primary text-primary-foreground hover:bg-primary/90",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        outline: "border border-input bg-background hover:bg-accent",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
      },
      size: {
        sm: "h-8 px-3 text-sm",
        md: "h-10 px-4",
        lg: "h-12 px-6 text-lg",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "md",
    },
  }
);

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  /** Loading state */
  isLoading?: boolean;
}

export function Button({
  variant,
  size,
  isLoading,
  className,
  children,
  disabled,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }), className)}
      disabled={disabled || isLoading}
      {...props}
    >
      {isLoading ? <Spinner className="mr-2" /> : null}
      {children}
    </button>
  );
}
```

### Step 5: Add Accessibility

```tsx
// Essential accessibility patterns

// 1. Interactive elements
<button
  type="button"
  aria-label="Close dialog"
  aria-pressed={isPressed}
  onClick={handleClick}
>

// 2. Form inputs
<input
  id="email"
  type="email"
  aria-describedby="email-error"
  aria-invalid={!!error}
/>
<span id="email-error" role="alert">
  {error}
</span>

// 3. Dynamic content
<div
  role="status"
  aria-live="polite"
  aria-atomic="true"
>
  {statusMessage}
</div>

// 4. Navigation
<nav aria-label="Main navigation">
  <ul role="list">
    <li><a href="/" aria-current={isHome ? "page" : undefined}>Home</a></li>
  </ul>
</nav>

// 5. Modal/Dialog
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
>
  <h2 id="dialog-title">Dialog Title</h2>
</div>
```

### Step 6: Handle Loading/Error States

```tsx
interface DataCardProps {
  data: Data | null;
  isLoading: boolean;
  error: Error | null;
}

export function DataCard({ data, isLoading, error }: DataCardProps) {
  if (isLoading) {
    return (
      <div className="animate-pulse">
        <div className="h-4 w-3/4 rounded bg-gray-200" />
        <div className="mt-2 h-4 w-1/2 rounded bg-gray-200" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-lg border border-destructive bg-destructive/10 p-4">
        <p className="text-destructive">Error: {error.message}</p>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="text-center text-muted-foreground">
        No data available
      </div>
    );
  }

  return (
    <div>
      {/* Render data */}
    </div>
  );
}
```

### Step 7: Add Tests

```tsx
// components/ui/card.test.tsx
import { render, screen } from "@testing-library/react";
import { Card } from "./card";

describe("Card", () => {
  it("renders title and children", () => {
    render(
      <Card title="Test Title">
        <p>Content</p>
      </Card>
    );

    expect(screen.getByText("Test Title")).toBeInTheDocument();
    expect(screen.getByText("Content")).toBeInTheDocument();
  });

  it("renders description when provided", () => {
    render(
      <Card title="Title" description="Description">
        Content
      </Card>
    );

    expect(screen.getByText("Description")).toBeInTheDocument();
  });

  it("applies custom className", () => {
    const { container } = render(
      <Card title="Title" className="custom-class">
        Content
      </Card>
    );

    expect(container.firstChild).toHaveClass("custom-class");
  });
});
```

## Best Practices

### Do
- Use semantic HTML elements
- Define clear prop interfaces with JSDoc
- Support className prop for customization
- Use forwardRef for DOM element access
- Handle all states (loading, error, empty)

### Don't
- Use `any` type for props
- Hardcode colors/spacing (use design tokens)
- Forget accessibility attributes
- Create components that do too much
- Skip the "use client" directive when needed

## Output Checklist

- [ ] Component file created
- [ ] Props interface defined
- [ ] TypeScript types complete
- [ ] Accessibility implemented
- [ ] Dark mode supported
- [ ] Tests created
- [ ] Exports added to index

---

**This skill creates production-ready React components with proper typing, accessibility, and testing.**
