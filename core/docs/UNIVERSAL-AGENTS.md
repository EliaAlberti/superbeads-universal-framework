# Universal Agent Pattern

> **Specialized thinking modes for any complex task**

Agents aren't code-they're structured ways of approaching work. The same four roles apply whether you're building software, conducting research, creating designs, or managing products.

---

## The Four Universal Roles

```
┌─────────────────────────────────────────────────────────────────┐
│                      COMPLEX TASK                                │
└─────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│  STRATEGIST   │    │   EXECUTOR    │    │  SPECIALIST   │
│               │    │               │    │               │
│ Plans work    │───▶│ Does work     │◀───│ Domain        │
│ Breaks down   │    │ Implements    │    │ expertise     │
│ Architects    │    │ Creates       │    │ Details       │
└───────────────┘    └───────────────┘    └───────────────┘
                              │
                              ▼
                     ┌───────────────┐
                     │    CRITIC     │
                     │               │
                     │ Reviews       │
                     │ Verifies      │
                     │ Improves      │
                     └───────────────┘
```

### 1. Strategist

**Purpose**: Plan approach, break down work, make architectural decisions

| Aspect | Description |
|--------|-------------|
| **Responsibilities** | Define approach, create task breakdown, establish dependencies |
| **Outputs** | Task list, architecture decisions, sprint plan |
| **Tools** | Read, Search, Query (no implementation tools) |
| **Model** | Sonnet (complex reasoning) |

**Example Activities by Domain**:
- **Code**: Design system architecture, create module breakdown
- **Research**: Define research questions, plan investigation
- **Design**: Establish design system, plan component hierarchy
- **Writing**: Create outline, structure narrative
- **PM**: Sprint planning, roadmap creation

### 2. Executor

**Purpose**: Implement the plan, create the actual deliverables

| Aspect | Description |
|--------|-------------|
| **Responsibilities** | Do the work, follow task specs, produce outputs |
| **Outputs** | Actual deliverables (code, documents, designs, etc.) |
| **Tools** | Full implementation tools for the domain |
| **Model** | Sonnet (quality implementation) |

**Example Activities by Domain**:
- **Code**: Write code, implement features
- **Research**: Conduct searches, gather data
- **Design**: Create mockups, build components
- **Writing**: Write content, draft documents
- **PM**: Write stories, update documentation

### 3. Specialist

**Purpose**: Provide domain expertise, handle specialized aspects

| Aspect | Description |
|--------|-------------|
| **Responsibilities** | Apply deep domain knowledge, handle complex details |
| **Outputs** | Specialized deliverables, expert guidance |
| **Tools** | Domain-specific tools |
| **Model** | Sonnet (expertise required) |

**Example Activities by Domain**:
- **Code**: UI/UX implementation, performance optimization, accessibility
- **Research**: Statistical analysis, data visualization
- **Design**: Design system maintenance, interaction patterns
- **Writing**: Technical accuracy, style consistency
- **PM**: Stakeholder communication, metrics analysis

### 4. Critic

**Purpose**: Review output, ensure quality, suggest improvements

| Aspect | Description |
|--------|-------------|
| **Responsibilities** | Review against criteria, verify completion, flag issues |
| **Outputs** | Review report, approval/rejection, improvement suggestions |
| **Tools** | Read, Verify, Check (no modification tools) |
| **Model** | Haiku (focused scope, fast feedback) |

**Example Activities by Domain**:
- **Code**: Code review, test verification, pattern compliance
- **Research**: Source verification, methodology review
- **Design**: Design review, consistency check
- **Writing**: Editorial review, fact-checking
- **PM**: Story review, acceptance criteria verification

---

## Agent Definition Format

Agents are defined in Markdown with frontmatter:

```markdown
---
name: [domain]-[role]
description: One-line description of this agent
tools:
  - Tool1
  - Tool2
model: sonnet | haiku
---

# [domain]-[role]

You are a [role] specialist for [domain] work...

## Responsibilities

1. First responsibility
2. Second responsibility
3. Third responsibility

## What You Do NOT Do

- Anti-responsibility 1 (that's [other-agent]'s job)
- Anti-responsibility 2 (that's [other-agent]'s job)

## Tools Available

- **Tool1**: What it's for
- **Tool2**: What it's for

## Workflow

### Step 1: [First Step]
[Description]

### Step 2: [Second Step]
[Description]

## Output Format

When complete, return:

```
[Role] Complete.

