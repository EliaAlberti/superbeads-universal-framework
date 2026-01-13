# Web Styling Skill

## Description

You MUST use this skill before implementing styling in React/Next.js components. This applies to Tailwind CSS patterns, design tokens, dark mode, and responsive design.

---

## Purpose

Implement production-ready styling that:
- Uses Tailwind CSS effectively
- Supports dark mode
- Is responsive
- Uses design tokens
- Is maintainable

## When to Use

- Styling any component
- Setting up design system
- Implementing dark mode
- Creating responsive layouts

## Prerequisites

- Tailwind CSS configured
- Design tokens defined
- Styling requirements clear

## Process

### Step 1: Use Design Tokens

**Define Tokens in CSS:**
```css
/* app/globals.css */
@layer base {
  :root {
    /* Colors */
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --primary: 222.2 47.4% 11.2%;
    --primary-foreground: 210 40% 98%;
    --secondary: 210 40% 96%;
    --muted: 210 40% 96%;
    --muted-foreground: 215.4 16.3% 46.9%;
    --destructive: 0 84.2% 60.2%;
    --border: 214.3 31.8% 91.4%;
    --ring: 222.2 84% 4.9%;

    /* Spacing */
    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --primary: 210 40% 98%;
    --primary-foreground: 222.2 47.4% 11.2%;
    /* ... dark mode values */
  }
}
```

**Use in Tailwind Config:**
```ts
// tailwind.config.ts
export default {
  theme: {
    extend: {
      colors: {
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        // ... more colors
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
    },
  },
};
```

### Step 2: Component Styling Patterns

**Basic Component:**
```tsx
export function Card({ className, children }: CardProps) {
  return (
    <div
      className={cn(
        // Base styles
        "rounded-lg border bg-card text-card-foreground shadow-sm",
        // Allow overrides
        className
      )}
    >
      {children}
    </div>
  );
}
```

**Variant Styling with CVA:**
```tsx
import { cva, type VariantProps } from "class-variance-authority";

const buttonVariants = cva(
  // Base styles
  "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
);

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

export function Button({ className, variant, size, ...props }: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    />
  );
}
```

### Step 3: Responsive Design

**Mobile-First Approach:**
```tsx
export function ResponsiveCard() {
  return (
    <div className="
      p-4              /* Mobile: small padding */
      md:p-6           /* Tablet: medium padding */
      lg:p-8           /* Desktop: large padding */

      grid
      grid-cols-1      /* Mobile: single column */
      md:grid-cols-2   /* Tablet: two columns */
      lg:grid-cols-3   /* Desktop: three columns */
      gap-4
    ">
      {/* content */}
    </div>
  );
}
```

**Responsive Container:**
```tsx
export function Container({ children, className }: ContainerProps) {
  return (
    <div
      className={cn(
        "mx-auto w-full px-4",
        "sm:max-w-screen-sm sm:px-6",
        "md:max-w-screen-md",
        "lg:max-w-screen-lg lg:px-8",
        "xl:max-w-screen-xl",
        className
      )}
    >
      {children}
    </div>
  );
}
```

**Hide/Show by Breakpoint:**
```tsx
<div>
  {/* Mobile only */}
  <MobileNav className="md:hidden" />

  {/* Desktop only */}
  <DesktopNav className="hidden md:block" />
</div>
```

### Step 4: Dark Mode

**Theme Provider:**
```tsx
// components/theme-provider.tsx
"use client";

import { ThemeProvider as NextThemesProvider } from "next-themes";

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  return (
    <NextThemesProvider
      attribute="class"
      defaultTheme="system"
      enableSystem
      disableTransitionOnChange
    >
      {children}
    </NextThemesProvider>
  );
}
```

**Theme Toggle:**
```tsx
"use client";

import { useTheme } from "next-themes";
import { Moon, Sun } from "lucide-react";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();

  return (
    <button
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
      className="rounded-md p-2 hover:bg-accent"
    >
      <Sun className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
      <Moon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
      <span className="sr-only">Toggle theme</span>
    </button>
  );
}
```

**Dark Mode Styling:**
```tsx
<div className="
  bg-white           /* Light mode */
  dark:bg-gray-900   /* Dark mode */

  text-gray-900
  dark:text-gray-100

  border-gray-200
  dark:border-gray-800
">
```

### Step 5: Animation Patterns

**Basic Transitions:**
```tsx
// Hover effects
<button className="
  transition-colors
  duration-200
  hover:bg-primary/90
">

// Transform
<div className="
  transition-transform
  duration-300
  hover:scale-105
">
```

**Entry Animations:**
```tsx
// Fade in
<div className="animate-in fade-in duration-500">

// Slide in
<div className="animate-in slide-in-from-bottom-4 duration-300">

// Combined
<div className="animate-in fade-in slide-in-from-left-4 duration-500">
```

**Custom Keyframes:**
```ts
// tailwind.config.ts
export default {
  theme: {
    extend: {
      keyframes: {
        "accordion-down": {
          from: { height: "0" },
          to: { height: "var(--radix-accordion-content-height)" },
        },
        "accordion-up": {
          from: { height: "var(--radix-accordion-content-height)" },
          to: { height: "0" },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
};
```

### Step 6: Common Patterns

**Flex Layouts:**
```tsx
// Center content
<div className="flex items-center justify-center">

// Space between
<div className="flex items-center justify-between">

// Stack with gap
<div className="flex flex-col gap-4">
```

**Grid Layouts:**
```tsx
// Responsive grid
<div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">

// Auto-fill
<div className="grid grid-cols-[repeat(auto-fill,minmax(250px,1fr))] gap-4">
```

**Typography:**
```tsx
// Prose for markdown content
<article className="prose prose-lg dark:prose-invert">
  {content}
</article>

// Truncate text
<p className="truncate">Long text...</p>

// Line clamp
<p className="line-clamp-3">Multi-line text...</p>
```

**Focus Styles:**
```tsx
<button className="
  focus:outline-none
  focus-visible:ring-2
  focus-visible:ring-ring
  focus-visible:ring-offset-2
">
```

## cn() Utility

```ts
// lib/utils.ts
import { clsx, type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

// Usage
cn(
  "base-class",
  condition && "conditional-class",
  { "object-class": isActive },
  className // from props
);
```

## Output Checklist

- [ ] Design tokens used
- [ ] Responsive design implemented
- [ ] Dark mode supported
- [ ] Animations are smooth
- [ ] Focus states visible
- [ ] cn() used for class merging
- [ ] No hardcoded colors

---

**This skill creates maintainable, responsive, and accessible styling with Tailwind CSS.**
