# Sprint Tracking

> **File-based progress tracking for any work**

Sprints provide structure for complex work. Track goals, tasks, progress, and history-all in simple files.

---

## Sprint Structure

```
.superbeads/
└── sprint/
    ├── current.json     # Current sprint state
    ├── progress.md      # Progress log
    └── archive/         # Completed sprints
        ├── sprint-2026-01-01.json
        └── sprint-2026-01-05.json
```

---

## Sprint State File

**`.superbeads/sprint/current.json`**:

```json
{
  "sprint_id": "sprint-2026-01-10",
  "created": "2026-01-10T10:00:00Z",
  "goal": "Implement user authentication flow",
  "status": "active",
  "tasks": [
    {
      "id": "task-001",
      "title": "LoginView - Email field",
      "status": "completed",
      "completed_at": "2026-01-10T10:30:00Z"
    },
    {
      "id": "task-002",
      "title": "LoginView - Password field",
      "status": "completed",
      "completed_at": "2026-01-10T10:45:00Z"
    },
    {
      "id": "task-003",
      "title": "LoginView - Submit button",
      "status": "in_progress",
      "completed_at": null
    },
    {
      "id": "task-004",
      "title": "LoginViewModel - Validation",
      "status": "pending",
      "completed_at": null
    }
  ],
  "stats": {
    "completed": 2,
    "in_progress": 1,
    "pending": 1,
    "blocked": 0,
    "total": 4,
    "progress_pct": 50
  },
  "sessions": [
    {
      "date": "2026-01-10",
      "session": 1,
      "tasks_completed": ["task-001", "task-002"],
      "notes": "Good progress on login UI"
    }
  ]
}
```

---

## Progress Log

**`.superbeads/sprint/progress.md`**:

```markdown
# Sprint Progress Log

**Sprint ID**: sprint-2026-01-10
**Goal**: Implement user authentication flow
**Started**: 2026-01-10

---

## Progress Summary

| Metric | Value |
|--------|-------|
| Total Tasks | 12 |
| Completed | 5 |
| In Progress | 1 |
| Blocked | 0 |
| Progress | 42% |

---

## Session Log

### 2026-01-10 Session 1

**Tasks Completed**:
- ✓ task-001: LoginView - Email field
- ✓ task-002: LoginView - Password field

**In Progress**:
- 🔄 task-003: LoginView - Submit button

**Notes**:
- Using design system components
- Validation patterns established

**Time**: 30 minutes

---

### 2026-01-10 Session 2

**Tasks Completed**:
- ✓ task-003: LoginView - Submit button
- ✓ task-004: LoginViewModel - Validation
- ✓ task-005: LoginViewModel - API integration

**Notes**:
- API error handling added
- Form validation working

**Time**: 45 minutes

---
```

---

## Sprint Lifecycle

### 1. Create Sprint

```bash
# Interactive
superbeads sprint start

# Or with goal
superbeads sprint start --goal "Implement user authentication"
```

Creates `current.json` and `progress.md`:

```bash
mkdir -p .superbeads/sprint

cat > .superbeads/sprint/current.json << 'EOF'
{
  "sprint_id": "sprint-$(date +%Y-%m-%d)",
  "created": "$(date -Iseconds)",
  "goal": "GOAL_HERE",
  "status": "active",
  "tasks": [],
  "stats": {
    "completed": 0,
    "in_progress": 0,
    "pending": 0,
    "blocked": 0,
    "total": 0,
    "progress_pct": 0
  },
  "sessions": []
}
EOF

cat > .superbeads/sprint/progress.md << 'EOF'
# Sprint Progress Log

**Sprint ID**: sprint-$(date +%Y-%m-%d)
**Goal**: GOAL_HERE
**Started**: $(date +%Y-%m-%d)

---

## Progress Summary

| Metric | Value |
|--------|-------|
| Total Tasks | 0 |
| Completed | 0 |
| Progress | 0% |

---

## Session Log

EOF
```

### 2. Add Tasks

```bash
# Add task to sprint
superbeads task create --sprint

# Sync existing tasks
superbeads sprint sync
```

### 3. Track Progress

```bash
# View current status
superbeads sprint status

# Update after completing task
superbeads task complete task-001
```

### 4. Close Sprint

```bash
# Close and archive
superbeads sprint close

# View summary
superbeads sprint summary
```

---

## Status Transitions

```
┌──────────┐     ┌─────────────┐     ┌───────────┐
│ pending  │────▶│ in_progress │────▶│ completed │
└──────────┘     └─────────────┘     └───────────┘
      │                │
      │                │
      ▼                ▼
┌──────────────────────────────────────────────┐
│                   blocked                     │
└──────────────────────────────────────────────┘
```

| Status | Meaning | Next States |
|--------|---------|-------------|
| `pending` | Not started | `in_progress`, `blocked` |
| `in_progress` | Currently working | `completed`, `blocked` |
| `completed` | Done, verified | (terminal) |
| `blocked` | Cannot proceed | `pending`, `in_progress` |

