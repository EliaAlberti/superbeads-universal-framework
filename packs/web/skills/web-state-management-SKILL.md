# Web State Management Skill

## Description

You MUST use this skill before implementing state management patterns. This applies to React Query for server state, Zustand for client state, and React Context for shared state.

---

## Purpose

Implement production-ready state management that:
- Separates server and client state
- Handles loading and error states
- Supports optimistic updates
- Is performant and scalable

## When to Use

- Managing server data (API responses)
- Managing client UI state
- Sharing state across components
- Implementing caching strategies

## Prerequisites

- State requirements clear
- Libraries installed (React Query, Zustand)
- Understanding of state types

## Process

### Step 1: Identify State Type

| Type | Tool | Use For |
|------|------|---------|
| Server State | React Query | API data, cached responses |
| Client State | Zustand | UI state, user preferences |
| Component State | useState | Form inputs, toggles |
| Shared Props | Context | Theme, auth, layout |

### Step 2: Set Up React Query

**Provider Setup:**
```tsx
// app/providers.tsx
"use client";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";
import { useState } from "react";

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 60 * 1000, // 1 minute
            refetchOnWindowFocus: false,
          },
        },
      })
  );

  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

**Basic Query:**
```tsx
// hooks/use-users.ts
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";

interface User {
  id: string;
  name: string;
  email: string;
}

// API functions
async function fetchUsers(): Promise<User[]> {
  const res = await fetch("/api/users");
  if (!res.ok) throw new Error("Failed to fetch users");
  return res.json();
}

async function createUser(data: Omit<User, "id">): Promise<User> {
  const res = await fetch("/api/users", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });
  if (!res.ok) throw new Error("Failed to create user");
  return res.json();
}

// Hooks
export function useUsers() {
  return useQuery({
    queryKey: ["users"],
    queryFn: fetchUsers,
  });
}

export function useUser(userId: string) {
  return useQuery({
    queryKey: ["users", userId],
    queryFn: () => fetchUser(userId),
    enabled: !!userId,
  });
}

export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: createUser,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["users"] });
    },
  });
}
```

**Optimistic Updates:**
```tsx
export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: updateUser,
    onMutate: async (newUser) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ["users", newUser.id] });

      // Snapshot previous value
      const previousUser = queryClient.getQueryData(["users", newUser.id]);

      // Optimistically update
      queryClient.setQueryData(["users", newUser.id], newUser);

      // Return context with snapshot
      return { previousUser };
    },
    onError: (err, newUser, context) => {
      // Rollback on error
      queryClient.setQueryData(
        ["users", newUser.id],
        context?.previousUser
      );
    },
    onSettled: (data, error, variables) => {
      // Refetch after error or success
      queryClient.invalidateQueries({ queryKey: ["users", variables.id] });
    },
  });
}
```

### Step 3: Set Up Zustand Store

**Basic Store:**
```tsx
// stores/ui-store.ts
import { create } from "zustand";

interface UIState {
  sidebarOpen: boolean;
  theme: "light" | "dark" | "system";
  toggleSidebar: () => void;
  setTheme: (theme: "light" | "dark" | "system") => void;
}

export const useUIStore = create<UIState>((set) => ({
  sidebarOpen: true,
  theme: "system",
  toggleSidebar: () => set((state) => ({ sidebarOpen: !state.sidebarOpen })),
  setTheme: (theme) => set({ theme }),
}));
```

**Store with Persistence:**
```tsx
// stores/preferences-store.ts
import { create } from "zustand";
import { persist } from "zustand/middleware";

interface PreferencesState {
  language: string;
  notifications: boolean;
  setLanguage: (language: string) => void;
  setNotifications: (enabled: boolean) => void;
}

export const usePreferencesStore = create<PreferencesState>()(
  persist(
    (set) => ({
      language: "en",
      notifications: true,
      setLanguage: (language) => set({ language }),
      setNotifications: (notifications) => set({ notifications }),
    }),
    {
      name: "preferences-storage",
    }
  )
);
```

**Store with Slices:**
```tsx
// stores/app-store.ts
import { create } from "zustand";
import { immer } from "zustand/middleware/immer";

