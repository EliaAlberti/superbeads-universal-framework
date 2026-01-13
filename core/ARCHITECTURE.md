# Universal SuperBeads Core Engine Architecture

> **Version**: 1.0
> **Status**: Design Document
> **Date**: January 2026

---

## Design Philosophy

The Core Engine embodies a single principle: **Universal patterns that work for any task**.

Everything in Core must pass the universality test:
- Does this work for code? ✓
- Does this work for research? ✓
- Does this work for design? ✓
- Does this work for writing? ✓
- Does this work for PM? ✓

If any answer is "no", it belongs in a Pack, not Core.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         UNIVERSAL CORE ENGINE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                        DOCUMENTATION LAYER                            │   │
│  │                                                                       │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │   │
│  │  │ UNIVERSAL   │ │ TASK        │ │ VERIFICATION│ │ SESSION     │    │   │
│  │  │ AGENTS      │ │ DISCIPLINE  │ │ FRAMEWORK   │ │ PROTOCOLS   │    │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘    │   │
│  │                                                                       │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │   │
│  │  │ SPRINT      │ │ SUPERVISOR  │ │ BEADS       │ │ USING CORE  │    │   │
│  │  │ TRACKING    │ │ MODEL       │ │ INTEGRATION │ │ ALONE       │    │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘    │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                         TEMPLATE LAYER                                │   │
│  │                                                                       │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │   │
│  │  │ Agent       │ │ Skill       │ │ Task        │ │ Verify      │    │   │
│  │  │ Template    │ │ Template    │ │ Schema      │ │ Template    │    │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘    │   │
│  │                                                                       │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐                     │   │
│  │  │ Sprint      │ │ Settings    │ │ CLAUDE.md   │                     │   │
│  │  │ Template    │ │ Schema      │ │ Template    │                     │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘                     │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│  ┌──────────────────────────────────────────────────────────────────────┐   │
│  │                          SCRIPT LAYER                                 │   │
│  │                                                                       │   │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │   │
│  │  │ superbeads  │ │ install     │ │ verify      │ │ check       │    │   │
│  │  │ (main CLI)  │ │ script      │ │ runner      │ │ versions    │    │   │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘    │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
                    ▼                 ▼                 ▼
              ┌──────────┐     ┌──────────┐     ┌──────────┐
              │ iOS Pack │     │Python Pk │     │  Custom  │
              │          │     │          │     │   Pack   │
              └──────────┘     └──────────┘     └──────────┘
```

---

## Directory Structure

```
core/
├── README.md                     # Core overview and quick start
├── ARCHITECTURE.md               # This document
│
├── docs/                         # Universal documentation
│   ├── UNIVERSAL-AGENTS.md       # Agent pattern documentation
│   ├── TASK-DISCIPLINE.md        # Task sizing and structure
│   ├── VERIFICATION-FRAMEWORK.md # Observable completion
│   ├── SESSION-PROTOCOLS.md      # Workflow patterns
│   ├── SPRINT-TRACKING.md        # Progress tracking
│   ├── SUPERVISOR-MODEL.md       # Human oversight
│   ├── BEADS-INTEGRATION.md      # Beads task manager integration
│   └── USING-CORE-ALONE.md       # Core without packs guide
│
├── templates/                    # Reusable templates
│   ├── agents/
│   │   ├── strategist.md         # Universal strategist template
│   │   ├── executor.md           # Universal executor template
│   │   ├── specialist.md         # Universal specialist template
│   │   └── critic.md             # Universal critic template
│   ├── skills/
│   │   └── skill-template.md     # Universal skill template
│   ├── tasks/
│   │   ├── task.schema.json      # JSON Schema for tasks
│   │   └── task-template.json    # Example task
│   ├── sprint/
│   │   ├── current.json          # Sprint state template
│   │   └── progress.md           # Progress log template
│   ├── settings/
│   │   ├── settings.schema.json  # Settings JSON Schema
│   │   └── settings.json         # Default settings
│   ├── verify.sh.template        # Verification script template
│   └── CLAUDE.md.template        # Project memory template
│
└── scripts/                      # CLI and utilities
    ├── install-superbeads.sh     # Installation script
    ├── superbeads                 # Main CLI (bash wrapper)
    ├── verify                     # Verification runner
    └── check-versions.sh         # Dependency checker
