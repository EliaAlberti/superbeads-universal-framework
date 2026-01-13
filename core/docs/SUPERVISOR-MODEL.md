# Supervisor Model

> **Human oversight at key decision points**

The supervisor (human) maintains control over direction, architecture, and approval. The AI executes within defined boundaries and escalates at checkpoints.

---

## The Collaboration Model

```
┌─────────────────────────────────────────────────────────────────┐
│                        SUPERVISOR (Human)                        │
│                                                                  │
│  Responsibilities:                                               │
│  • Set direction and priorities                                  │
│  • Approve architectural decisions                               │
│  • Review at checkpoints                                         │
│  • Unblock issues                                                │
│  • Accept/reject deliverables                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                    Direction │ Approval
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        EXECUTOR (AI)                             │
│                                                                  │
│  Responsibilities:                                               │
│  • Execute within boundaries                                     │
│  • Report progress                                               │
│  • Escalate at checkpoints                                       │
│  • Present options (not decisions)                               │
│  • Produce deliverables                                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Checkpoint Types

### 1. Planning Checkpoint

**When**: Before starting significant work

**Purpose**: Align on approach before investing effort

**Format**:
```markdown
## Planning Approval Requested

**Feature**: User authentication flow

**Proposed Approach**:
I've analyzed the requirements and propose:

1. Task breakdown (12 tasks)
2. Architecture: MVVM with Coordinator
3. Dependencies: Auth service, Storage

**Task List**:
[Task breakdown]

**Estimated Time**: ~2.5 hours

**Questions**:
- Should password reset be in scope?
- Which auth provider to integrate?

**Awaiting your approval to proceed.**
```

### 2. Architecture Checkpoint

**When**: Before making significant architectural decisions

**Purpose**: Ensure alignment on technical direction

**Format**:
```markdown
## Architecture Decision Needed

**Decision**: State management approach

**Options**:

| Option | Pros | Cons |
|--------|------|------|
| **A: Singleton** | Simple, central | Hard to test |
| **B: DI** | Testable, flexible | More setup |
| **C: Redux-like** | Predictable | Complex |

**Recommendation**: Option B (Dependency Injection)

**Rationale**:
- Aligns with testing goals
- Standard pattern in codebase
- Minimal additional setup

**Impact**: Affects 5 tasks in breakdown

**Awaiting your decision.**
```

### 3. Blocker Checkpoint

**When**: Cannot proceed without human input

**Purpose**: Get unblocked with minimal delay

**Format**:
```markdown
## Blocker: Need Input

**Task**: task-007 - Implement signup flow

**Blocked By**: Missing design specifications

**What I Need**:
- Signup screen Figma link
- OR approval to proceed with login screen style

**Options**:
1. Wait for design (pause signup tasks)
2. Proceed with login-style design (may need revision)
3. Skip signup, continue with other tasks

**My Recommendation**: Option 3 - continue with password reset while waiting

**Your decision needed to proceed.**
```

### 4. Milestone Checkpoint

**When**: Completing a phase of work

**Purpose**: Confirm before proceeding to next phase

**Format**:
```markdown
## Milestone: Phase 1 Complete

**Phase**: Login UI Implementation

**Completed**:
- ✓ task-001: Email field
- ✓ task-002: Password field
- ✓ task-003: Submit button
- ✓ task-004: Error states
- ✓ task-005: Loading states

**Verification**:
- Build passes
- All previews render correctly
- Manual QA completed

**Next Phase**: Login Logic Implementation
- task-006: Validation logic
- task-007: API integration
- task-008: Success handling

**Ready to proceed to Phase 2?**
```

### 5. Completion Checkpoint

**When**: All work complete

**Purpose**: Get final approval before closing

**Format**:
```markdown
## Sprint Complete: Ready for Review

**Sprint**: User Authentication Flow
**Goal**: Implement login, signup, password reset

**Results**:
- 15/15 tasks completed
- All verification passes
- All acceptance criteria met

**Deliverables**:
- Login screen with validation
- Signup flow with email verification
- Password reset with email link

**Testing**:
- Unit tests: 24/24 passing
- UI tests: 8/8 passing
- Manual QA: Complete

**Ready to close sprint?**
```

---

## Decision Boundaries

### AI Decides (No Approval Needed)

| Decision | Example |
|----------|---------|
| Implementation details | Variable names, code style |
| Order within task | Which file to edit first |
| Tool selection | Which grep pattern to use |
| Error recovery | How to fix lint error |
| Documentation | Comments, inline docs |

### Supervisor Decides (Approval Needed)

| Decision | Example |
|----------|---------|
| Architecture | MVVM vs MVC, singleton vs DI |
| Scope | Include/exclude features |
| Priority | Which task first |
| Trade-offs | Speed vs quality |
| External | APIs, services, dependencies |

---

## Communication Patterns

### Status Update

Regular progress reports without requiring action:

```markdown
## Progress Update

