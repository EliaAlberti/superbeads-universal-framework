# Web Create Page Skill

## Description

You MUST use this skill before creating any Next.js page or route. This applies to pages, layouts, loading states, error boundaries, and route handlers in the App Router.

---

## Purpose

Generate complete, production-ready Next.js pages that:
- Use App Router conventions correctly
- Handle data fetching properly
- Include loading and error states
- Are SEO-optimized
- Support dynamic routes

## When to Use

- Creating new pages/routes
- Adding layouts
- Implementing loading states
- Creating error boundaries
- Setting up route groups

## Prerequisites

- Route structure planned
- Data requirements understood
- Layout needs identified

## Process

### Step 1: Understand App Router Structure

```
app/
├── layout.tsx          # Root layout
├── page.tsx            # Home page (/)
├── loading.tsx         # Loading UI
├── error.tsx           # Error boundary
├── not-found.tsx       # 404 page
├── dashboard/
│   ├── layout.tsx      # Dashboard layout
│   ├── page.tsx        # /dashboard
│   └── settings/
│       └── page.tsx    # /dashboard/settings
├── blog/
│   ├── page.tsx        # /blog
│   └── [slug]/
│       └── page.tsx    # /blog/:slug
└── (marketing)/        # Route group (no URL segment)
    ├── about/
    │   └── page.tsx    # /about
    └── contact/
        └── page.tsx    # /contact
```

### Step 2: Create Page

**Basic Page:**
```tsx
// app/dashboard/page.tsx
import { Metadata } from "next";

export const metadata: Metadata = {
  title: "Dashboard",
  description: "View your dashboard",
};

export default function DashboardPage() {
  return (
    <main className="container py-8">
      <h1 className="text-3xl font-bold">Dashboard</h1>
      <p className="mt-2 text-muted-foreground">
        Welcome to your dashboard
      </p>
    </main>
  );
}
```

**Page with Data Fetching:**
```tsx
// app/blog/page.tsx
import { Metadata } from "next";
import { PostList } from "@/components/blog/post-list";

export const metadata: Metadata = {
  title: "Blog",
  description: "Read our latest articles",
};

async function getPosts() {
  const res = await fetch("https://api.example.com/posts", {
    next: { revalidate: 60 }, // Revalidate every 60 seconds
  });

  if (!res.ok) {
    throw new Error("Failed to fetch posts");
  }

  return res.json();
}

export default async function BlogPage() {
  const posts = await getPosts();

  return (
    <main className="container py-8">
      <h1 className="text-3xl font-bold">Blog</h1>
      <PostList posts={posts} />
    </main>
  );
}
```

**Dynamic Route:**
```tsx
// app/blog/[slug]/page.tsx
import { Metadata } from "next";
import { notFound } from "next/navigation";

interface Props {
  params: Promise<{ slug: string }>;
}

async function getPost(slug: string) {
  const res = await fetch(`https://api.example.com/posts/${slug}`);

  if (!res.ok) {
    if (res.status === 404) return null;
    throw new Error("Failed to fetch post");
  }

  return res.json();
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const post = await getPost(slug);

  if (!post) {
    return { title: "Post Not Found" };
  }

  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      title: post.title,
      description: post.excerpt,
      images: [post.image],
    },
  };
}

export default async function PostPage({ params }: Props) {
  const { slug } = await params;
  const post = await getPost(slug);

  if (!post) {
    notFound();
  }

  return (
    <article className="container py-8">
      <h1 className="text-4xl font-bold">{post.title}</h1>
      <time className="text-muted-foreground">{post.date}</time>
      <div
        className="prose mt-8"
        dangerouslySetInnerHTML={{ __html: post.content }}
      />
    </article>
  );
}

// Optional: Generate static params for static generation
export async function generateStaticParams() {
  const posts = await fetch("https://api.example.com/posts").then((r) =>
    r.json()
  );

  return posts.map((post: { slug: string }) => ({
    slug: post.slug,
  }));
}
```

### Step 3: Create Layout

```tsx
// app/dashboard/layout.tsx
import { Sidebar } from "@/components/dashboard/sidebar";