Summary:
• [Key point 1]
• [Key point 2]

Deliverables:
• [Deliverable 1]
• [Deliverable 2]

Recommendations:
• [Next step 1]
• [Next step 2]
```

## Best Practices

1. [Practice 1]
2. [Practice 2]
```

---

## Role Boundaries

**Critical**: Agents have clear boundaries. They do NOT overlap.

| Agent | DOES | DOES NOT |
|-------|------|----------|
| **Strategist** | Plan, break down, architect | Implement, review, specialize |
| **Executor** | Implement, create, build | Plan, review, specialize |
| **Specialist** | Apply expertise, handle details | Plan, review broadly |
| **Critic** | Review, verify, suggest | Implement, plan, specialize |

**Why boundaries matter**:
- Clear responsibility = better output
- No confusion about who does what
- Efficient use of model resources
- Predictable workflow

---

## Model Selection

| Role | Recommended Model | Rationale |
|------|-------------------|-----------|
| **Strategist** | Sonnet | Complex planning needs strong reasoning |
| **Executor** | Sonnet | Quality implementation requires capability |
| **Specialist** | Sonnet | Domain expertise needs full capability |
| **Critic** | Haiku | Focused scope, fast feedback, cost-efficient |

**Cost Optimization**: Using Haiku for Critic saves ~5x cost while maintaining quality for review tasks.

---

## Orchestration Pattern

The main Claude session orchestrates agents:

```
ORCHESTRATOR (Main Session)
│
├── "Planning needed" ──────▶ Invoke Strategist
│                                    │
│                                    ▼
│                            Task breakdown returned
│
├── "Time to implement" ────▶ Invoke Executor
│                                    │
│                                    ▼
│                            Deliverable created
│
├── "Need domain expertise" ▶ Invoke Specialist
│                                    │
│                                    ▼
│                            Specialized work done
│
└── "Review needed" ────────▶ Invoke Critic
                                     │
                                     ▼
                             Review report returned
```

**Orchestrator responsibilities**:
- Decide which agent to invoke
- Pass context between agents
- Handle agent output
- Track overall progress
- Escalate to supervisor when needed

---

## Creating Domain-Specific Agents

When creating agents for a domain pack:

### 1. Start with Universal Template

Copy from `core/templates/agents/[role].md`

### 2. Add Domain Context

- Domain-specific responsibilities
- Domain tools
- Domain workflows
- Domain outputs

### 3. Maintain Role Boundaries

Even with domain specifics, keep the role boundaries clear.

### 4. Test the Agent

- Does it stay in its lane?
- Does it produce expected outputs?
- Does it work with other agents?

---

## Examples

### Universal Strategist (Core)

```markdown
---
name: universal-strategist
description: Plans and breaks down any complex task
tools:
  - Read
  - Grep
  - Glob
model: sonnet
---

# universal-strategist

You are a strategic planning specialist...
```

### iOS Implementer (Pack)

```markdown
---
name: ios-implementer
description: Implements iOS features following Swift/SwiftUI best practices
tools:
  - Read
  - Write
  - Edit
  - Bash
model: sonnet
---

# ios-implementer

You are an iOS implementation specialist...
```

---

## Anti-Patterns

### ❌ Agent Does Everything

```markdown
# bad-agent

You handle planning, implementation, review, and everything else...
```

**Problem**: No clear responsibility, poor output quality

### ❌ Agent Overlaps

```markdown
# planning-executor

You plan AND implement the work...
```

**Problem**: Role confusion, unpredictable behavior

### ❌ Wrong Model for Role

```markdown
---
model: opus
---

# simple-critic

You review outputs...
```

**Problem**: Wasted resources, unnecessary cost

---

## Summary

1. **Four roles**: Strategist, Executor, Specialist, Critic
2. **Clear boundaries**: Each agent has defined responsibilities
3. **Right model**: Match model to complexity
4. **Orchestrated**: Main session coordinates agents
5. **Universal pattern**: Works for any domain

---

*Universal Agent Pattern - Core Engine Documentation*
