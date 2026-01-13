# Design Pack for SuperBeads Framework

Product design pack providing specialized agents and skills for design workflows.

## Overview

| Component | Count | Description |
|-----------|-------|-------------|
| Agents | 4 | Design-specialized agents extending core patterns |
| Skills | 9 | Complete design workflow skill library |
| Templates | 1 | verify.sh for design projects |

## Agents

| Agent | Role | Model | Purpose |
|-------|------|-------|---------|
| `design-strategist` | Strategist | Sonnet | Design system architecture, component planning |
| `design-executor` | Executor | Sonnet | Create design artifacts, apply patterns |
| `design-specialist` | Specialist | Sonnet | Accessibility, motion, responsive patterns |
| `design-critic` | Critic | Haiku | Review designs, verify consistency |

## Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| `design-create-component` | ui | UI components with variants/states |
| `design-create-screen` | ui | Complete screens and pages |
| `design-system` | foundation | Design tokens, typography, colors |
| `design-prototype` | interaction | Interactive prototypes and flows |
| `design-icons` | assets | Icon creation and systems |
| `design-ai-assets` | assets | AI-generated assets (Midjourney, DALL-E, Claude) |
| `design-handoff` | documentation | Developer handoff specifications |
| `design-user-flow` | architecture | User journey maps and flows |
| `design-review` | quality | Design critique and feedback |

## Installation

```bash
# Using SuperBeads CLI
superbeads pack install design

# Or manually
cp -r packs/design/agents/* ~/.superbeads/agents/
cp -r packs/design/skills/* ~/.superbeads/skills/design/
```

## Project Setup

After installing the pack, set up your design project:

```bash
# Initialize SuperBeads in your project
cd your-project
superbeads init

# Install Design pack
superbeads pack install design

# Configure verify.sh
chmod +x scripts/verify.sh
```

## Configuration

Edit `scripts/verify.sh` with your project settings:

```bash
DESIGN_DIR="design"
DOCS_DIR="docs"
EXPORTS_DIR="design/exports"
TOKENS_FILE="design/tokens.json"
```

## Workflow

### 1. Planning (design-strategist)

```
User: "Design a checkout flow"

design-strategist:
- Analyzes requirements
- Designs component hierarchy
- Creates 10-15 min tasks with context
- Embeds design tokens and patterns
```

### 2. Implementation (design-executor)

```
design-executor:
- Reads task specification
- Loads ONE relevant skill
- Creates design artifacts
- Documents specifications
- Runs verification
```

### 3. Complex Patterns (design-specialist)

```
design-specialist:
- Handles accessibility compliance
- Creates motion specifications
- Designs complex responsive patterns
- Manages design system governance
```

### 4. Review (design-critic)

```
design-critic:
- Runs verify.sh
- Checks design system consistency
- Verifies accessibility requirements
- Reports issues with specific fixes
```

## Patterns

The Design pack supports these patterns:

- **Atomic Design**: Atoms → Molecules → Organisms → Templates → Pages
- **Design Tokens**: Single source of truth for colors, spacing, typography
- **Component States**: Default, hover, active, disabled, error, loading
- **Responsive Design**: Mobile-first, breakpoint-based variants
- **Accessibility**: WCAG 2.1 AA compliance baseline
- **AI-Assisted**: Integration with Claude, Midjourney, DALL-E, ChatGPT, Gemini

## AI Tools Integration

This pack supports AI-assisted design workflows:

| Tool | Use Case |
|------|----------|
| Midjourney | Hero images, illustrations, artistic assets |
| DALL-E | Photorealistic images, specific compositions |
| Claude | Copy assistance, design system documentation |
| ChatGPT | Microcopy, UX writing, variations |
| Gemini | Multimodal analysis, image-aware copy |

## File Structure

```
packs/design/
├── pack.json              # Pack manifest
├── README.md              # This file
├── agents/
│   ├── design-strategist.md
│   ├── design-executor.md
│   ├── design-specialist.md
│   └── design-critic.md
├── skills/
│   ├── design-create-component-SKILL.md
│   ├── design-create-screen-SKILL.md
│   ├── design-system-SKILL.md
│   ├── design-prototype-SKILL.md
│   ├── design-icons-SKILL.md
│   ├── design-ai-assets-SKILL.md
│   ├── design-handoff-SKILL.md
│   ├── design-user-flow-SKILL.md
│   └── design-review-SKILL.md
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
- Figma: Recommended (not required)
