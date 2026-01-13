# Universal SuperBeads Core Engine

> **Universal patterns for AI collaboration on ANY task**

The Core Engine works for everything: code, research, design, writing, PM—any complex task. No domain pack required.

---

## Quick Start

### 1. Initialize Your Project

```bash
# Initialize with Core
superbeads init

# Or manually create structure
mkdir -p .superbeads/sprint
cp /path/to/core/templates/CLAUDE.md.template CLAUDE.md
```

### 2. Define Your Work

```bash
# Create your first task
superbeads task create

# Or manually create task
cat > .superbeads/tasks/task-001.json << 'EOF'
{
  "id": "task-001",
  "title": "Your task title",
  "type": "feature",
  "time_estimate": "12min",
  "context": {
    "inputs": ["what you need"],
    "outputs": ["what you'll produce"],
    "acceptance_criteria": [
      "Specific criterion 1",
      "Specific criterion 2"
    ],
    "completion_signal": "How to verify done"
  }
}
EOF
```

### 3. Work in Sessions

```
SESSION START:
1. Check state → "What's the current progress?"
2. Get direction → "What should I focus on?"
3. Execute → Work in 10-15 min increments
4. Verify → Check completion signals

SESSION END:
1. Summarize → What was accomplished
2. Update state → Log progress
3. Prepare handoff → What's next
```

### 4. Verify Completion

```bash
# Run verification
./verify.sh

# Check specific task
superbeads task show task-001
```

---

## Core Concepts

### The Four Agent Roles

Every complex task benefits from four thinking modes:

| Role | Purpose | When to Use |
|------|---------|-------------|
| **Strategist** | Plan and break down | Starting new work |
| **Executor** | Implement the plan | Doing the work |
| **Specialist** | Domain expertise | Specialized aspects |
| **Critic** | Review and improve | Quality check |

### Task Discipline (10-15 Minute Rule)

Good tasks are:
- **Atomic** — Single focus, no "and"
- **Clear inputs** — What you need to start
- **Clear outputs** — What you'll produce
- **Verifiable** — Observable completion

### Verification Framework

Every task has a completion signal:
- Output exists
- Build/test passes
- API succeeds
- Checklist complete
- Human confirms

### Session Protocol

Consistent workflow every session:
1. Query state
2. Report status
3. Get direction
4. Execute with verification

---

## Directory Structure

```
your-project/
├── CLAUDE.md                 # Project memory
├── verify.sh                 # Verification script
└── .superbeads/
    ├── settings.json         # Project settings
    ├── agents/               # Custom agents (optional)
    ├── commands/             # Custom commands (optional)
    ├── tasks/                # Task definitions
    └── sprint/
        ├── current.json      # Sprint state
        └── progress.md       # Progress log
```

---

## Documentation

| Document | Purpose |
|----------|---------|
| [UNIVERSAL-AGENTS](docs/UNIVERSAL-AGENTS.md) | Agent pattern guide |
| [TASK-DISCIPLINE](docs/TASK-DISCIPLINE.md) | Task sizing rules |
| [VERIFICATION-FRAMEWORK](docs/VERIFICATION-FRAMEWORK.md) | Completion signals |
| [SESSION-PROTOCOLS](docs/SESSION-PROTOCOLS.md) | Workflow patterns |
| [SPRINT-TRACKING](docs/SPRINT-TRACKING.md) | Progress tracking |
| [SUPERVISOR-MODEL](docs/SUPERVISOR-MODEL.md) | Human oversight |
| [USING-CORE-ALONE](docs/USING-CORE-ALONE.md) | No-pack guide |

---

## With Domain Packs

Core works alone, but packs accelerate specific domains:

```bash
# Add a pack
superbeads pack add ios

# Available packs
superbeads pack list --available
```

| Pack | Domain | Agents | Skills |
|------|--------|--------|--------|
| iOS | iOS development | 4 | 9 |
| Python | Python development | 4 | 9 |
| Web | React/Next.js | 4 | 9 |
| Design | Product design | 4 | 9 |
| PM | Product management | 4 | 9 |

---

## Philosophy

> The methodology that makes iOS development exceptional now applies to everything.

Core isn't about code—it's about how humans and AI collaborate on complex work:
- **Right-sized cognitive units** (10-15 min tasks)
- **Specialized thinking modes** (agents)
- **Observable completion** (verification)
- **Human oversight** (supervisor model)

These patterns work for ANY task.

---

## License

MIT

---

*Universal SuperBeads Framework — Core Engine*
