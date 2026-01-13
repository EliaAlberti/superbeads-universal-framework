# Python Pack for SuperBeads Framework

Python development pack providing specialized agents and skills for Python application development.

## Overview

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 4 | Python-specialized agents extending core patterns |
| Skills | 9 | Complete Python development skill library |
| Templates | 1 | verify.sh for Python projects |

## Agents

| Agent | Role | Model | Purpose |
|-------|------|-------|---------|
| `python-strategist` | Strategist | Sonnet | Architecture, task planning, module design |
| `python-executor` | Executor | Sonnet | Python implementation, testing |
| `python-specialist` | Specialist | Sonnet | Advanced async, performance, metaprogramming |
| `python-critic` | Critic | Haiku | Code review, verification |

## Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| `python-create-module` | Structure | Python module/package creation |
| `python-create-class` | Structure | Classes, dataclasses, protocols |
| `python-create-api` | Web | FastAPI/Flask endpoints |
| `python-setup-project` | Architecture | Project structure, pyproject.toml |
| `python-testing` | Quality | pytest tests and fixtures |
| `python-data-models` | Data | Pydantic models and validation |
| `python-database` | Services | SQLAlchemy/async database |
| `python-cli` | Interface | Typer CLI applications |
| `python-async` | Patterns | asyncio patterns and concurrency |

## Installation

```bash
# Using SuperBeads CLI
superbeads pack install python

# Or manually
cp -r packs/python/agents/* ~/.superbeads/agents/
cp -r packs/python/skills/* ~/.superbeads/skills/python/
```

## Project Setup

After installing the pack, set up your Python project:

```bash
# Initialize SuperBeads in your Python project
cd your-python-project
superbeads init

# Install Python pack
superbeads pack install python

# Configure verify.sh
chmod +x scripts/verify.sh
```

## Configuration

Edit `scripts/verify.sh` with your project settings:

```bash
SRC_DIR="src"
TEST_DIR="tests"
PYTHON_VERSION="3.11"
```

## Workflow

### 1. Planning (python-strategist)

```
User: "Add user authentication with JWT"

python-strategist:
- Analyzes requirements
- Designs module structure
- Creates 10-15 min tasks with context
- Sets up sprint tracking
```

### 2. Implementation (python-executor)

```
python-executor:
- Reads task specification
- Loads ONE relevant skill
- Implements Python code with types
- Runs verification
- Commits with task reference
```

### 3. Complex Patterns (python-specialist)

```
python-specialist:
- Handles advanced asyncio
- Performance optimization
- Metaprogramming patterns
- Complex type systems
```

### 4. Review (python-critic)

```
python-critic:
- Runs verify.sh
- Checks against criteria
- Reviews typing and docs
- Reports issues with fixes
```

## Patterns

The Python pack enforces these patterns:

- **Clean Architecture**: Layered module organization
- **Type Hints**: Full typing on all public APIs
- **Pydantic**: Data validation and serialization
- **pytest**: Testing with fixtures and markers
- **Verification**: Lint + types + tests before completion

## Tooling

| Tool | Purpose | Required |
|------|---------|----------|
| ruff | Linting and formatting | Yes |
| mypy | Type checking | Recommended |
| pytest | Testing | Yes |
| uv | Package management | Recommended |

## File Structure

```
packs/python/
├── pack.json              # Pack manifest
├── README.md              # This file
├── agents/
│   ├── python-strategist.md
│   ├── python-executor.md
│   ├── python-specialist.md
│   └── python-critic.md
├── skills/
│   ├── python-create-module-SKILL.md
│   ├── python-create-class-SKILL.md
│   ├── python-create-api-SKILL.md
│   ├── python-setup-project-SKILL.md
│   ├── python-testing-SKILL.md
│   ├── python-data-models-SKILL.md
│   ├── python-database-SKILL.md
│   ├── python-cli-SKILL.md
│   └── python-async-SKILL.md
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
- Python: >=3.11
