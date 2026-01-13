# SuperBeads Framework Guide

A comprehensive guide to the Universal SuperBeads Framework - a meta-framework for Claude Code that works across any domain.

---

## Table of Contents

1. [What Is SuperBeads?](#what-is-superbeads)
2. [Core Concepts](#core-concepts)
3. [Installation](#installation)
4. [Using the Framework](#using-the-framework)
5. [Available Packs](#available-packs)
6. [Fresh vs Mid-Project Installation](#fresh-vs-mid-project-installation)
7. [Session Commands](#session-commands)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## What Is SuperBeads?

SuperBeads is a **meta-framework** that enhances how Claude Code works on your projects. It provides:

- **Structure** - Consistent patterns for planning, executing, and reviewing work
- **Context Persistence** - Your project knowledge survives across sessions
- **Domain Expertise** - Specialized agents and skills for different domains
- **Quality Assurance** - Built-in verification at every step

### The Core Insight

The framework is built on a key insight: **the patterns that make AI development effective are universal**. Whether you're building iOS apps, Python APIs, or product documentation, the same workflow applies:

```
Plan → Execute → Verify → Review
```

SuperBeads codifies this into reusable components.

### Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    SuperBeads Framework                  │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │                   Core Engine                    │   │
│  │  • 4 Agent Pattern (universal)                   │   │
│  │  • Task Discipline (10-15 min rule)              │   │
│  │  • Session Management (context persistence)      │   │
│  │  • Verification Framework                        │   │
│  └─────────────────────────────────────────────────┘   │
│                          │                              │
│        ┌─────────────────┼─────────────────┐           │
│        ▼                 ▼                 ▼           │
│  ┌──────────┐     ┌──────────┐     ┌──────────┐       │
│  │ iOS Pack │     │Python Pack│    │ Web Pack │       │
│  └──────────┘     └──────────┘     └──────────┘       │
│  ┌──────────┐     ┌──────────┐                        │
│  │Design Pack│    │ PM Pack  │                        │
│  └──────────┘     └──────────┘                        │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Core works standalone.** Packs are optional accelerators.

---

## Core Concepts

### The Four Agents

Every pack follows the same four-agent pattern:

| Agent | Role | Model | Responsibility |
|-------|------|-------|----------------|
| **Strategist** | Plan | Sonnet | Break work into tasks, design architecture |
| **Executor** | Build | Sonnet | Implement tasks using skills |
| **Specialist** | Expertise | Sonnet | Handle complex/advanced patterns |
| **Critic** | Review | Haiku | Verify work, catch issues |

This separation ensures:
- Clear responsibilities (no role confusion)
- Cost optimization (Haiku for reviews = 5x savings)
- Quality gates at each step

### Task Discipline

The "10-15 minute rule" is fundamental:

| Principle | Description |
|-----------|-------------|
| **Time-boxed** | Every task should take 10-15 minutes |
| **Single focus** | No "and" in task titles - split if needed |
| **Observable** | Clear completion signal (file exists, test passes) |
| **Atomic** | One commit per task |
| **Criteria-based** | 3-5 acceptance criteria per task |

**Why this matters:** AI works best with focused, well-defined units of work. Vague or large tasks lead to drift and errors.

### CLAUDE.md - Project Memory

Every project has a `CLAUDE.md` file that serves as:

- **Context persistence** - Project knowledge survives session restarts
- **Quick orientation** - New sessions start fast with `/resume`
- **Decision log** - Key choices documented for future reference
- **Navigation** - Links to important files and docs

### Verification Framework

Work isn't done until it's verified. SuperBeads supports multiple verification types:

| Type | Example | When Used |
|------|---------|-----------|
| **Output exists** | File created at path | Always |
| **Build passes** | `npm build` succeeds | Code projects |
| **Tests pass** | `pytest` green | Code projects |
| **Checklist done** | All criteria checked | Documentation |
| **Human confirms** | Manual review | Critical work |

Each pack includes a `verify.sh` template customized for its domain.

---

## Installation

### Prerequisites

- Claude Code CLI installed and working
- Terminal access
- A project directory (new or existing)

### Option 1: Light Installation (Recommended Start)

The simplest approach - just add a CLAUDE.md:

```bash
cd your-project

# Create CLAUDE.md manually or copy template
cat > CLAUDE.md << 'EOF'
# CLAUDE.md - Project Name

## Context
Brief description of what this project is.

## Current State
What exists, what's working.

## Next Steps
What needs to be done.

---
*Updated: [date]*
EOF
```

Now use session commands:
- Start sessions with `/resume`
- End sessions with `/preserve` or `/wrapup`

**This alone provides ~60% of the framework's value.**

### Option 2: Core Installation

For the full core engine:

```bash
# Navigate to your project
cd your-project

# Option A: Use the CLI (if installed globally)
superbeads init

# Option B: Manual setup
mkdir -p .superbeads/sprint
touch .superbeads/settings.json

# Copy CLAUDE.md template if needed
cp /path/to/superbeads/core/templates/CLAUDE.md.template ./CLAUDE.md

# Copy verify.sh template
mkdir -p scripts
cp /path/to/superbeads/core/templates/verify.sh.template ./scripts/verify.sh
chmod +x scripts/verify.sh
```

**What this creates:**

```
your-project/
├── .superbeads/
│   ├── settings.json      # Project settings
│   └── sprint/
│       ├── current.json   # Active sprint state
│       └── progress.md    # Sprint progress log
├── CLAUDE.md              # Project context
└── scripts/
    └── verify.sh          # Verification script
```

### Option 3: Core + Pack Installation

For domain-specific features:

```bash
cd your-project

# Initialize core
superbeads init

# Install a pack
superbeads pack install python   # or: ios, web, design, pm

# List available packs
superbeads pack list
```

**What pack installation adds:**

```
your-project/
├── .claude/
│   └── agents/
│       ├── python-strategist.md
│       ├── python-executor.md
│       ├── python-specialist.md
│       └── python-critic.md
├── .superbeads/
│   └── skills/
│       └── python/
│           ├── python-create-api-SKILL.md
│           └── ... (9 skills total)
└── scripts/
    └── verify.sh          # Python-specific verification
```

### Manual Pack Installation

If the CLI isn't available:

```bash
# Copy agents
mkdir -p .claude/agents
cp /path/to/superbeads/packs/python/agents/* .claude/agents/

# Copy skills
mkdir -p .superbeads/skills/python
cp /path/to/superbeads/packs/python/skills/* .superbeads/skills/python/

# Copy verify.sh
cp /path/to/superbeads/packs/python/templates/verify.sh scripts/verify.sh
chmod +x scripts/verify.sh
```

---

## Using the Framework

### Daily Workflow

**Starting a session:**

```
You: /resume
Claude: [Reads CLAUDE.md, reports current state, ready to work]
```

**During work:**

```
You: [Describe what you want to do]
Claude: [Uses strategist pattern to plan, executor to implement]
```

**Ending a session:**

```
You: /preserve
Claude: [Updates CLAUDE.md with session learnings]
```

Or for quick endings:

```
You: /wrapup
Claude: [Provides summary, optionally updates CLAUDE.md]
```

### Working with Agents

You can explicitly invoke agent patterns:

```
You: As strategist, break down adding user authentication

Claude (as strategist):
- Analyzes requirements
- Creates 10-15 min tasks
- Embeds context in each task
- Defines dependencies
```

```
You: As executor, implement task-001 (user login form)

Claude (as executor):
- Reads task specification
- Loads relevant skill
- Implements the work
- Runs verification
- Commits with task reference
```

### Working with Skills

Skills are detailed procedural guides. Reference them explicitly:

```
You: Use the python-create-api skill to add a users endpoint

Claude:
- Reads the skill file
- Follows the step-by-step process
- Applies patterns from the skill
- Produces complete, production-ready output
```

### Running Verification

```bash
# Run all checks
./scripts/verify.sh

# Quick mode (skip slow checks)
./scripts/verify.sh --quick

# Verbose output
./scripts/verify.sh --verbose
```

### Sprint Tracking

For larger efforts:

```bash
# Start a sprint
superbeads sprint start "Add authentication"

# Check sprint status
superbeads status

# Complete a task
superbeads task complete task-001

# End sprint
superbeads sprint end
```

---

## Available Packs

### Code Packs

#### iOS Pack (`ios`)

For Swift/SwiftUI iOS development.

| Component | Description |
|-----------|-------------|
| **Agents** | iOS-specialized strategist, executor, specialist, critic |
| **Skills** | Views, ViewModels, Models, Networking, CoreData, etc. |
| **Verify** | Xcodebuild + test execution |

```bash
superbeads pack install ios
```

#### Python Pack (`python`)

For Python application development.

| Component | Description |
|-----------|-------------|
| **Agents** | Python-specialized strategist, executor, specialist, critic |
| **Skills** | Modules, Classes, APIs, Testing, Data Models, CLI, Async |
| **Verify** | ruff + mypy + pytest |

```bash
superbeads pack install python
```

#### Web Pack (`web`)

For React/Next.js web development.

| Component | Description |
|-----------|-------------|
| **Agents** | Web-specialized strategist, executor, specialist, critic |
| **Skills** | Components, Pages, Hooks, Forms, State, API Routes |
| **Verify** | ESLint + TypeScript + Jest + Build |

```bash
superbeads pack install web
```

### Product Packs

#### Design Pack (`design`)

For product design workflows.

| Component | Description |
|-----------|-------------|
| **Agents** | Design-specialized strategist, executor, specialist, critic |
| **Skills** | Components, Screens, Design System, Prototypes, Icons, AI Assets, Handoff |
| **Verify** | Artifact existence, token consistency, accessibility notes |
| **Tools** | Figma, Claude, Midjourney, DALL-E, ChatGPT, Gemini |

```bash
superbeads pack install design
```

#### PM Pack (`pm`)

For product management workflows.

| Component | Description |
|-----------|-------------|
| **Agents** | PM-specialized strategist, executor, specialist, critic |
| **Skills** | User Stories, PRDs, Sprint Planning, Roadmaps, Experiments, Metrics |
| **Verify** | INVEST criteria, acceptance criteria quality, document completeness |
| **Patterns** | Agile + Lean combined (sprints + experiments) |

```bash
superbeads pack install pm
```

### Choosing a Pack

| Project Type | Recommended |
|--------------|-------------|
| iOS/Swift app | `ios` pack |
| Python backend/CLI | `python` pack |
| React/Next.js frontend | `web` pack |
| Design system work | `design` pack |
| Product planning | `pm` pack |
| Documentation | Core only |
| Research/exploration | Core only or just CLAUDE.md |
| Mixed/general | Core only, add packs as needed |

---

## Fresh vs Mid-Project Installation

### Fresh Project (Starting New)

The ideal scenario - full framework from day one.

```bash
# Create project
mkdir my-new-project
cd my-new-project

# Initialize with SuperBeads
superbeads init

# Install appropriate pack
superbeads pack install python

# Create initial structure
# ... start building
```

**Benefits:**
- Full task discipline from start
- Clean sprint tracking
- All verification in place
- Consistent patterns throughout

### Mid-Project Installation

**SuperBeads is designed for this.** You can adopt at any stage.

```bash
cd existing-project

# Install core
superbeads init

# Your existing files are untouched
# SuperBeads adds its own structure alongside
```

**Key points:**

| Concern | Reality |
|---------|---------|
| Will it break my code? | No - SuperBeads only adds files |
| Will it conflict with existing tools? | No - it's additive, not replacing |
| Do I need to restructure? | No - it overlays your existing structure |
| Can I adopt gradually? | Yes - start with CLAUDE.md, add more later |

### Incremental Adoption Path

```
Week 1: Just CLAUDE.md + /resume, /preserve
        ↓
Week 2: Add .superbeads/ for sprint tracking
        ↓
Week 3: Install pack for domain-specific agents
        ↓
Week 4: Use full task discipline and skills
```

You don't have to adopt everything at once.

### Without Git

SuperBeads works without version control:

| Feature | Without Git | Notes |
|---------|-------------|-------|
| CLAUDE.md | ✅ Works | File-based, no VCS needed |
| Session commands | ✅ Works | Pure conversation features |
| Task discipline | ✅ Works | Planning pattern, not tool |
| Sprint tracking | ✅ Works | JSON files, local storage |
| verify.sh | ✅ Works | Shell script, runs locally |
| Commit-per-task | ⚠️ Skip | Requires git |

The commit discipline is aspirational. Skip it if not using git.

---

## Session Commands

These work globally, regardless of pack:

### /resume

**Purpose:** Start a session by loading context from CLAUDE.md

**What it does:**
1. Finds and reads CLAUDE.md
2. Parses project state, current phase, blockers
3. Reports status in structured format
4. Ready to continue work

**Usage:**
```
You: /resume
Claude: [Status report with context loaded]
```

### /preserve

**Purpose:** End a session by saving learnings to CLAUDE.md

**What it does:**
1. Asks what to preserve (decisions, progress, insights)
2. Reviews current CLAUDE.md structure
3. Updates with session knowledge
4. Confirms changes made

**Usage:**
```
You: /preserve
Claude: [Asks what to save, updates CLAUDE.md]
```

### /wrapup

**Purpose:** Quick session end with summary

**What it does:**
1. Summarizes session accomplishments
2. Notes any blockers or next steps
3. Optionally updates CLAUDE.md

**Usage:**
```
You: /wrapup
Claude: [Quick summary, optional CLAUDE.md update]
```

### /compress

**Purpose:** Preserve context before using /compact

**What it does:**
1. Captures current conversation context
2. Saves to CLAUDE.md for recovery
3. Prepares for context window clearing

**Usage:**
```
You: /compress
Claude: [Saves context, ready for /compact]
```

---

## Best Practices

### CLAUDE.md Hygiene

| Do | Don't |
|----|-------|
| Keep under 150 lines | Let it grow unbounded |
| Use tables for structured data | Write paragraphs of prose |
| Point to files, don't duplicate | Copy file contents in |
| Update after significant changes | Update every session |
| Include "Next Steps" section | Leave it vague |

### Task Sizing

| Right Size | Too Large (Split) |
|------------|-------------------|
| "Add login form component" | "Implement user authentication" |
| "Write User model with validation" | "Build the data layer" |
| "Create password reset email template" | "Add password reset flow" |

**Rule of thumb:** If you can't describe it without "and", split it.

### Verification

| Always Check | Domain-Specific |
|--------------|-----------------|
| Output exists at expected path | Build passes (code) |
| Acceptance criteria met | Tests pass (code) |
| No obvious errors | Linting clean (code) |
| Documentation updated | Design consistency (design) |

### Pack Selection

| Scenario | Recommendation |
|----------|----------------|
| Single-domain project | Install one matching pack |
| Multi-domain project | Install primary pack, reference others |
| Experimental/learning | Core only |
| Documentation-heavy | Core only or PM pack |
| Unsure | Start with Core only, add pack if needed |

---

## Troubleshooting

### "CLAUDE.md not found"

```bash
# Check if file exists
ls -la CLAUDE.md

# Create from template
cp /path/to/core/templates/CLAUDE.md.template ./CLAUDE.md

# Or create minimal version
echo "# CLAUDE.md" > CLAUDE.md
```

### "Pack not found"

```bash
# List available packs
superbeads pack list

# Check packs directory
ls /path/to/superbeads/packs/

# Manual installation
cp -r /path/to/packs/python/agents/* .claude/agents/
```

### "verify.sh fails"

```bash
# Check permissions
chmod +x scripts/verify.sh

# Run with debug
bash -x scripts/verify.sh

# Check configuration at top of script
head -20 scripts/verify.sh
```

### "Session commands not working"

Session commands (/resume, /preserve, etc.) are Claude Code features:
- They work in Claude Code CLI
- They require the skill to be loaded
- Check that skills are properly configured

### "Context lost between sessions"

1. Always end with `/preserve` or `/wrapup`
2. Check CLAUDE.md was updated
3. Start next session with `/resume`
4. If using `/compact`, run `/compress` first

---

## Quick Reference

### Commands

| Command | Purpose |
|---------|---------|
| `superbeads init` | Initialize core in project |
| `superbeads pack install <name>` | Install a pack |
| `superbeads pack list` | List available packs |
| `superbeads status` | Show project status |
| `superbeads verify` | Run verification |
| `superbeads sprint start "<goal>"` | Start a sprint |
| `superbeads sprint end` | End current sprint |

### Session Commands

| Command | When to Use |
|---------|-------------|
| `/resume` | Start of every session |
| `/preserve` | End of session (with learnings) |
| `/wrapup` | Quick session end |
| `/compress` | Before `/compact` |

### Key Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project context and memory |
| `.superbeads/settings.json` | Project settings |
| `.superbeads/sprint/current.json` | Active sprint state |
| `scripts/verify.sh` | Verification script |
| `.claude/agents/*.md` | Agent definitions |

### Pack Summary

| Pack | Domain | Skills | Focus |
|------|--------|--------|-------|
| `ios` | iOS/Swift | 9 | SwiftUI, MVVM, Core Data |
| `python` | Python | 9 | FastAPI, Pydantic, pytest |
| `web` | React/Next.js | 9 | Components, hooks, state |
| `design` | Product Design | 9 | Figma, tokens, accessibility |
| `pm` | Product Management | 9 | Stories, PRDs, experiments |

---

## Getting Help

- **Framework docs:** `core/docs/` directory
- **Pack details:** `packs/<name>/README.md`
- **Agent patterns:** `core/docs/UNIVERSAL-AGENTS.md`
- **Task rules:** `core/docs/TASK-DISCIPLINE.md`

---

*SuperBeads Universal Framework - Making AI development systematic across any domain.*
