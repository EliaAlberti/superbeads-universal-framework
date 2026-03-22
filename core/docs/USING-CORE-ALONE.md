# Using Core Alone

> **Full framework value without any domain pack**

Core works for ANY task. No iOS pack, no Python pack, no pack at all. Just universal patterns that make AI collaboration effective.

---

## When to Use Core Alone

| Scenario | Example |
|----------|---------|
| **One-off project** | Research project, single document |
| **Cross-domain work** | Mix of code, docs, analysis |
| **New domain** | No pack exists yet |
| **Custom workflow** | Your process doesn't fit packs |
| **Learning** | Understanding the framework |

---

## Quick Start Without Packs

### 1. Initialize Project

```bash
# Create structure
mkdir -p .superbeads/{sprint,tasks,agents}

# Create CLAUDE.md
cat > CLAUDE.md << 'EOF'
# Project Name

## Quick Context

| Key | Value |
|-----|-------|
| **Project** | Your project name |
| **Purpose** | What you're building |
| **Domain** | universal |

---

## Working Rules

1. Follow the 10-15 minute task rule
2. Verify each task before marking complete
3. Update progress after each session

---

## Current Status

### In Progress 🔄
- [ ] Current task

### Blockers
- None

---

*Last Updated: Today*
EOF
```

### 2. Define Your Agent Roles

Even without a pack, use the four roles mentally:

```markdown
## Thinking Modes for This Project

### Strategist Mode
When I need to:
- Plan the overall approach
- Break down the work
- Make structural decisions

### Executor Mode
When I need to:
- Do the actual work
- Create deliverables
- Implement the plan

### Specialist Mode
When I need to:
- Apply domain expertise
- Handle complex details
- Solve specialized problems

### Critic Mode
When I need to:
- Review output
- Check quality
- Suggest improvements
```

### 3. Break Down Your Work

Apply the 10-15 minute rule to ANY task:

```bash
# Create task file
cat > .superbeads/tasks/task-001.json << 'EOF'
{
  "id": "task-001",
  "title": "Research competitor pricing",
  "type": "research",
  "time_estimate": "12min",
  "context": {
    "inputs": ["Competitor list", "Current pricing data"],
    "outputs": ["Pricing comparison table"],
    "acceptance_criteria": [
      "All 5 competitors documented",
      "Price tiers captured",
      "Feature comparison included"
    ],
    "completion_signal": "Table complete with all data"
  }
}
EOF
```

### 4. Set Up Verification

Create a simple verification script:

```bash
cat > verify.sh << 'EOF'
#!/bin/bash
set -e

echo "🔍 Verifying task..."

# Check outputs exist
echo "📁 Checking outputs..."
# Add your checks here

echo "✅ Verification passed"
EOF

chmod +x verify.sh
```

---

## Example: Research Project

### Project: Competitive Analysis

**Goal**: Analyze 5 competitors and create summary report

### Task Breakdown

```
┌─────────────────────────────────────────────────────────┐
│ Sprint: Competitive Analysis                             │
├─────────────────────────────────────────────────────────┤
│                                                          │
│ RESEARCH PHASE                                           │
│ ├── task-001: Research Competitor A (12min)             │
│ ├── task-002: Research Competitor B (12min)             │
│ ├── task-003: Research Competitor C (12min)             │
│ ├── task-004: Research Competitor D (12min)             │
│ └── task-005: Research Competitor E (12min)             │
│                                                          │
│ ANALYSIS PHASE                                           │
│ ├── task-006: Create comparison matrix (15min)          │
│ └── task-007: Identify key differentiators (12min)      │
│                                                          │
│ SYNTHESIS PHASE                                          │
│ ├── task-008: Write executive summary (15min)           │
│ └── task-009: Create recommendations (12min)            │
│                                                          │
│ DELIVERABLE PHASE                                        │
│ ├── task-010: Compile final report (15min)              │
│ └── task-011: Create presentation (15min)               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Agent Roles Applied

**Strategist** (tasks 1-5 planning):
- Which competitors to research?
- What data points to capture?
- What sources to use?

**Executor** (tasks 1-11):
- Conduct the research
- Write the analysis
- Create deliverables

**Specialist** (embedded):
- Apply market analysis expertise
- Use industry knowledge

**Critic** (between phases):
- Is research complete?
- Is analysis sound?
- Are recommendations justified?

### Verification

```bash
#!/bin/bash
# verify.sh for research project

check_research_complete() {
    echo "📊 Checking research files..."
    for company in competitor-{a,b,c,d,e}; do
        if [ ! -f "research/${company}.md" ]; then
            echo "✗ Missing: research/${company}.md"
            return 1
        fi
    done
    echo "✓ All research files exist"
}

check_analysis_complete() {
    echo "📈 Checking analysis..."
    [ -f "analysis/comparison-matrix.md" ] || return 1
    [ -f "analysis/differentiators.md" ] || return 1
    echo "✓ Analysis complete"
}

check_deliverables() {
    echo "📄 Checking deliverables..."
    [ -f "deliverables/report.md" ] || return 1
    [ -f "deliverables/presentation.md" ] || return 1
    echo "✓ Deliverables complete"
}

main() {
    check_research_complete
    check_analysis_complete
    check_deliverables
    echo "✅ All verifications passed"
}

