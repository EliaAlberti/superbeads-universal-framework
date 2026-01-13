# Web Pack for SuperBeads Framework

Web development pack providing specialized agents and skills for React/Next.js application development.

## Overview

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 4 | Web-specialized agents extending core patterns |
| Skills | 9 | Complete React/Next.js development skill library |
| Templates | 1 | verify.sh for web projects |

## Agents

| Agent | Role | Model | Purpose |
|-------|------|-------|---------|
| `web-strategist` | Strategist | Sonnet | Architecture, task planning, component design |
| `web-executor` | Executor | Sonnet | React/TypeScript implementation |
| `web-specialist` | Specialist | Sonnet | Advanced React, performance, animations |
| `web-critic` | Critic | Haiku | Code review, verification |

## Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| `web-create-component` | UI | React component creation |
| `web-create-page` | Routing | Next.js pages and layouts |
| `web-create-hook` | Logic | Custom React hooks |
| `web-setup-project` | Architecture | Project structure, tooling |
| `web-testing` | Quality | Vitest + Testing Library |
| `web-state-management` | State | React Query + Zustand |
| `web-api-routes` | Backend | Next.js Route Handlers |
| `web-forms` | UI | React Hook Form + Zod |
| `web-styling` | UI | Tailwind CSS patterns |

## Installation

```bash
# Using SuperBeads CLI
superbeads pack install web

# Or manually
cp -r packs/web/agents/* ~/.superbeads/agents/
cp -r packs/web/skills/* ~/.superbeads/skills/web/
```

## Project Setup

After installing the pack, set up your web project:

```bash
# Initialize SuperBeads in your Next.js project
cd your-nextjs-project
superbeads init

# Install Web pack
superbeads pack install web

# Configure verify.sh
chmod +x scripts/verify.sh
```

## Configuration

The pack expects a Next.js App Router project with:

```json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "lint": "next lint",
    "typecheck": "tsc --noEmit",
    "test": "vitest"
  }
}
```

## Workflow

### 1. Planning (web-strategist)

```
User: "Add user dashboard with stats"

web-strategist:
- Analyzes requirements
- Designs component architecture
- Creates 10-15 min tasks with context
- Sets up sprint tracking
```

### 2. Implementation (web-executor)

```
web-executor:
- Reads task specification
- Loads ONE relevant skill
- Implements React/TypeScript code
- Runs verification
- Commits with task reference
```

### 3. Complex Patterns (web-specialist)

```
web-specialist:
- Handles advanced React patterns
- Performance optimization
- Complex animations
- Accessibility compliance
```

### 4. Review (web-critic)

```
web-critic:
- Runs verify.sh
- Checks against criteria
- Reviews TypeScript and React patterns
- Reports issues with fixes
```

## Patterns

The Web pack enforces these patterns:

- **Next.js App Router**: Server/Client components, layouts, loading states
- **TypeScript**: Strict mode, proper interfaces
- **Tailwind CSS**: Design tokens, dark mode
- **React Query**: Server state management
- **Zustand**: Client state management
- **React Hook Form + Zod**: Form handling and validation
- **Vitest + Testing Library**: Component and hook testing

## Tooling

| Tool | Purpose | Required |
|------|---------|----------|
| Next.js | Framework | Yes |
| TypeScript | Type safety | Yes |
| Tailwind CSS | Styling | Recommended |
| Vitest | Testing | Yes |
| ESLint | Linting | Yes |

## File Structure

```
packs/web/
├── pack.json              # Pack manifest
├── README.md              # This file
├── agents/
│   ├── web-strategist.md
│   ├── web-executor.md
│   ├── web-specialist.md
│   └── web-critic.md
├── skills/
│   ├── web-create-component-SKILL.md
│   ├── web-create-page-SKILL.md
│   ├── web-create-hook-SKILL.md
│   ├── web-setup-project-SKILL.md
│   ├── web-testing-SKILL.md
│   ├── web-state-management-SKILL.md
│   ├── web-api-routes-SKILL.md
│   ├── web-forms-SKILL.md
│   └── web-styling-SKILL.md
└── templates/
    └── verify.sh          # Verification script template
```

## Related Documentation

- `core/docs/UNIVERSAL-AGENTS.md` — Base agent patterns
- `core/docs/TASK-DISCIPLINE.md` — Task sizing rules
- `core/docs/VERIFICATION-FRAMEWORK.md` — Verification patterns

## Version

- Pack Version: 1.0.0
- Requires Core: >=1.0.0
- Node.js: >=18
- Next.js: >=14