```

---

## Core Components

### 1. Universal Agent Pattern

Agents are specialized thinking modes, not code. Four universal roles:

| Role | Responsibility | Model | Example |
|------|----------------|-------|---------|
| **Strategist** | Plan, break down, architect | Sonnet | Design system structure |
| **Executor** | Implement, create, build | Sonnet | Write the actual output |
| **Specialist** | Domain expertise, details | Sonnet | Handle specialized aspects |
| **Critic** | Review, verify, improve | Haiku | Quality assurance |

**Agent File Format** (Markdown with frontmatter):

```markdown
---
name: [domain]-strategist
description: Plans and breaks down [domain] work
tools:
  - Read
  - Grep
  - Glob
  - Bash
model: sonnet
---

# [domain]-strategist

You are a [domain] planning specialist...

## Responsibilities
1. [Specific responsibility]
2. [Specific responsibility]

## What You Do NOT Do
- [Anti-responsibility]
- [Anti-responsibility]

## Workflow
[Step-by-step process]

## Output Format
[Expected output structure]
```

### 2. Task Discipline

The 10-15 minute rule applies universally:

```json
{
  "$schema": "https://superbeads.dev/schemas/task.json",
  "id": "task-001",
  "title": "Clear, actionable title (no 'and')",
  "type": "feature | research | analysis | creation | review | fix",
  "domain": "universal | ios | python | web | design | pm",
  "time_estimate": "12min",
  "context": {
    "inputs": [
      "What information/files/data is needed to start"
    ],
    "outputs": [
      "What will be produced"
    ],
    "acceptance_criteria": [
      "Specific, measurable criterion 1",
      "Specific, measurable criterion 2",
      "Specific, measurable criterion 3"
    ],
    "completion_signal": "Observable verification method"
  },
  "depends_on": ["other-task-ids"],
  "skill": "skill-name-if-applicable"
}
```

**Task Sizing Rules**:
- Single focus (no "and" in title)
- 3-5 acceptance criteria
- Clear completion signal
- Observable verification
- One commit per task

### 3. Verification Framework

Universal verification with domain-specific extensions:

```bash
#!/bin/bash
# verify.sh - Universal verification template

set -e

echo "🔍 Running verification..."

# ═══════════════════════════════════════════════════════════
# CORE CHECKS (always run)
# ═══════════════════════════════════════════════════════════

check_outputs_exist() {
    echo "📁 Checking outputs exist..."
    # Check expected files/outputs exist
    # Define in .superbeads/expected-outputs.txt
    if [ -f ".superbeads/expected-outputs.txt" ]; then
        while IFS= read -r output; do
            if [ ! -e "$output" ]; then
                echo "✗ Missing: $output"
                return 1
            fi
        done < ".superbeads/expected-outputs.txt"
    fi
    echo "✓ All outputs exist"
}

check_acceptance_criteria() {
    echo "📋 Checking acceptance criteria..."
    # Run criteria checks from current task
    # This is domain-specific and defined per-task
    echo "✓ Acceptance criteria (manual verification)"
}

# ═══════════════════════════════════════════════════════════
# PACK EXTENSIONS (if packs installed)
# ═══════════════════════════════════════════════════════════

