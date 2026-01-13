# Session Protocols

> **Consistent workflow patterns for every session**

Every session-regardless of domain-follows the same protocol. This ensures continuity, trackable progress, and reliable handoffs.

---

## The Session Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                        SESSION START                             │
│                                                                  │
│  1. QUERY STATE ──────────▶ Where are we?                       │
│  2. REPORT STATUS ────────▶ What's the situation?               │
│  3. GET DIRECTION ────────▶ What should we do?                  │
│  4. CONFIRM APPROACH ─────▶ Does this look right?               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        EXECUTION LOOP                            │
│                                                                  │
│         ┌──────────────────────────────────────┐                │
│         │                                      │                │
│         ▼                                      │                │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ Pick Task   │───▶│ Execute     │───▶│ Verify      │─────────┤
│  │ (10-15 min) │    │             │    │             │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                                      │                │
│         │           ┌─────────────┐            │                │
│         │           │ Mark Done   │◀───────────┘                │
│         │           │ Update      │                             │
│         │           └─────────────┘                             │
│         │                  │                                    │
│         └──────────────────┘                                    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         SESSION END                              │
│                                                                  │
│  1. SUMMARIZE ────────────▶ What did we accomplish?             │
│  2. UPDATE STATE ─────────▶ Record for next session             │
│  3. NOTE BLOCKERS ────────▶ What's important?                   │
│  4. PREPARE HANDOFF ──────▶ What does next session need?        │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Session Start Protocol

### 1. Query State

Read the current project state:

```bash
# Check sprint state
cat .superbeads/sprint/current.json | jq '.stats'

# Check CLAUDE.md for context
head -50 CLAUDE.md

# Check last progress entry
tail -30 .superbeads/sprint/progress.md
```

**Output**:
```
Sprint: sprint-2026-01-10
Progress: 5/12 tasks (42%)
Last session: Completed tasks 3-5
Current: Starting task 6
```

### 2. Report Status

Summarize to the supervisor:

```markdown
## Session Status Report

**Sprint**: sprint-2026-01-10
**Goal**: Implement user authentication flow

**Progress**: 5/12 tasks complete (42%)

**Completed**:
- ✓ task-001: LoginView email field
- ✓ task-002: LoginView password field
- ✓ task-003: LoginView submit button
- ✓ task-004: LoginViewModel validation
- ✓ task-005: LoginViewModel API integration

**Next Up**:
- □ task-006: LoginView error states
- □ task-007: LoginView success navigation

**Blockers**: None

**Notes from Last Session**:
- API error format finalized
- Using standard error view component
```

### 3. Get Direction

Ask for priorities or clarification:

```markdown
## Ready to Proceed

Based on the task breakdown, I'll work on:

1. **task-006**: LoginView error states (~12min)
2. **task-007**: LoginView success navigation (~10min)

Should I proceed with this order, or is there something else you'd like me to focus on?
```

### 4. Confirm Approach

Wait for supervisor confirmation before starting significant work.

---

## Execution Loop Protocol

### Pick Task

Select the next task based on:
1. Dependencies satisfied
2. Priority order
3. Supervisor direction

```bash
# Get next task
superbeads task next

# Or check ready tasks
superbeads task list --ready
```

### Execute

Work on the task following the task's skill (if defined):

1. Read task context
2. Gather required inputs
3. Produce the outputs
4. Follow acceptance criteria

### Verify

Run verification after completing work:

```bash
# Full verification
./verify.sh --task task-006

# Quick verification during iteration
./verify.sh --quick
```

### Mark Done

Update task status and create commit:

```bash
# Mark task complete
superbeads task complete task-006

# Commit the work
git add -A
git commit -m "✓ task-006: LoginView error states"
```

### Update Progress

Log to sprint progress:

```bash
# Auto-update sprint state
superbeads sprint update

# Or manually update progress.md
echo "- ✓ task-006: LoginView error states" >> .superbeads/sprint/progress.md
```

---

## Session End Protocol

### 1. Summarize Progress

Create a session summary:

```markdown
## Session Summary

**Duration**: ~45 minutes
**Tasks Completed**: 3 (task-006, task-007, task-008)

**What Was Done**:
- Implemented error state handling for login
- Added success navigation after login
- Created loading state indicators

**Verification**:
- All builds pass
- Preview shows correct states
- Manual QA completed
```

### 2. Update State

Update sprint tracking:

```bash
# Update current.json
superbeads sprint status --update

# Update progress.md with session log
```