**Sprint**: Authentication Flow
**Progress**: 8/15 tasks (53%)

**Since Last Update**:
- Completed: task-006, task-007
- Currently: task-008

**On Track**: Yes
**Blockers**: None

*No action needed-informational only*
```

### Question

When needing clarification:

```markdown
## Question

While implementing task-008 (error handling), I need clarity:

**Question**: How should we handle network timeout errors?

**Options**:
1. Show generic error, auto-retry
2. Show specific timeout message, manual retry button
3. Silent retry (3x), then show error

**My lean**: Option 2 (clear to user, gives control)

**Your preference?**
```

### Proposal

When suggesting a change:

```markdown
## Proposal: Refactor Approach

**Observation**: Tasks 9-12 could be simplified

**Current Plan**:
- task-009: Create AuthService
- task-010: Create AuthManager
- task-011: Wire AuthService
- task-012: Wire AuthManager

**Proposed Change**:
Combine AuthService and AuthManager into single AuthService

**Benefits**:
- Simpler architecture
- Fewer files
- 2 tasks instead of 4

**Trade-offs**:
- Less separation of concerns
- Harder to mock in tests

**Should I proceed with original plan or this simplification?**
```

---

## Escalation Rules

### When to Escalate

1. **Ambiguity**: Requirements unclear
2. **Conflict**: Contradicting requirements
3. **Risk**: Decision could cause significant rework
4. **Scope**: Something seems out of scope
5. **Blocker**: Cannot proceed without input
6. **Surprise**: Finding something unexpected

### How to Escalate

```markdown
## Escalation: [Type]

**Context**: [What you were doing]

**Issue**: [What the problem is]

**Options**: [If applicable]

**My Assessment**: [Your analysis]

**Need**: [What you need from supervisor]
```

---

## Response Handling

### Supervisor Approves

```
Supervisor: "Yes, proceed with Option B"

AI Response:
"Understood. Proceeding with dependency injection approach.
This affects tasks 5-8. Starting with task-005 now."
```

### Supervisor Rejects

```
Supervisor: "No, use Option A instead"

AI Response:
"Understood. Switching to singleton approach.
I'll adjust tasks 5-8 accordingly. The trade-off is
reduced testability, but simpler implementation."
```

### Supervisor Asks for More Info

```
Supervisor: "What's the testing impact of Option A?"

AI Response:
"With singleton approach:
- Can't mock in unit tests without reset method
- Integration tests would test real singleton
- Could add test-only reset() method

Compared to DI:
- DI allows full mocking
- Each test gets fresh instance
- Standard testing pattern

Want me to detail specific test cases affected?"
```

### Supervisor Changes Direction

```
Supervisor: "Actually, let's skip auth and do profile first"

AI Response:
"Understood. Pausing authentication sprint.

Current state:
- 8/15 auth tasks complete
- Work is committed and stable

Starting profile feature:
- Will create new task breakdown
- Will initialize new sprint

Should I archive the auth sprint or keep it active?"
```

---

## Settings

Configure supervisor interaction in settings:

```json
{
  "supervisor": {
    "require_approval": {
      "planning": true,
      "architecture": true,
      "milestone": true,
      "completion": true
    },
    "auto_proceed": {
      "implementation_details": true,
      "minor_decisions": true
    },
    "escalation": {
      "on_ambiguity": true,
      "on_risk": true,
      "on_blocker": true
    }
  }
}
```

---

## Best Practices

### For AI

1. **Present options, not decisions** - Let supervisor choose
2. **Provide context** - Enough info to decide
3. **Be concise** - Respect supervisor's time
4. **Show trade-offs** - No option is perfect
5. **State your lean** - But don't assume approval

### For Supervisor

1. **Be decisive** - Quick decisions keep momentum
2. **Be clear** - Explicit approval or rejection
3. **Provide rationale** - Helps AI learn preferences
4. **Trust the process** - Let AI execute within bounds
5. **Review checkpoints** - Don't skip approval moments

---

## Summary

1. **Clear roles** - Supervisor directs, AI executes
2. **Defined checkpoints** - Planning, architecture, milestones
3. **Escalation rules** - When to ask vs. when to proceed
4. **Communication patterns** - Status, question, proposal
5. **Trust boundaries** - AI decides implementation, supervisor decides direction

---

*Supervisor Model - Core Engine Documentation*
