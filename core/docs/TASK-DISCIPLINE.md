# Task Discipline Guide

> **Right-sized cognitive work for any domain**

The 10-15 minute rule isn't arbitrary—it's the optimal unit of AI-human collaboration. Tasks this size are completable, verifiable, and fit in working memory.

---

## The 10-15 Minute Rule

### Why This Size?

| Factor | Benefit |
|--------|---------|
| **Completable** | Can finish in one focused session |
| **Verifiable** | Clear completion signal |
| **Recoverable** | If wrong, minimal work lost |
| **Trackable** | Progress is visible |
| **Committable** | One commit per task |

### What Fits in 10-15 Minutes?

| Domain | Example Task |
|--------|--------------|
| **Code** | Implement one component, write one function |
| **Research** | Research one company, analyze one dataset |
| **Design** | Create one screen, define one component |
| **Writing** | Write one section, edit one chapter |
| **PM** | Write one story, plan one sprint |

---

## Task Structure

Every task follows this schema:

```json
{
  "id": "task-001",
  "title": "Clear, actionable title",
  "type": "feature | research | analysis | creation | review | fix",
  "domain": "universal | ios | python | web | design | pm",
  "time_estimate": "12min",
  "context": {
    "inputs": [
      "What information/files/data is needed to start"
    ],
    "outputs": [
      "What will be produced"
    ],
    "acceptance_criteria": [
      "Specific, measurable criterion 1",
      "Specific, measurable criterion 2",
      "Specific, measurable criterion 3"
    ],
    "completion_signal": "Observable verification method"
  },
  "depends_on": ["other-task-ids"],
  "skill": "skill-name-if-applicable"
}
```

---

## Task Sizing Rules

### Rule 1: No "And" in the Title

**❌ Too Large**:
```
"Implement login screen and handle authentication"
```

**✅ Right Size**:
```
"Implement login form UI"
"Implement login form validation"
"Implement authentication API call"
"Handle authentication success/failure states"
```

### Rule 2: 3-5 Acceptance Criteria

**❌ Too Vague**:
```json
"acceptance_criteria": [
  "Works correctly"
]
```

**✅ Specific**:
```json
"acceptance_criteria": [
  "Email field validates format on blur",
  "Password field shows/hides toggle",
  "Submit button disabled until valid",
  "Loading state shown during API call",
  "Error message displayed on failure"
]
```

### Rule 3: Clear Completion Signal

**❌ Unclear**:
```
"completion_signal": "Looks good"
```

**✅ Observable**:
```
"completion_signal": "Build passes, all 5 acceptance criteria verified in preview"
```

### Rule 4: One Commit Per Task

Each task should result in exactly one commit:
```
✓ task-001: Implement login form UI
```

### Rule 5: Clear Dependencies

```json
{
  "id": "task-003",
  "title": "Implement login API call",
  "depends_on": ["task-001", "task-002"]
}
```

---

## Sizing Examples by Domain

### Code Domain

**Feature**: Add user profile screen

| Task | Time | Criteria |
|------|------|----------|
| ProfileView - Avatar section | 10min | Avatar image, edit button, circular crop |
| ProfileView - Info section | 12min | Name, email, joined date display |
| ProfileView - Settings list | 10min | Settings rows, navigation arrows |
| ProfileViewModel - Load user | 12min | API call, loading state, error handling |
| ProfileViewModel - Update avatar | 15min | Image picker, upload, progress |

### Research Domain

**Project**: Competitive analysis

| Task | Time | Criteria |
|------|------|----------|
| Research Competitor A | 12min | Company overview, product features, pricing |
| Research Competitor B | 12min | Company overview, product features, pricing |
| Research Competitor C | 12min | Company overview, product features, pricing |
| Synthesize findings | 15min | Comparison table, key differentiators |
| Create summary deck outline | 10min | Slide structure, key messages |

### Design Domain

**Feature**: Onboarding flow

| Task | Time | Criteria |
|------|------|----------|
| Welcome screen design | 12min | Hero image, headline, CTA button |
| Feature highlight 1 | 10min | Icon, title, description, animation spec |
| Feature highlight 2 | 10min | Icon, title, description, animation spec |
| Feature highlight 3 | 10min | Icon, title, description, animation spec |
| Get started screen | 12min | Sign up options, terms link |