**`.superbeads/sprint/progress.md`** addition:
```markdown
---

## 2026-01-10 Session 2

**Tasks Completed**:
- ✓ task-006: LoginView error states
- ✓ task-007: LoginView success navigation
- ✓ task-008: Loading state indicators

**Notes**:
- Error states follow design system
- Navigation uses coordinator pattern
- Loading states include haptic feedback

**Time**: 45 minutes

---
```

### 3. Note Blockers

Document any issues:

```markdown
**Blockers**:
- None currently

**Warnings**:
- API rate limit approaching
- Design for signup not finalized
```

### 4. Prepare Handoff

Set up for next session:

```markdown
## Next Session

**Ready Tasks**:
- task-009: Signup view (waiting on design)
- task-010: Password reset flow

**Context Needed**:
- Final signup design from Figma
- Password reset API documentation

**Suggested Focus**:
Start with task-010 (password reset) while waiting for signup design.
```

---

## Supervisor Checkpoints

Key moments requiring human approval:

### Planning Checkpoint

```markdown
## Planning Approval Needed

I've analyzed the feature request and propose breaking it down into these tasks:

[Task breakdown]

**Architecture decisions**:
- Using coordinator pattern for navigation
- Error handling via Result type
- Shared validation logic in ViewModel

Does this approach look correct?
```

### Architecture Checkpoint

```markdown
## Architecture Decision

I need to decide between:

**Option A**: Singleton service
- Pros: Simple, single source of truth
- Cons: Hard to test, tight coupling

**Option B**: Dependency injection
- Pros: Testable, flexible
- Cons: More setup

**Recommendation**: Option B

Do you agree?
```

### Milestone Checkpoint

```markdown
## Phase 1 Complete

Completed:
- All login UI tasks
- All login logic tasks
- Verification passes

Ready to proceed to Phase 2 (Signup)?
```

### Completion Checkpoint

```markdown
## Sprint Complete

All tasks completed:
- 12/12 tasks done
- All verifications pass
- Ready for review

Should I close this sprint?
```

---

## Context Preservation

### What to Preserve

| Context | Where | Why |
|---------|-------|-----|
| Sprint state | `current.json` | Track progress |
| Progress log | `progress.md` | Session history |
| Current task | CLAUDE.md | Quick reference |
| Blockers | CLAUDE.md | Visibility |
| Decisions | progress.md | Audit trail |

### CLAUDE.md Update Pattern

Update CLAUDE.md at session end:

```markdown
## Current Status

### Completed ✅
- [x] task-001: LoginView email field
- [x] task-002: LoginView password field
[... updated list ...]

### In Progress 🔄
- [ ] task-009: Signup view (blocked on design)

### Blockers
- Waiting for signup design from Figma

---

*Last Updated: 2026-01-10 Session 2*
```

---

## Protocol for Different Scenarios

### Fresh Project Start

```
1. Read CLAUDE.md
2. Check if sprint exists
3. If no sprint: Initialize sprint
4. Create initial task breakdown
5. Get supervisor approval
6. Begin execution
```

### Continuing Existing Work

```
1. Read CLAUDE.md
2. Read .superbeads/sprint/current.json
3. Read recent progress.md entries
4. Report status
5. Confirm next task
6. Continue execution
```

### Recovering from Interruption

```
1. Read last progress.md entry
2. Check for uncommitted work
3. Verify last completed task
4. Resume from next task
5. Note gap in progress log
```

### Handling Blockers

```
1. Document blocker clearly
2. Check for alternative tasks
3. If no alternative: Report to supervisor
4. If alternative exists: Proceed with it
5. Track blocked task status
```

---

## Anti-Patterns

### ❌ Starting Without Context

```
"Let me just start coding..."
```

**Instead**: Always query state first

### ❌ Not Tracking Progress

```
"I'll update the tracking later..."
```

**Instead**: Update immediately after each task

### ❌ Skipping Verification

```
"It should work, moving on..."
```

**Instead**: Always run verify.sh

### ❌ No Session Summary

```
"Session ending, bye!"
```

**Instead**: Always summarize and update state

---

## Summary

1. **Start**: Query state → Report → Get direction
2. **Execute**: Pick → Execute → Verify → Mark done → Update
3. **End**: Summarize → Update state → Note blockers → Prepare handoff
4. **Checkpoints**: Get approval at key decisions
5. **Preserve**: Always update CLAUDE.md and progress.md

---

*Session Protocols - Core Engine Documentation*