main "$@"
```

---

## Example: Writing Project

### Project: Technical Blog Post

**Goal**: Write and publish a technical blog post

### Task Breakdown

```json
[
  {
    "id": "task-001",
    "title": "Research and outline",
    "type": "research",
    "time_estimate": "15min",
    "context": {
      "outputs": ["outline.md"],
      "acceptance_criteria": [
        "5+ key points identified",
        "Logical structure defined",
        "Sources noted"
      ]
    }
  },
  {
    "id": "task-002",
    "title": "Write introduction",
    "type": "creation",
    "time_estimate": "10min",
    "context": {
      "outputs": ["draft.md (intro section)"],
      "acceptance_criteria": [
        "Hook engages reader",
        "Context established",
        "Thesis clear"
      ]
    }
  },
  {
    "id": "task-003",
    "title": "Write section 1",
    "type": "creation",
    "time_estimate": "12min",
    "context": {
      "outputs": ["draft.md (section 1)"],
      "acceptance_criteria": [
        "Main point clear",
        "Examples included",
        "Transition to next section"
      ]
    }
  }
]
```

### Session Protocol

```markdown
## Session Start

1. Where are we?
   - Check draft.md current state
   - See which sections done

2. What's next?
   - task-003: Write section 1

3. Execute
   - Write section following outline
   - Keep to 12min target

4. Verify
   - Main point clear? ✓
   - Examples included? ✓
   - Transition present? ✓

## Session End

Progress: 3/8 tasks (37%)
Next: task-004 (section 2)
```

---

## Example: PM Sprint Planning

### Project: Q1 Sprint Planning

**Goal**: Plan and document Q1 sprint

### Task Breakdown

| Task | Type | Time | Output |
|------|------|------|--------|
| Review backlog | analysis | 15min | prioritized-backlog.md |
| Write story: Login | creation | 10min | stories/login.md |
| Write story: Profile | creation | 10min | stories/profile.md |
| Write story: Settings | creation | 10min | stories/settings.md |
| Estimate stories | analysis | 12min | estimates.md |
| Create sprint plan | creation | 15min | sprint-plan.md |
| Review with team | review | 15min | sprint-plan.md (approved) |

### Verification

```bash
# PM project verification
check_stories() {
    local count=$(ls stories/*.md 2>/dev/null | wc -l)
    if [ "$count" -lt 3 ]; then
        echo "✗ Only $count stories (need 3+)"
        return 1
    fi
    echo "✓ $count stories written"
}

check_story_format() {
    for story in stories/*.md; do
        if ! grep -q "## Acceptance Criteria" "$story"; then
            echo "✗ Missing AC in $story"
            return 1
        fi
    done
    echo "✓ All stories have acceptance criteria"
}
```

---

## Creating Custom Agents

For recurring work, create project-specific agents:

**`.superbeads/agents/research-executor.md`**:

```markdown
---
name: research-executor
description: Conducts focused research tasks
tools:
  - WebSearch
  - WebFetch
  - Read
  - Write
model: opus
---

# research-executor

You conduct focused research tasks, gathering information from specified sources and producing structured notes.

## Responsibilities

1. Search for relevant information
2. Extract key data points
3. Organize findings in structured format
4. Note source quality and reliability

## Workflow

1. Read task requirements
2. Identify search queries
3. Execute searches
4. Extract relevant information
5. Structure findings
6. Verify completeness

## Output Format

```markdown
# Research: [Topic]

## Key Findings

1. [Finding 1]
2. [Finding 2]

## Data Points

| Metric | Value | Source |
|--------|-------|--------|

## Sources

1. [Source 1](url) - reliability: high/medium/low
2. [Source 2](url) - reliability: high/medium/low

## Notes

- [Observations]
```
```

---

## Tips for Core-Only Success

### 1. Be Explicit About Thinking Mode

```markdown
*Switching to Strategist mode to plan approach*

## Planning

1. First, I need to understand...
2. Then, break down into...
3. Finally, sequence as...

*Switching to Executor mode to begin work*
```

### 2. Create Domain-Specific Checklists

```markdown
## Research Task Checklist

- [ ] Sources identified (3+ reliable)
- [ ] Data points captured
- [ ] Findings structured
- [ ] Citations complete
```

### 3. Define Your Verification

Every domain has observable signals:

| Domain | Verification |
|--------|--------------|
| Research | Sources documented, findings structured |
| Writing | Sections complete, word count met |
| Analysis | Data processed, conclusions drawn |
| Planning | Tasks defined, estimates included |

### 4. Use the Progress Log

Track everything in `.superbeads/sprint/progress.md`:

```markdown
### 2026-01-10 Session 1

**Completed**:
- ✓ Outlined research approach
- ✓ Identified 5 sources

**Notes**:
- Source 3 has limited data
- May need additional source
```

---

## Summary

1. **Core works alone** - No pack required
2. **Apply the four roles** - Strategist, Executor, Specialist, Critic
3. **Use task discipline** - 10-15 min, clear signals
4. **Define verification** - Observable completion
5. **Track progress** - Sprint state + progress log

The universal patterns work for ANY task. Packs accelerate-Core delivers.

---

*Using Core Alone - Core Engine Documentation*