interface CartItem {
  id: string;
  name: string;
  price: number;
  quantity: number;
}

interface CartSlice {
  items: CartItem[];
  addItem: (item: Omit<CartItem, "quantity">) => void;
  removeItem: (id: string) => void;
  updateQuantity: (id: string, quantity: number) => void;
  clearCart: () => void;
}

interface AuthSlice {
  user: { id: string; name: string } | null;
  login: (user: { id: string; name: string }) => void;
  logout: () => void;
}

type AppState = CartSlice & AuthSlice;

export const useAppStore = create<AppState>()(
  immer((set) => ({
    // Cart slice
    items: [],
    addItem: (item) =>
      set((state) => {
        const existing = state.items.find((i) => i.id === item.id);
        if (existing) {
          existing.quantity += 1;
        } else {
          state.items.push({ ...item, quantity: 1 });
        }
      }),
    removeItem: (id) =>
      set((state) => {
        state.items = state.items.filter((i) => i.id !== id);
      }),
    updateQuantity: (id, quantity) =>
      set((state) => {
        const item = state.items.find((i) => i.id === id);
        if (item) item.quantity = quantity;
      }),
    clearCart: () => set({ items: [] }),

    // Auth slice
    user: null,
    login: (user) => set({ user }),
    logout: () => set({ user: null }),
  }))
);

// Selectors for performance
export const useCartItems = () => useAppStore((state) => state.items);
export const useCartTotal = () =>
  useAppStore((state) =>
    state.items.reduce((sum, item) => sum + item.price * item.quantity, 0)
  );
export const useUser = () => useAppStore((state) => state.user);
```

### Step 4: Use Context for Theme/Auth

```tsx
// contexts/auth-context.tsx
"use client";

import { createContext, useContext, useState, useCallback } from "react";

interface User {
  id: string;
  name: string;
  email: string;
}

interface AuthContextValue {
  user: User | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const login = useCallback(async (email: string, password: string) => {
    setIsLoading(true);
    try {
      const res = await fetch("/api/auth/login", {
        method: "POST",
        body: JSON.stringify({ email, password }),
      });
      const user = await res.json();
      setUser(user);
    } finally {
      setIsLoading(false);
    }
  }, []);

  const logout = useCallback(async () => {
    await fetch("/api/auth/logout", { method: "POST" });
    setUser(null);
  }, []);

  return (
    <AuthContext.Provider value={{ user, isLoading, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return context;
}
```

### Step 5: Component Usage

```tsx
// components/user-list.tsx
"use client";

import { useUsers, useCreateUser } from "@/hooks/use-users";
import { useUIStore } from "@/stores/ui-store";

export function UserList() {
  const { data: users, isLoading, error } = useUsers();
  const createUser = useCreateUser();
  const sidebarOpen = useUIStore((state) => state.sidebarOpen);

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div className={sidebarOpen ? "ml-64" : "ml-0"}>
      <ul>
        {users?.map((user) => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
      <button
        onClick={() => createUser.mutate({ name: "New User", email: "new@example.com" })}
        disabled={createUser.isPending}
      >
        {createUser.isPending ? "Adding..." : "Add User"}
      </button>
    </div>
  );
}
```

## State Management Guidelines

| Question | Answer |
|----------|--------|
| Comes from API? | React Query |
| UI-only state? | Zustand or useState |
| Needs persistence? | Zustand with persist |
| Shared across many components? | Zustand or Context |
| Form state? | React Hook Form |

## Output Checklist

- [ ] State type identified
- [ ] Appropriate tool chosen
- [ ] Provider set up
- [ ] Hooks/stores created
- [ ] Selectors for performance
- [ ] Loading/error handling
- [ ] Tests added

---

**This skill implements production-ready state management with proper separation of concerns.**