---

## Sprint Metrics

### Automatic Calculations

```json
{
  "stats": {
    "completed": 5,
    "in_progress": 1,
    "pending": 4,
    "blocked": 2,
    "total": 12,
    "progress_pct": 42
  }
}
```

### Velocity Tracking (optional)

```json
{
  "velocity": {
    "tasks_per_session": 2.5,
    "avg_task_time_min": 12,
    "sessions_to_complete": 3
  }
}
```

---

## Sprint Patterns

### Short Sprint (1-3 days)

```json
{
  "goal": "Fix critical bugs",
  "tasks": [
    { "title": "Fix login crash", "time": "15min" },
    { "title": "Fix data sync issue", "time": "12min" },
    { "title": "Fix UI glitch", "time": "10min" }
  ]
}
```

### Feature Sprint (1-2 weeks)

```json
{
  "goal": "Implement user profile feature",
  "phases": [
    {
      "name": "Phase 1: UI",
      "tasks": ["ProfileView", "EditProfileView"]
    },
    {
      "name": "Phase 2: Logic",
      "tasks": ["ProfileViewModel", "ProfileService"]
    },
    {
      "name": "Phase 3: Polish",
      "tasks": ["Animations", "Error states"]
    }
  ]
}
```

### Research Sprint

```json
{
  "goal": "Complete competitive analysis",
  "tasks": [
    { "title": "Research Company A", "type": "research" },
    { "title": "Research Company B", "type": "research" },
    { "title": "Research Company C", "type": "research" },
    { "title": "Synthesize findings", "type": "analysis" },
    { "title": "Create report", "type": "creation" }
  ]
}
```

---

## Session Logging

### Log Entry Format

```markdown
### YYYY-MM-DD Session N

**Tasks Completed**:
- ✓ task-id: Task title

**In Progress**:
- 🔄 task-id: Task title

**Blocked**:
- ⏸ task-id: Task title (reason)

**Notes**:
- Important observation
- Decision made

**Time**: X minutes
```

### Symbols

| Symbol | Meaning |
|--------|---------|
| ✓ | Completed |
| 🔄 | In progress |
| ⏸ | Blocked |
| □ | Pending |

---

## Sprint Commands

### CLI Reference

```bash
# Sprint management
superbeads sprint start         # Create new sprint
superbeads sprint status        # View current status
superbeads sprint close         # Close and archive
superbeads sprint summary       # View sprint summary

# Task integration
superbeads sprint sync          # Sync tasks to sprint
superbeads sprint add task-id   # Add task to sprint
superbeads sprint remove task-id # Remove task

# Progress
superbeads sprint update        # Recalculate stats
superbeads sprint log "note"    # Add note to progress

# History
superbeads sprint list          # List all sprints
superbeads sprint show sprint-id # View archived sprint
```

---

## Integration with Beads

If using Beads task manager (`bd`, `bv`):

```bash
# Sync Beads tasks to sprint
superbeads sprint sync --beads

# Create task in both systems
superbeads task create --beads --sprint

# View in Beads viewer
bv --robot-triage
```

---

## Archive Format

When sprint closes, moved to archive:

**`.superbeads/sprint/archive/sprint-2026-01-10.json`**:

```json
{
  "sprint_id": "sprint-2026-01-10",
  "created": "2026-01-10T10:00:00Z",
  "closed": "2026-01-12T16:00:00Z",
  "goal": "Implement user authentication",
  "status": "closed",
  "outcome": "completed",
  "tasks": [...],
  "stats": {
    "completed": 12,
    "total": 12,
    "progress_pct": 100
  },
  "sessions": [...],
  "summary": {
    "total_sessions": 5,
    "total_time_min": 180,
    "avg_task_time_min": 12
  }
}
```

---

## Best Practices

### 1. One Goal Per Sprint

```json
{
  "goal": "Implement user authentication"  // ✓ Focused
}
```

Not:
```json
{
  "goal": "Auth, profile, settings, and bugs"  // ✗ Too broad
}
```

### 2. Right-Size the Sprint

| Sprint Size | Tasks | Duration |
|-------------|-------|----------|
| Small | 5-10 | 1-2 days |
| Medium | 10-20 | 3-5 days |
| Large | 20-30 | 1-2 weeks |

### 3. Log Every Session

Even short sessions deserve a log entry.

### 4. Update Stats After Each Task

Don't batch updates-track progress in real time.

### 5. Archive, Don't Delete

Keep sprint history for reference.

---

## Summary

1. **File-based** - JSON state + Markdown log
2. **Goal-focused** - One clear goal per sprint
3. **Task-integrated** - Tasks belong to sprints
4. **Progress-tracked** - Automatic stats
5. **Session-logged** - History preserved
6. **Archivable** - Completed sprints saved

---

*Sprint Tracking - Core Engine Documentation*