load_pack_verifications() {
    for pack_verify in .superbeads/packs/*/verify.sh; do
        if [ -f "$pack_verify" ]; then
            echo "📦 Loading pack verification: $pack_verify"
            source "$pack_verify"
        fi
    done
}

# ═══════════════════════════════════════════════════════════
# EXECUTION
# ═══════════════════════════════════════════════════════════

main() {
    check_outputs_exist
    check_acceptance_criteria
    load_pack_verifications

    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "✅ VERIFICATION PASSED"
    echo "═══════════════════════════════════════════════════════"
}

main "$@"
```

**Verification Types** (Universal):

| Type | Signal | Applies To |
|------|--------|------------|
| **Output Exists** | File/artifact created | Any deliverable |
| **Build Passes** | Build command succeeds | Code |
| **Tests Pass** | Test suite green | Code |
| **API Success** | API call returns 2xx | Tool orchestration |
| **Checklist Complete** | All items checked | Structured work |
| **Human Confirms** | Supervisor approves | Decision points |
| **Script Passes** | Custom script exits 0 | Custom verification |

### 4. Session Protocols

Every session follows the same pattern:

```
SESSION START
═════════════════════════════════════════════════════════════

1. QUERY STATE
   - Read .superbeads/sprint/current.json
   - Check last session notes
   - Identify where we left off

2. REPORT STATUS
   - Show progress: X/Y tasks complete
   - Note any blockers
   - Summarize current state

3. GET DIRECTION
   - Ask supervisor for priorities
   - Clarify any ambiguities
   - Confirm approach

4. EXECUTE
   - Work in 10-15 min increments
   - Verify each task
   - Update progress

═════════════════════════════════════════════════════════════

SESSION END
═════════════════════════════════════════════════════════════

1. SUMMARIZE PROGRESS
   - What was accomplished
   - Current completion percentage
   - Any issues encountered

2. UPDATE STATE
   - Update .superbeads/sprint/current.json
   - Log to .superbeads/sprint/progress.md
   - Note task completions

3. PREPARE HANDOFF
   - What's next
   - Any blockers
   - Context for next session

═════════════════════════════════════════════════════════════
```

### 5. Sprint Tracking

File-based sprint state:

**`.superbeads/sprint/current.json`**:
```json
{
  "sprint_id": "sprint-2026-01-10",
  "created": "2026-01-10T10:00:00Z",
  "goal": "Sprint goal description",
  "tasks": [
    {
      "id": "task-001",
      "title": "Task title",
      "status": "pending | in_progress | completed | blocked",
      "completed_at": null
    }
  ],
  "stats": {
    "completed": 3,
    "total": 10,
    "progress_pct": 30
  }
}
```

**`.superbeads/sprint/progress.md`**:
```markdown
# Sprint Progress Log

**Goal**: Sprint goal
**Started**: 2026-01-10

---

## 2026-01-10 Session 1

### Completed
- ✓ task-001: First task title
- ✓ task-002: Second task title

### In Progress
- 🔄 task-003: Currently working on

### Notes
- Any observations
- Blockers encountered

---
```

### 6. Supervisor Model

Human oversight at key decision points:

```
SUPERVISOR CHECKPOINTS
═════════════════════════════════════════════════════════════

□ PLANNING APPROVAL
  "Here's the proposed approach. Does this look right?"

□ ARCHITECTURE DECISIONS
  "I recommend X over Y because... Agree?"

□ TASK BREAKDOWN REVIEW
  "Here are the tasks. Any additions/changes?"

□ MILESTONE CHECK
  "Completed phase 1. Ready to proceed to phase 2?"

□ COMPLETION CONFIRMATION
  "All tasks complete. Ready to wrap up?"

═════════════════════════════════════════════════════════════
```

---

## File Formats

### Settings Schema

**`.superbeads/settings.json`**:
```json
{
  "$schema": "https://superbeads.dev/schemas/settings.json",
  "project": {
    "name": "project-name",
    "domain": "universal"
  },
  "packs": {
    "installed": ["ios"],
    "settings": {
      "ios": {
        "scheme": "MyApp",
        "platform": "iOS Simulator"
      }
    }
  },
  "verification": {
    "script": "./verify.sh",
    "quick_mode": false
  },
  "agents": {
    "default_model": "sonnet",
    "cost_optimize": true
  },
  "session": {
    "auto_save_progress": true,
    "require_supervisor_approval": true
  }
}
```

### CLAUDE.md Template

```markdown
# [Project Name]

## Quick Context

| Key | Value |
|-----|-------|
| **Project** | [Name] |
| **Purpose** | [One-line description] |
| **Domain** | [universal/ios/python/web/etc] |
| **Pack** | [installed pack or "Core only"] |

---

## Working Rules

1. [Project-specific rule]
2. [Project-specific rule]

---

## Current Sprint

**Goal**: [Sprint goal]
**Progress**: [X/Y tasks complete]

---

## Session Protocol

**Start**: Read this file → Check sprint state → Report status → Get direction
**End**: Summarize → Update state → Prepare handoff

---

## Current Status

### Completed ✅
- [x] Completed task

### In Progress 🔄
- [ ] Current task

### Blockers
- [Any blockers]

---

*Last Updated: [Date]*
```

---

## CLI Design

### Command Structure

```
superbeads <command> [subcommand] [options]

COMMANDS:
  init [dir]              Initialize project with Core
  pack <action>           Pack management
  task <action>           Task management
  sprint <action>         Sprint tracking
  verify                  Run verification
  status                  Show current state

PACK COMMANDS:
  superbeads pack add <name>       Install a pack
  superbeads pack remove <name>    Remove a pack
  superbeads pack list             List installed packs
  superbeads pack list --available List available packs

TASK COMMANDS:
  superbeads task create           Create new task (interactive)
  superbeads task list             List all tasks
  superbeads task show <id>        Show task details
  superbeads task complete <id>    Mark task complete
  superbeads task next             Get next task to work on

SPRINT COMMANDS:
  superbeads sprint start          Start new sprint
  superbeads sprint status         Show sprint progress
  superbeads sprint close          Close current sprint

OPTIONS:
  --verbose, -v           Verbose output
  --quiet, -q             Minimal output
  --help, -h              Show help
  --version               Show version
```

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid arguments |
| 3 | Verification failed |
| 4 | Pack not found |
| 5 | Task not found |

---

## Integration Points

### With Claude Code

Core integrates with Claude Code through:

1. **CLAUDE.md** — Project memory and instructions
2. **`.superbeads/agents/`** — Custom agent definitions
3. **`.superbeads/commands/`** — Custom slash commands (skills)
4. **Settings** — Configuration in `.superbeads/settings.json`

### With Beads Task Manager

If Beads (`bd`, `bv`) is installed:

```bash
# Create task in Beads
superbeads task create --beads

# Sync with Beads
superbeads sync beads
```

### With Packs

Packs extend Core through:

1. **Pack-specific agents** — `packs/[name]/agents/`
2. **Pack-specific skills** — `packs/[name]/skills/`
3. **Pack-specific verification** — `packs/[name]/templates/verify.sh`
4. **Pack settings** — `packs/[name]/settings.schema.json`

---

## Installation

```bash
# Install Core
curl -fsSL https://superbeads.dev/install.sh | bash

# Or clone and run locally
git clone https://github.com/superbeads/framework.git
cd framework/core
./scripts/install-superbeads.sh

# Initialize a project
cd /path/to/project
superbeads init

# Add a pack (optional)
superbeads pack add ios
```

---

## Success Criteria

Core is successful when:

- [ ] Works without any pack installed
- [ ] Guides any task type (code, research, design, PM)
- [ ] All documentation is domain-agnostic
- [ ] CLI provides full functionality
- [ ] Verification framework is extensible
- [ ] Session protocols are clear and followable
- [ ] Sprint tracking works for any work type

---

*Architecture Document — Universal SuperBeads Framework Core Engine*
