# Robot Protocol Reference

> **Machine-readable project state for AI agents**

Beads-Viewer (`bv`) provides a robot protocol -- structured output designed for agents to quickly understand project state without loading the full TUI.

---

## Commands

All commands return JSON. Agents parse the output programmatically -- no TUI interaction needed.

| Command | Purpose | Returns | When to Use |
|---------|---------|---------|-------------|
| `--robot-triage` | Project overview | Open/blocked/ready tasks, priorities, health score | Every agent on startup |
| `--robot-next` | Next task recommendation | Highest-priority unblocked task with claim command | Agent ready for next task |
| `--robot-plan` | Planning context | Dependency tree, critical path, blocked chains, cycles | Strategist planning work |
| `--robot-alerts` | Issue detection | Blockers, stale tasks, failures, health warnings | Session end or review |
| `--robot-insights` | Architecture analysis | Patterns, tech debt, improvements, observations | Planning and design decisions |

---

## Usage by Agent Role

| Command | Strategist | Executor | Specialist | Critic |
|---------|-----------|----------|------------|--------|
| `--robot-triage` | Primary | Context | Context | Context |
| `--robot-next` | Delegation | Task select | Task select | -- |
| `--robot-plan` | Primary | -- | -- | -- |
| `--robot-alerts` | -- | -- | -- | Primary |
| `--robot-insights` | Architecture | -- | -- | -- |

**Legend:** Primary = core part of role, Context = situational awareness, Task select = pick next task, Delegation = assign to others, Architecture = design decisions, -- = not typically used.

---

## Typical Usage Patterns

### Agent Startup (all roles)
```bash
bv --robot-triage
# Parse output for: health score, open tasks, priorities
```

### Task Selection (executor, specialist)
```bash
bv --robot-next
# Get recommended task, then claim it:
bd update [task-id] --status in-progress
```

### Planning Session (strategist)
```bash
bv --robot-triage    # Overall state
bv --robot-plan      # Dependency graph
bv --robot-insights  # Architecture patterns
```

### Review Session (critic)
```bash
bv --robot-alerts    # Blockers or issues?
bv --robot-triage    # Overall health
```

---

## Fallback When Beads is Not Available

If `bv` commands fail (Beads not initialized):

1. Read `.sprint/progress.md` for recent session history
2. Read `.sprint/current.json` for task state
3. Initialize Beads with `bd init` if appropriate

The robot protocol is the preferred path, but agents should degrade gracefully when Beads is not yet set up.

---

*Robot Protocol Reference - Core Engine Documentation*