interface DashboardLayoutProps {
  children: React.ReactNode;
}

export default function DashboardLayout({ children }: DashboardLayoutProps) {
  return (
    <div className="flex min-h-screen">
      <Sidebar className="w-64 border-r" />
      <main className="flex-1 p-8">{children}</main>
    </div>
  );
}
```

### Step 4: Add Loading State

```tsx
// app/dashboard/loading.tsx
export default function DashboardLoading() {
  return (
    <div className="container py-8">
      <div className="animate-pulse">
        <div className="h-8 w-48 rounded bg-gray-200" />
        <div className="mt-4 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
          {[...Array(4)].map((_, i) => (
            <div key={i} className="h-32 rounded-lg bg-gray-200" />
          ))}
        </div>
      </div>
    </div>
  );
}
```

### Step 5: Add Error Boundary

```tsx
// app/dashboard/error.tsx
"use client";

import { useEffect } from "react";
import { Button } from "@/components/ui/button";

interface ErrorProps {
  error: Error & { digest?: string };
  reset: () => void;
}

export default function DashboardError({ error, reset }: ErrorProps) {
  useEffect(() => {
    // Log error to monitoring service
    console.error(error);
  }, [error]);

  return (
    <div className="container flex flex-col items-center justify-center py-16">
      <h2 className="text-2xl font-bold">Something went wrong!</h2>
      <p className="mt-2 text-muted-foreground">
        {error.message || "An unexpected error occurred"}
      </p>
      <Button onClick={reset} className="mt-4">
        Try again
      </Button>
    </div>
  );
}
```

### Step 6: Add Not Found Page

```tsx
// app/not-found.tsx
import Link from "next/link";
import { Button } from "@/components/ui/button";

export default function NotFound() {
  return (
    <div className="container flex flex-col items-center justify-center py-16">
      <h1 className="text-6xl font-bold">404</h1>
      <h2 className="mt-4 text-2xl">Page Not Found</h2>
      <p className="mt-2 text-muted-foreground">
        The page you're looking for doesn't exist.
      </p>
      <Button asChild className="mt-6">
        <Link href="/">Go Home</Link>
      </Button>
    </div>
  );
}
```

### Step 7: Configure Metadata

```tsx
// app/layout.tsx
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: {
    default: "My App",
    template: "%s | My App",
  },
  description: "My awesome application",
  keywords: ["next.js", "react", "typescript"],
  authors: [{ name: "Your Name" }],
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://example.com",
    siteName: "My App",
    images: [
      {
        url: "/og-image.png",
        width: 1200,
        height: 630,
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    site: "@handle",
  },
  robots: {
    index: true,
    follow: true,
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
```

## Route Patterns

### Route Groups

```
app/
├── (marketing)/      # Group for marketing pages
│   ├── layout.tsx    # Marketing-specific layout
│   └── about/
├── (app)/            # Group for app pages
│   ├── layout.tsx    # App-specific layout
│   └── dashboard/
```

### Parallel Routes

```
app/
├── @modal/
│   └── login/
│       └── page.tsx
├── layout.tsx        # Can render both children and @modal
└── page.tsx
```

### Intercepting Routes

```
app/
├── feed/
│   └── page.tsx
├── photo/
│   └── [id]/
│       └── page.tsx
└── @modal/
    └── (.)photo/     # Intercepts /photo/[id] when navigating from feed
        └── [id]/
            └── page.tsx
```

## Output Checklist

- [ ] Page file created in correct location
- [ ] Metadata configured
- [ ] Loading state added
- [ ] Error boundary added
- [ ] Data fetching implemented
- [ ] TypeScript types complete
- [ ] Tests added

---

**This skill creates production-ready Next.js pages with proper routing, data fetching, and error handling.**
