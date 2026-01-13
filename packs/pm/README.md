# PM Pack for SuperBeads Framework

Product management pack providing specialized agents and skills for PM workflows.

## Overview

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 4 | PM-specialized agents extending core patterns |
| Skills | 9 | Complete PM workflow skill library |
| Templates | 1 | verify.sh for PM projects |

## Agents

| Agent | Role | Model | Purpose |
|-------|------|-------|---------|
| `pm-strategist` | Strategist | Sonnet | Product strategy, roadmap planning |
| `pm-executor` | Executor | Sonnet | Write PRDs, user stories, documentation |
| `pm-specialist` | Specialist | Sonnet | Metrics analysis, stakeholder communication |
| `pm-critic` | Critic | Haiku | Review stories, verify INVEST criteria |

## Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| `pm-user-story` | requirements | User stories with acceptance criteria |
| `pm-prd` | requirements | Product requirements documents |
| `pm-sprint-planning` | agile | Sprint setup, capacity, commitment |
| `pm-roadmap` | strategy | Product roadmaps and release planning |
| `pm-experiment` | lean | Hypothesis, A/B tests, metrics |
| `pm-metrics` | measurement | KPIs, OKRs, success metrics |
| `pm-communication` | leadership | Status updates, presentations |
| `pm-discovery` | lean | User research, problem validation |
| `pm-backlog` | agile | Prioritization, grooming, estimation |

## Installation

```bash
# Using SuperBeads CLI
superbeads pack install pm

# Or manually
cp -r packs/pm/agents/* ~/.superbeads/agents/
cp -r packs/pm/skills/* ~/.superbeads/skills/pm/
```

## Project Setup

After installing the pack, set up your PM project:

```bash
# Initialize SuperBeads in your project
cd your-project
superbeads init

# Install PM pack
superbeads pack install pm

# Configure verify.sh
chmod +x scripts/verify.sh
```

## Configuration

Edit `scripts/verify.sh` with your project settings:

```bash
DOCS_DIR="docs"
STORIES_DIR="docs/stories"
PRD_DIR="docs/prd"
ROADMAP_DIR="docs/roadmap"
METRICS_DIR="docs/metrics"
```

## Workflow

### 1. Planning (pm-strategist)

```
User: "Plan the user authentication feature"

pm-strategist:
- Analyzes requirements
- Breaks down into user stories
- Creates 10-15 min tasks with context
- Applies Agile + Lean methodology
```

### 2. Implementation (pm-executor)

```
pm-executor:
- Reads task specification
- Loads ONE relevant skill
- Writes PRDs, stories, documentation
- Applies INVEST criteria
- Runs verification
```

### 3. Complex Analysis (pm-specialist)

```
pm-specialist:
- Defines metrics frameworks
- Designs experiments
- Creates executive presentations
- Analyzes data and results
```

### 4. Review (pm-critic)

```
pm-critic:
- Runs verify.sh
- Checks INVEST criteria
- Verifies acceptance criteria quality
- Reports issues with specific fixes
```

## Patterns

The PM pack supports these methodologies:

### Agile Patterns
- **INVEST Stories**: Independent, Negotiable, Valuable, Estimable, Small, Testable
- **Given/When/Then**: Acceptance criteria format
- **Sprint Planning**: Capacity-based commitment
- **Backlog Management**: RICE prioritization

### Lean Patterns
- **Build-Measure-Learn**: Experiment cycle
- **Continuous Discovery**: Ongoing user research
- **Hypothesis-Driven**: Evidence-based decisions
- **MVP Thinking**: Smallest valuable increment

### Measurement
- **OKR Framework**: Objectives and Key Results
- **RICE Scoring**: Reach, Impact, Confidence, Effort
- **North Star Metrics**: Focus on what matters

## File Structure

```
packs/pm/
├── pack.json              # Pack manifest
├── README.md              # This file
├── agents/
│   ├── pm-strategist.md
│   ├── pm-executor.md
│   ├── pm-specialist.md
│   └── pm-critic.md
├── skills/
│   ├── pm-user-story-SKILL.md
│   ├── pm-prd-SKILL.md
│   ├── pm-sprint-planning-SKILL.md
│   ├── pm-roadmap-SKILL.md
│   ├── pm-experiment-SKILL.md
│   ├── pm-metrics-SKILL.md
│   ├── pm-communication-SKILL.md
│   ├── pm-discovery-SKILL.md
│   └── pm-backlog-SKILL.md
└── templates/
    └── verify.sh          # Verification script template
```

## Tooling Integration

The PM pack works with common PM tools:

| Tool | Integration |
|------|-------------|
| Linear | CLI for issue creation |
| Jira | CLI for issue tracking |
| GitHub | Issues and Projects |
| Notion | Documentation |
| Figma | Design references |

## Related Documentation

- `core/docs/UNIVERSAL-AGENTS.md` — Base agent patterns
- `core/docs/TASK-DISCIPLINE.md` — Task sizing rules
- `core/docs/VERIFICATION-FRAMEWORK.md` — Verification patterns

## Version

- Pack Version: 1.0.0
- Requires Core: >=1.0.0
