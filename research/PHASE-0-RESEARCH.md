# Phase 0 Research: Best Practices Analysis

> **Date**: January 2026
> **Purpose**: Inform Universal SuperBeads Framework architecture
> **Sources**: Ref MCP documentation search

---

## 1. CLI Tool Development Patterns

### Commander.js Best Practices

**Source**: [Commander.js](https://github.com/tj/commander.js)

#### Core Patterns

```typescript
// Declarative command definition
program
  .name('superbeads')
  .description('Universal framework for AI collaboration')
  .version('1.0.0');

// Subcommand with options and arguments
program.command('init')
  .description('Initialize a new project')
  .argument('[directory]', 'target directory', '.')
  .option('-p, --pack <name>', 'include domain pack')
  .option('--no-git', 'skip git initialization')
  .action((directory, options) => { /* ... */ });
```

#### Key Features for SuperBeads

| Feature | Use Case |
|---------|----------|
| **Stand-alone executables** | Each pack can have its own CLI extensions |
| **Life cycle hooks** | `preAction`/`postAction` for verification, logging |
| **TypeScript support** | Strong typing with `@commander-js/extra-typings` |
| **Custom processing** | Argument/option transformation |
| **Exit override** | Custom error handling for framework errors |

#### Recommended CLI Structure

```
superbeads <command> [options]

Commands:
  init [dir]          Initialize project with Core
  pack <action>       Manage domain packs (add, remove, list)
  task <action>       Task management (create, list, complete)
  sprint <action>     Sprint tracking (start, status, close)
  verify              Run verification checks
  agent <name>        Invoke specific agent mode
```

---

## 2. Developer Experience (DX) Standards

### GitHub CLI Design Principles

**Source**: [GitHub CLI Primer](https://github.com/cli/cli/blob/trunk/docs/primer/)

#### Reduce Cognitive Load

| Principle | Implementation |
|-----------|----------------|
| **Confirm steps** | Confirm before destructive operations |
| **Headers for context** | Always show what's happening |
| **Consistent language** | Same verbs across commands (`create`, `list`, `delete`) |
| **Parallel behavior** | Similar commands behave similarly |
| **Anticipate next actions** | Suggest what to do next |
| **Anticipate mistakes** | Helpful error messages with suggestions |

#### Customizability Layers

```
┌─────────────────────────────────────┐
│           Environment               │
│  (Shell, Terminal, OS settings)     │
├─────────────────────────────────────┤
│         User Preferences            │
│  (~/.superbeads/config.json)        │
├─────────────────────────────────────┤
│        Project Settings             │
│  (.superbeads/settings.json)        │
├─────────────────────────────────────┤
│          Pack Settings              │
│  (pack-specific configuration)      │
└─────────────────────────────────────┘
```

#### Error Message Pattern

```
✗ Error: Pack 'ios' not found

  The pack 'ios' is not installed.

  To install it:
    superbeads pack add ios

  To see available packs:
    superbeads pack list --available
```

---

## 3. AI Agent Orchestration Patterns

### Claude Agent SDK Architecture

**Source**: [Claude Agent SDK](https://docs.claude.com/en/docs/claude-code/sdk/)

#### Core Concepts

| Concept | Description | SuperBeads Equivalent |
|---------|-------------|----------------------|
| **Subagents** | Markdown files in `.claude/agents/` | Agent definitions in `core/agents/` |
| **Hooks** | Tool event triggers in settings.json | Verification hooks |
| **Slash Commands** | Markdown in `.claude/commands/` | Skills in `packs/[name]/skills/` |
| **Memory (CLAUDE.md)** | Persistent instructions | Session state + CLAUDE.md |
| **Context Management** | Automatic compaction | Sprint/task context |
| **Tool Permissions** | Fine-grained control | Agent tool restrictions |

#### Agent Definition Pattern

```markdown
---
name: research-strategist
description: Plans research approach and breaks down investigation tasks
tools:
  - Read
  - Grep
  - Glob
  - WebSearch
model: sonnet
---

# research-strategist

You are a research planning specialist...

## Responsibilities
- Define research questions
- Break down into searchable queries
- Create task breakdown

## What You Do NOT Do
- Execute searches (that's research-executor)
- Write final reports (that's research-synthesizer)
```

#### Multi-Agent Orchestration

```
┌─────────────────────────────────────────────────────┐
│                   Orchestrator                       │
│        (Main Claude Code session)                    │
└──────────────────────┬──────────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         │             │             │
         ▼             ▼             ▼
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ Strategist  │ │  Executor   │ │   Critic    │
│   Agent     │ │   Agent     │ │   Agent     │
│             │ │             │ │             │
│ Plans work  │ │ Does work   │ │ Reviews     │
│ Breaks down │ │ Implements  │ │ Quality     │
└─────────────┘ └─────────────┘ └─────────────┘
```

---

## 4. Plugin/Pack Architecture

### Monorepo Workspace Pattern

**Sources**: pnpm workspaces, npm workspaces

#### Directory Structure

```
superbeads-universal-framework/
├── package.json              # Root package (workspaces config)
├── pnpm-workspace.yaml       # Workspace definitions
├── packages/
│   ├── core/                 # @superbeads/core
│   │   ├── package.json
│   │   ├── src/
│   │   └── dist/
│   └── cli/                  # @superbeads/cli
│       ├── package.json
│       ├── src/
│       └── dist/
└── packs/
    ├── ios/                  # @superbeads/pack-ios
    │   ├── package.json
    │   ├── agents/
    │   ├── skills/
    │   └── templates/
    ├── python/               # @superbeads/pack-python
    └── web/                  # @superbeads/pack-web
```

#### Pack Manifest Pattern

```json
{
  "name": "@superbeads/pack-ios",
  "version": "1.0.0",
  "superbeads": {
    "type": "pack",
    "domain": "ios",
    "agents": ["ios-planner", "ios-implementer", "ios-reviewer", "ios-ui-specialist"],
    "skills": 9,
    "verification": "./templates/verify.sh",
    "requires": {
      "core": "^1.0.0"
    }
  }
}
```

#### Pack Discovery

```typescript
// Core discovers installed packs
interface PackManifest {
  name: string;
  domain: string;
  agents: string[];
  skills: string[];
  verification: string;
}

async function discoverPacks(): Promise<PackManifest[]> {
  // 1. Check node_modules for @superbeads/pack-*
  // 2. Check local packs/ directory
  // 3. Validate manifest structure
  // 4. Return available packs
}
```

---

## 5. Key Architectural Decisions

### Decision 1: File-Based Configuration

**Rationale**: Follows Claude Code patterns, version-controllable, human-readable

```
project/
├── .superbeads/
│   ├── settings.json       # Project configuration
│   ├── sprint/             # Sprint tracking state
│   └── agents/             # Project-specific agents
├── CLAUDE.md               # Memory/instructions
└── verify.sh               # Project verification
```

### Decision 2: Markdown-Based Agents & Skills

**Rationale**: Human-readable, AI-parseable, version-controllable

```markdown
---
name: agent-name
description: What this agent does
tools: [Tool1, Tool2]
model: sonnet | haiku | opus
---

# Agent content in markdown
```

### Decision 3: Shell-Based Verification

**Rationale**: Universal, composable, can wrap any tool

```bash
#!/bin/bash
# verify.sh - Universal verification wrapper

# Core checks (always run)
check_outputs_exist
check_quality_criteria

# Pack-specific checks (if pack installed)
if [ -f ".superbeads/packs/ios/verify.sh" ]; then
  source ".superbeads/packs/ios/verify.sh"
fi
```

### Decision 4: JSON Schema for Task Definition

**Rationale**: Structured, validatable, tooling-friendly

```json
{
  "$schema": "https://superbeads.dev/schemas/task.json",
  "id": "task-001",
  "title": "Clear, actionable title",
  "type": "feature",
  "time_estimate": "12min",
  "context": {
    "inputs": [],
    "outputs": [],
    "acceptance_criteria": [],
    "completion_signal": "Observable verification"
  }
}
```

---

## 6. Implementation Recommendations

### For Core Engine

1. **Start with file-based primitives** — No database, just files
2. **Use TypeScript** — Strong typing, good tooling
3. **Commander.js for CLI** — Battle-tested, extensible
4. **JSON Schema validation** — For tasks, settings, manifests
5. **Shell scripts for verification** — Universal, composable

### For Pack System

1. **npm workspaces** — Simple, well-understood
2. **Standardized manifest** — `superbeads` key in package.json
3. **Convention over configuration** — Expected directories: `agents/`, `skills/`, `templates/`
4. **Lazy loading** — Only load pack assets when needed

### For Agent System

1. **Markdown frontmatter** — Metadata + content in one file
2. **Tool restrictions by default** — Explicit allowlist
3. **Model selection per agent** — Cost optimization (haiku for review, sonnet for implementation)
4. **Clear responsibility boundaries** — Agents don't overlap

---

## 7. References

- [Commander.js Documentation](https://github.com/tj/commander.js)
- [GitHub CLI Design Primer](https://github.com/cli/cli/blob/trunk/docs/primer/)
- [Claude Agent SDK Overview](https://docs.claude.com/en/docs/claude-code/sdk/)
- [AWS Agent Squad](https://github.com/awslabs/agent-squad)
- [pnpm Workspaces](https://pnpm.io/workspaces)

---

*Research compiled for Universal SuperBeads Framework Phase 1*