### Writing Domain

**Project**: Technical blog post

| Task | Time | Criteria |
|------|------|----------|
| Research and outline | 15min | Key points, structure, sources |
| Write introduction | 10min | Hook, context, thesis |
| Write section 1 | 12min | Main point, examples, transition |
| Write section 2 | 12min | Main point, examples, transition |
| Write conclusion | 10min | Summary, call to action |
| Edit and polish | 15min | Flow, clarity, grammar |

### PM Domain

**Sprint**: User authentication epic

| Task | Time | Criteria |
|------|------|----------|
| Write login story | 10min | As a user, acceptance criteria, design link |
| Write signup story | 10min | As a user, acceptance criteria, design link |
| Write password reset story | 12min | As a user, acceptance criteria, flow diagram |
| Estimate stories | 10min | Point values, dependencies noted |
| Create sprint plan | 12min | Sprint goal, capacity, committed stories |

---

## Task Types

| Type | Purpose | Example |
|------|---------|---------|
| **feature** | Add new functionality | "Add dark mode toggle" |
| **fix** | Correct a problem | "Fix login button not disabling" |
| **research** | Gather information | "Research competitor pricing" |
| **analysis** | Process and interpret | "Analyze user survey results" |
| **creation** | Produce content | "Write API documentation" |
| **review** | Assess quality | "Review PR for security issues" |

---

## Time Estimation Guide

| Complexity | Time | Indicators |
|------------|------|------------|
| **Simple** | 8-10 min | One file, clear pattern, no decisions |
| **Standard** | 10-12 min | 1-2 files, known pattern, minor decisions |
| **Complex** | 12-15 min | Multiple files, new pattern, some decisions |
| **Split it** | >15 min | Too many files, unknown patterns, many decisions |

**If you estimate >15 minutes, the task is too large. Split it.**

---

## Verification Checklist

Before creating a task, verify:

- [ ] **Single focus** — No "and" in the title
- [ ] **3-5 criteria** — Specific, measurable acceptance criteria
- [ ] **Time estimate** — 10-15 minute range
- [ ] **Clear signal** — Observable completion verification
- [ ] **Dependencies** — All prerequisites identified
- [ ] **One commit** — Fits in a single commit

---

## Breaking Down Large Tasks

### Process

1. **Identify the "and"s** — Where can you split?
2. **Find natural boundaries** — UI vs logic, read vs write
3. **Create dependency chain** — What must come first?
4. **Verify each piece** — Does each pass the checklist?

### Example Breakdown

**Original**: "Implement user authentication flow"

**Breakdown**:
```
1. LoginView - Email field (10min)
   └── No dependencies

2. LoginView - Password field (10min)
   └── No dependencies

3. LoginView - Submit button (10min)
   └── Depends on: 1, 2

4. LoginViewModel - Validation logic (12min)
   └── Depends on: 1, 2

5. LoginViewModel - API integration (15min)
   └── Depends on: 3, 4

6. LoginView - Error states (12min)
   └── Depends on: 5

7. LoginView - Success navigation (10min)
   └── Depends on: 5
```

---

## Anti-Patterns

### ❌ The Mega-Task

```json
{
  "title": "Implement entire authentication system",
  "time_estimate": "4 hours"
}
```

**Problem**: Can't verify, can't track, can't recover

### ❌ The Vague Task

```json
{
  "title": "Make login better",
  "acceptance_criteria": ["It should work well"]
}
```

**Problem**: No clear completion, subjective criteria

### ❌ The Coupled Task

```json
{
  "title": "Build login UI and backend API and tests"
}
```

**Problem**: Three tasks pretending to be one

### ❌ The Orphan Task

```json
{
  "title": "Add error handling",
  "depends_on": []
}
```
(When it actually depends on the feature existing)

**Problem**: Missing dependencies cause failures

---

## Summary

1. **10-15 minutes** — Optimal task size
2. **No "and"** — Single focus per task
3. **3-5 criteria** — Specific acceptance criteria
4. **Observable signal** — Clear completion verification
5. **One commit** — Task = commit
6. **Dependencies** — Chain tasks correctly
7. **Split large tasks** — If >15 min, break it down

---

*Task Discipline Guide — Core Engine Documentation*
