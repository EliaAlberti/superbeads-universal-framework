# Web API Routes Skill

## Description

You MUST use this skill before creating any Next.js API routes or Route Handlers. This applies to REST endpoints, webhooks, and server-side data handling.

---

## Purpose

Create complete, production-ready API routes that:
- Follow REST conventions
- Include proper validation
- Handle errors correctly
- Are type-safe
- Support proper HTTP methods

## When to Use

- Creating API endpoints
- Building webhook handlers
- Server-side data mutations
- Authentication endpoints

## Prerequisites

- Endpoint requirements clear
- Data validation needs defined
- Authentication requirements known

## Process

### Step 1: Create Route Handler

```
app/
└── api/
    └── users/
        ├── route.ts          # /api/users (GET, POST)
        └── [id]/
            └── route.ts      # /api/users/:id (GET, PATCH, DELETE)
```

**Basic Route Handler:**
```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from "next/server";

export async function GET(request: NextRequest) {
  try {
    const users = await db.user.findMany();

    return NextResponse.json(users);
  } catch (error) {
    console.error("Failed to fetch users:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Validate body...
    const user = await db.user.create({ data: body });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    console.error("Failed to create user:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
```

### Step 2: Add Validation with Zod

```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

const createUserSchema = z.object({
  name: z.string().min(1, "Name is required").max(100),
  email: z.string().email("Invalid email format"),
  role: z.enum(["user", "admin"]).default("user"),
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Validate
    const result = createUserSchema.safeParse(body);
    if (!result.success) {
      return NextResponse.json(
        {
          error: "Validation failed",
          details: result.error.flatten().fieldErrors,
        },
        { status: 400 }
      );
    }

    const user = await db.user.create({ data: result.data });

    return NextResponse.json(user, { status: 201 });
  } catch (error) {
    if (error instanceof Error && error.message.includes("Unique constraint")) {
      return NextResponse.json(
        { error: "Email already exists" },
        { status: 409 }
      );
    }

    console.error("Failed to create user:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
```

### Step 3: Dynamic Routes

```tsx
// app/api/users/[id]/route.ts
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

interface RouteParams {
  params: Promise<{ id: string }>;
}

const updateUserSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  email: z.string().email().optional(),
});

export async function GET(request: NextRequest, { params }: RouteParams) {
  try {
    const { id } = await params;

    const user = await db.user.findUnique({ where: { id } });

    if (!user) {
      return NextResponse.json(
        { error: "User not found" },
        { status: 404 }
      );
    }

    return NextResponse.json(user);
  } catch (error) {
    console.error("Failed to fetch user:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function PATCH(request: NextRequest, { params }: RouteParams) {
  try {
    const { id } = await params;
    const body = await request.json();

    const result = updateUserSchema.safeParse(body);
    if (!result.success) {
      return NextResponse.json(
        { error: "Validation failed", details: result.error.flatten() },
        { status: 400 }
      );
    }

    const user = await db.user.update({
      where: { id },
      data: result.data,
    });

    return NextResponse.json(user);
  } catch (error) {
    if (error instanceof Error && error.message.includes("Record not found")) {
      return NextResponse.json(
        { error: "User not found" },
        { status: 404 }
      );
    }

    console.error("Failed to update user:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}

export async function DELETE(request: NextRequest, { params }: RouteParams) {
  try {
    const { id } = await params;

    await db.user.delete({ where: { id } });

    return new NextResponse(null, { status: 204 });
  } catch (error) {
    if (error instanceof Error && error.message.includes("Record not found")) {
      return NextResponse.json(
        { error: "User not found" },
        { status: 404 }
      );
    }

    console.error("Failed to delete user:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
```

### Step 4: Query Parameters

```tsx
// app/api/users/route.ts
export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;

    // Pagination
    const page = parseInt(searchParams.get("page") || "1");
    const limit = parseInt(searchParams.get("limit") || "20");
    const skip = (page - 1) * limit;

    // Filtering
    const role = searchParams.get("role");
    const search = searchParams.get("search");

    const where: any = {};
    if (role) where.role = role;
    if (search) {
      where.OR = [
        { name: { contains: search, mode: "insensitive" } },
        { email: { contains: search, mode: "insensitive" } },
      ];
    }

    // Query
    const [users, total] = await Promise.all([
      db.user.findMany({ where, skip, take: limit }),
      db.user.count({ where }),
    ]);

    return NextResponse.json({
      data: users,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error("Failed to fetch users:", error);
    return NextResponse.json(
      { error: "Internal server error" },
      { status: 500 }
    );
  }
}
```

### Step 5: Authentication Middleware

```tsx
// lib/auth.ts
import { NextRequest, NextResponse } from "next/server";
import { getToken } from "next-auth/jwt";

export async function withAuth(
  request: NextRequest,
  handler: (request: NextRequest, user: User) => Promise<NextResponse>
) {
  const token = await getToken({ req: request });

  if (!token) {
    return NextResponse.json(
      { error: "Unauthorized" },
      { status: 401 }
    );
  }

  return handler(request, token.user as User);
}

// Usage in route
// app/api/protected/route.ts
import { withAuth } from "@/lib/auth";

export async function GET(request: NextRequest) {
  return withAuth(request, async (req, user) => {
    const data = await db.getData({ userId: user.id });
    return NextResponse.json(data);
  });
}
```

### Step 6: Error Handler Utility

```tsx
// lib/api-utils.ts
import { NextResponse } from "next/server";
import { ZodError } from "zod";

export class ApiError extends Error {
  constructor(
    public statusCode: number,
    message: string
  ) {
    super(message);
  }
}

export function handleApiError(error: unknown) {
  console.error("API Error:", error);

  if (error instanceof ApiError) {
    return NextResponse.json(
      { error: error.message },
      { status: error.statusCode }
    );
  }

  if (error instanceof ZodError) {
    return NextResponse.json(
      {
        error: "Validation failed",
        details: error.flatten().fieldErrors,
      },
      { status: 400 }
    );
  }

  return NextResponse.json(
    { error: "Internal server error" },
    { status: 500 }
  );
}

// Usage
export async function GET() {
  try {
    // ... logic
  } catch (error) {
    return handleApiError(error);
  }
}
```

## REST Conventions

| Action | Method | Route | Response |
|--------|--------|-------|----------|
| List | GET | /api/resources | 200 + array |
| Create | POST | /api/resources | 201 + object |
| Read | GET | /api/resources/:id | 200 + object |
| Update | PATCH | /api/resources/:id | 200 + object |
| Delete | DELETE | /api/resources/:id | 204 |

## Output Checklist

- [ ] Route file in correct location
- [ ] Zod validation added
- [ ] Error handling complete
- [ ] Status codes correct
- [ ] TypeScript types complete
- [ ] Authentication if needed
- [ ] Tests added

---

**This skill creates production-ready API routes with proper validation, error handling, and REST conventions.**
