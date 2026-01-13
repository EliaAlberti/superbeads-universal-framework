# Contributing to SuperBeads Universal Framework

Thank you for your interest in contributing! This guide covers how to contribute to the core framework and how to create new domain packs.

---

## Table of Contents

- [Types of Contributions](#types-of-contributions)
- [Getting Started](#getting-started)
- [Contributing to Core](#contributing-to-core)
- [Creating a New Pack](#creating-a-new-pack)
- [Code Style](#code-style)
- [Pull Request Process](#pull-request-process)
- [Issue Guidelines](#issue-guidelines)

---

## Types of Contributions

| Type | Description | Where |
|------|-------------|-------|
| **Bug Fixes** | Fix issues in core or existing packs | Core or pack directories |
| **Core Enhancements** | Improve universal patterns, docs, CLI | `core/` directory |
| **New Domain Packs** | Create packs for new domains | `packs/{domain}/` |
| **Documentation** | Improve guides, examples, clarity | Anywhere |
| **Skill Additions** | Add skills to existing packs | `packs/{domain}/skills/` |

---

## Getting Started

```bash
# Fork and clone the repository
git clone https://github.com/YOUR-USERNAME/superbeads-universal-framework.git
cd superbeads-universal-framework

# Create a branch for your contribution
git checkout -b feature/your-contribution-name

# Test the CLI works
./core/scripts/superbeads --version
```

---

## Contributing to Core

Core contains universal patterns that apply to **any** domain. Changes here must be domain-agnostic.

### Core Structure

```
core/
├── docs/                    # Universal documentation
│   ├── UNIVERSAL-AGENTS.md  # Four agent roles
│   ├── TASK-DISCIPLINE.md   # 10-15 min rule
│   ├── VERIFICATION.md      # Observable completion
│   ├── SESSION-PROTOCOLS.md # Start/end workflows
│   ├── SPRINT-MANAGEMENT.md # Sprint tracking
│   ├── SUPERVISOR-GUIDE.md  # Managing agent teams
│   └── USING-CORE-ALONE.md  # No-pack usage
├── templates/               # Reusable templates
│   ├── agent-*.md           # Base agent templates
│   ├── skill-template.md    # Skill structure
│   ├── task-schema.json     # Task JSON schema
│   └── CLAUDE-template.md   # Project CLAUDE.md template
└── scripts/                 # CLI and utilities
    └── superbeads           # Main CLI
```

### What Belongs in Core

| Include | Exclude |
|---------|---------|
| Universal agent patterns | Domain-specific agents |
| Task sizing principles | Technology-specific tools |
| Verification concepts | Language-specific checks |
| Session workflows | Framework-specific patterns |
| Sprint management | Tool-specific integrations |

### Core Contribution Checklist

- [ ] Change applies to ALL domains, not just one
- [ ] Existing packs still work after change
- [ ] Documentation updated if behavior changes
- [ ] No domain-specific assumptions

---

## Creating a New Pack

Packs extend core with domain-specific agents, skills, and verification.

### Pack Structure

```
packs/{domain}/
├── pack.json               # Pack manifest (required)
├── README.md               # Pack documentation
├── agents/                 # 4 domain agents
│   ├── {domain}-strategist.md
│   ├── {domain}-executor.md
│   ├── {domain}-specialist.md
│   └── {domain}-critic.md
├── skills/                 # Domain skills (recommended: 7-12)
│   └── {domain}-{action}-SKILL.md
└── templates/
    └── verify.sh           # Domain verification script
```

### Step 1: Create pack.json

The manifest defines your pack's contents and requirements.

```json
{
  "name": "your-domain",
  "version": "1.0.0",
  "description": "Description of what this pack enables",
  "domain": "Human-readable domain name",
  "requires_core": ">=1.0.0",

  "agents": [
    {
      "name": "{domain}-strategist",
      "extends": "strategist",
      "file": "agents/{domain}-strategist.md",
      "model": "sonnet"
    },
    {
      "name": "{domain}-executor",
      "extends": "executor",
      "file": "agents/{domain}-executor.md",
      "model": "sonnet"
    },
    {
      "name": "{domain}-specialist",
      "extends": "specialist",
      "file": "agents/{domain}-specialist.md",
      "model": "sonnet"
    },
    {
      "name": "{domain}-critic",
      "extends": "critic",
      "file": "agents/{domain}-critic.md",
      "model": "haiku"
    }
  ],

  "skills": [
    { "file": "skills/{domain}-{action}-SKILL.md", "category": "category" }
  ],

  "templates": [
    { "file": "templates/verify.sh", "target": "scripts/verify.sh" }
  ],

  "verification": {
    "script": "scripts/verify.sh",
    "checks": [
      { "name": "check-name", "command": "verification command" }
    ]
  },

  "tools": {
    "tool-name": {
      "command": "tool-command",
      "required": true,
      "description": "What this tool does"
    }
  }
}
```

### Step 2: Create Agents

Each agent uses markdown with YAML frontmatter.

**Agent Template:**

```markdown
---
name: {domain}-{role}
extends: core/{role}
description: One-line description of this agent's specialty
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Edit    # Only for executor
  - Write   # Only for executor
model: sonnet  # or haiku for critic
---

# {domain}-{role}

You are a {domain} {role}. [Describe primary responsibility]

## Core Inheritance

This agent extends the core {role} pattern. See `core/docs/UNIVERSAL-AGENTS.md`.

## {Domain}-Specific Responsibilities

1. **First responsibility**: What this means for your domain
2. **Second responsibility**: What this means for your domain
3. **Third responsibility**: What this means for your domain

## What You Do NOT Do

- [Things this agent doesn't do - see core agent docs]

## Tools Available

- **Read**: [How this agent uses Read]
- **Grep/Glob**: [How this agent uses search]
- **Bash**: [What commands this agent runs]

## Workflow

### Step 1: [First step name]

[Detailed instructions]

### Step 2: [Second step name]

[Detailed instructions]

## Domain Patterns

[Domain-specific patterns, conventions, best practices]

## Output Format

[What this agent produces]
```

**Model Assignment:**

| Agent | Model | Rationale |
|-------|-------|-----------|
| Strategist | Sonnet | Complex planning requires strong reasoning |
| Executor | Sonnet | Implementation needs code understanding |
| Specialist | Sonnet | Domain expertise requires deep knowledge |
| Critic | Haiku | Review is structured, lower complexity |

### Step 3: Create Skills

Skills are reusable procedures for specific tasks.

**Skill Template:**

```markdown
# {Domain} {Action} Skill

## Description

You MUST use this skill before [specific trigger condition].

---

## Purpose

[What this skill accomplishes - 3-5 bullet points]

## When to Use

- [Trigger condition 1]
- [Trigger condition 2]
- [Trigger condition 3]

## Prerequisites

- [What must be true before using]
- [Required context or information]

## Process

### Step 1: [Step Name]

[Detailed instructions with code examples if applicable]

### Step 2: [Step Name]

[Detailed instructions]

### Step 3: [Step Name]

[Detailed instructions]

## Best Practices

### Do

- [Best practice 1]
- [Best practice 2]

### Don't

- [Anti-pattern 1]
- [Anti-pattern 2]

## Common Patterns

[Domain-specific patterns with examples]

## Output Checklist

- [ ] [Verification item 1]
- [ ] [Verification item 2]
- [ ] [Verification item 3]

---

**This skill [brief summary of value].**
```

**Skill Naming Convention:** `{domain}-{action}-SKILL.md`

Examples:
- `python-create-api-SKILL.md`
- `web-create-component-SKILL.md`
- `design-create-screen-SKILL.md`
- `pm-user-story-SKILL.md`

### Step 4: Create Verification Script

```bash
#!/bin/bash
# verify.sh - {Domain} verification script
set -e

echo "🔍 Running {domain} verification..."

# Check 1: [Description]
check_something() {
    echo "📋 Checking something..."
    # verification command
    echo "✓ Something verified"
}

# Check 2: [Description]
check_another() {
    echo "📋 Checking another..."
    # verification command
    echo "✓ Another verified"
}

# Main
main() {
    check_something
    check_another
    echo ""
    echo "✅ All {domain} verifications passed"
}

main "$@"
```

### Step 5: Create README.md

```markdown
# {Domain} Pack

> Domain-specific agents and skills for {domain} development.

## What's Included

### Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| {domain}-strategist | Sonnet | [Purpose] |
| {domain}-executor | Sonnet | [Purpose] |
| {domain}-specialist | Sonnet | [Purpose] |
| {domain}-critic | Haiku | [Purpose] |

### Skills

| Skill | Category | Purpose |
|-------|----------|---------|
| {domain}-{action} | category | [Purpose] |

## Installation

```bash
superbeads pack install {domain}
```

## Usage

[Domain-specific usage examples]

## Verification

```bash
./scripts/verify.sh
```

## Requirements

- [Tool 1]
- [Tool 2]
```

### Pack Contribution Checklist

- [ ] `pack.json` valid and complete
- [ ] All 4 agents created with proper frontmatter
- [ ] 7-12 skills covering domain essentials
- [ ] `verify.sh` script works
- [ ] `README.md` documents pack contents
- [ ] Pack installs successfully: `superbeads pack install {domain}`

---

## Code Style

### Markdown Files

- Use ATX-style headers (`#`, `##`, `###`)
- Include horizontal rules (`---`) between major sections
- Use tables for structured information
- Include code blocks with language hints
- Keep lines under 120 characters where practical

### JSON Files

- 2-space indentation
- No trailing commas
- Keys in lowercase with hyphens

### Shell Scripts

- Include `set -e` for error handling
- Add descriptive comments
- Use functions for organization
- Include clear success/failure messages

---

## Pull Request Process

### Before Submitting

1. Test your changes locally
2. Update documentation if needed
3. Ensure all existing functionality works
4. Follow the code style guidelines

### PR Template

```markdown
## Description

[What does this PR do?]

## Type of Change

- [ ] Bug fix
- [ ] New feature (core)
- [ ] New domain pack
- [ ] Documentation update
- [ ] Other: [describe]

## Testing

[How did you test this?]

## Checklist

- [ ] Code follows project style
- [ ] Documentation updated
- [ ] All tests pass
- [ ] PR has descriptive title
```

### Review Process

1. Submit PR against `main` branch
2. Maintainers review within 1 week
3. Address any feedback
4. Once approved, maintainer merges

---

## Issue Guidelines

### Bug Reports

```markdown
**Describe the bug**
[Clear description of what's wrong]

**To Reproduce**
1. Step one
2. Step two
3. Step three

**Expected behavior**
[What should happen]

**Environment**
- OS: [e.g., macOS 14.0]
- Claude Code version: [e.g., 1.0.0]
- Pack (if applicable): [e.g., python]
```

### Feature Requests

```markdown
**Is this for Core or a Pack?**
[Core / Existing Pack / New Pack]

**Describe the feature**
[What do you want to add?]

**Use case**
[Why is this useful?]

**Proposed solution**
[How might this work?]
```

### New Pack Proposals

```markdown
**Domain**
[What domain does this pack cover?]

**Why is this needed?**
[What problems does it solve?]

**Proposed skills**
1. [Skill 1]
2. [Skill 2]
3. [Skill 3]

**Example workflow**
[How would someone use this pack?]
```

---

## Questions?

- Check existing [issues](https://github.com/YOUR-USERNAME/superbeads-universal-framework/issues)
- Read the [documentation](./GUIDE.md)
- Open a new issue with your question

---

Thank you for contributing to SuperBeads!
