# PM Backlog Skill

## Description

You MUST use this skill before managing backlog activities. This applies to prioritization, grooming, and backlog health maintenance.

---

## Purpose

Maintain an effective backlog that:
- Reflects current priorities
- Contains well-groomed items
- Enables sprint planning
- Balances stakeholder needs
- Supports predictable delivery

## When to Use

- Prioritizing new work
- Grooming upcoming items
- Cleaning up stale items
- Preparing for sprint planning

## Prerequisites

- Backlog exists with items
- Prioritization framework agreed
- Stakeholder input available
- Team available for estimation

## Process

### Step 1: Assess Backlog Health

Evaluate current state:

```markdown
## Backlog Health Check

### Metrics
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Total items | 156 | < 100 | 🔴 |
| Items > 6 months old | 34 | < 10 | 🔴 |
| Items with estimates | 45% | > 80% | 🟡 |
| Items with acceptance criteria | 62% | > 90% | 🟡 |
| Ready for sprint | 18 | > 30 | 🟡 |

### Health Issues
1. **Too many items** - Backlog bloat causing decision fatigue
2. **Stale items** - 34 items haven't been touched in 6+ months
3. **Low grooming rate** - Many items not ready for sprint

### Recommended Actions
1. Archive items > 6 months with no activity
2. Focus grooming on top 30 items
3. Split large items blocking sprint readiness
```

### Step 2: Apply Prioritization Framework

Use RICE or similar:

```markdown
## Prioritization: RICE Framework

### RICE Components
- **R**each: How many users affected per quarter
- **I**mpact: Effect on users (3=massive, 2=high, 1=medium, 0.5=low, 0.25=minimal)
- **C**onfidence: How sure are we (100%, 80%, 50%)
- **E**ffort: Person-months to complete

### Formula
```
RICE Score = (Reach × Impact × Confidence) / Effort
```

### Current Prioritization
| Item | Reach | Impact | Confidence | Effort | Score |
|------|-------|--------|------------|--------|-------|
| Quick Reorder | 50,000 | 2 | 80% | 2 | 40,000 |
| Order Notifications | 80,000 | 1 | 100% | 1.5 | 53,333 |
| Returns Portal | 20,000 | 3 | 50% | 4 | 7,500 |
| Dark Mode | 100,000 | 0.5 | 100% | 1 | 50,000 |
| Subscription | 15,000 | 3 | 50% | 5 | 4,500 |

### Priority Order (by RICE)
1. Order Notifications (53,333)
2. Dark Mode (50,000)
3. Quick Reorder (40,000)
4. Returns Portal (7,500)
5. Subscription (4,500)

### Override Decisions
| Item | RICE Rank | Actual Priority | Reason |
|------|-----------|-----------------|--------|
| Quick Reorder | 3 | 1 | Strategic initiative, exec commitment |
| Dark Mode | 2 | 4 | Low effort but low strategic value |
```

### Step 3: Conduct Grooming Session

Prepare items for sprint:

```markdown
## Grooming Session

### Session Details
- **Date:** January 16, 2024
- **Duration:** 1 hour
- **Participants:** PM, Tech Lead, 2 Engineers, Designer

### Agenda
1. Review top 10 ungroomed items (40 min)
2. Estimate ready items (15 min)
3. Identify blockers (5 min)

### Items Reviewed

#### Item: PROD-123 - Quick Reorder Button
**Before Grooming:**
- Description: Add reorder button
- Acceptance criteria: None
- Estimate: None
- Status: Not Ready

**After Grooming:**
- Description: Add "Reorder" button to each order in order history that allows users to add all items from that order to their cart
- Acceptance criteria:
  1. Given I view order history, When I see a past order, Then I see a "Reorder" button
  2. Given I tap "Reorder", When the order has available items, Then all items are added to cart
  3. Given I tap "Reorder", When some items are unavailable, Then available items are added and I see a message about unavailable items
- Estimate: 5 points
- Status: **Ready for Sprint**
- Dependencies: None
- Design: [Link to Figma]

#### Item: PROD-124 - Reorder Modal
**Before:** Not Ready
**After:** Ready for Sprint
**Estimate:** 8 points
**Dependencies:** PROD-123

#### Item: PROD-125 - Cart Merge Logic
**Before:** Not Ready
**After:** Ready for Sprint
**Estimate:** 5 points
**Dependencies:** None (backend work)

### Session Outcomes
| Metric | Before | After |
|--------|--------|-------|
| Items reviewed | 10 | 10 |
| Items now ready | 3 | 8 |
| Items need more work | - | 2 |
| Total points groomed | 0 | 34 |
```

### Step 4: Handle Dependencies

Map and resolve:

```markdown
## Dependency Management

### Dependency Map
```
PROD-123 (Reorder Button)
    │
    └──▶ PROD-124 (Reorder Modal)
              │
              └──▶ PROD-126 (Analytics)

PROD-125 (Cart Merge) ──────▶ PROD-124 (Reorder Modal)
                                     │
                                     └──▶ PROD-127 (E2E Tests)
```

### Dependency Resolution
| Dependency | Type | Status | Resolution |
|------------|------|--------|------------|
| PROD-124 on PROD-123 | Technical | OK | Same sprint, sequence work |
| PROD-124 on PROD-125 | Technical | OK | Parallel work, integrate mid-sprint |
| PROD-126 on PROD-124 | Feature | OK | Can stub for parallel work |
| PROD-124 on Design | External | Resolved | Design approved Jan 12 |
| Cart API on Platform | External | At Risk | ETA Jan 20, buffer in plan |

### Blocked Items
| Item | Blocker | Owner | ETA | Escalation |
|------|---------|-------|-----|------------|
| None currently | - | - | - | - |
```

### Step 5: Clean the Backlog

Remove cruft:

```markdown
## Backlog Cleanup

### Archive Candidates (No activity > 6 months)
| Item | Age | Last Touch | Decision |
|------|-----|------------|----------|
| PROD-045 | 8 months | May 2023 | Archive - superseded |
| PROD-052 | 7 months | Jun 2023 | Archive - no longer relevant |
| PROD-078 | 6 months | Jul 2023 | Keep - still on roadmap |
| PROD-089 | 6 months | Jul 2023 | Archive - competitor did it |

### Duplicate Cleanup
| Duplicate | Keep | Merge Notes |
|-----------|------|-------------|
| PROD-102, PROD-108 | PROD-102 | Merge AC from 108 |
| PROD-115, PROD-122 | PROD-122 | 122 is more detailed |

### Items to Split
| Large Item | Split Into |
|------------|------------|
| PROD-099 (18 pts) | PROD-099a (8), PROD-099b (5), PROD-099c (5) |

### Post-Cleanup Metrics
| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Total items | 156 | 112 | -44 |
| Stale items | 34 | 8 | -26 |
| Duplicates | 6 | 0 | -6 |
| Oversized items | 4 | 0 | -4 |
```

### Step 6: Communicate Priorities

Share with stakeholders:

```markdown
## Priority Communication

### Current Top 10 (Updated January 16)

| Rank | Item | Description | Status | Sprint |
|------|------|-------------|--------|--------|
| 1 | PROD-123 | Quick Reorder Button | Ready | S3 |
| 2 | PROD-124 | Reorder Modal | Ready | S3 |
| 3 | PROD-125 | Cart Merge Logic | Ready | S3 |
| 4 | PROD-126 | Reorder Analytics | Ready | S3 |
| 5 | PROD-130 | Order Status Redesign | Grooming | S4 |
| 6 | PROD-131 | Shipping Notifications | Grooming | S4 |
| 7 | PROD-140 | Returns Portal | Not Started | S5+ |
| 8 | PROD-141 | Subscription Orders | Not Started | Q2 |
| 9 | PROD-150 | Delivery Preferences | Not Started | Q2 |
| 10 | PROD-155 | Order Bundling | Not Started | Q3 |

### Priority Changes This Week
| Item | Previous | Current | Reason |
|------|----------|---------|--------|
| PROD-131 | 8 | 6 | Moved up - customer feedback |
| PROD-145 | 7 | Archived | Superseded by PROD-130 |

### Stakeholder Requests Status
| Stakeholder | Request | Status | Notes |
|-------------|---------|--------|-------|
| Sales | Gift messaging | Backlog (#156) | Prioritized for Q3 |
| Support | Bulk order edit | Declined | Tech infeasible |
| Marketing | Promo deep links | In progress (#132) | S4 target |
```

### Step 7: Establish Grooming Rhythm

Maintain ongoing health:

```markdown
## Grooming Cadence

### Weekly Activities
| Day | Activity | Duration | Participants |
|-----|----------|----------|--------------|
| Monday | Triage new items | 30 min | PM |
| Wednesday | Grooming session | 1 hour | Team |
| Friday | Backlog health check | 15 min | PM |

### Grooming Session Agenda
1. **New items triage** (10 min)
   - Review items added since last session
   - Initial sizing and prioritization

2. **Top of backlog grooming** (40 min)
   - Refine next 5-10 items
   - Add acceptance criteria
   - Estimate points
   - Identify dependencies

3. **Sprint readiness check** (10 min)
   - Confirm enough ready items for next sprint
   - Flag any blockers

### Definition of Ready
- [ ] Clear description
- [ ] Acceptance criteria in Given/When/Then
- [ ] Story points estimated
- [ ] Dependencies identified
- [ ] Design attached (if applicable)
- [ ] No blockers
```

## Best Practices

### Do
- Groom regularly (not just before sprint planning)
- Keep backlog under 100 items
- Archive ruthlessly
- Prioritize by framework, adjust for strategy
- Make priorities visible

### Don't
- Let backlog grow unbounded
- Keep stale items "just in case"
- Skip grooming sessions
- Prioritize by loudest voice
- Hide priority decisions

## Common Patterns

### Prioritization Frameworks
```
RICE: Reach, Impact, Confidence, Effort
WSJF: Weighted Shortest Job First
MoSCoW: Must, Should, Could, Won't
ICE: Impact, Confidence, Ease
```

### Backlog Views
```
By Priority: Top items first
By Epic: Grouped by initiative
By Sprint: Allocated to sprints
By Status: Ready, Needs Grooming, Blocked
```

### Item Lifecycle
```
New → Triaged → Grooming → Ready → Sprint → Done
                    ↓
              Archived/Declined
```

## Output Checklist

- [ ] Backlog health assessed
- [ ] Prioritization framework applied
- [ ] Top items groomed with AC
- [ ] Estimates added
- [ ] Dependencies mapped
- [ ] Stale items archived
- [ ] Duplicates merged
- [ ] Large items split
- [ ] Priorities communicated
- [ ] Grooming rhythm established

---

**This skill maintains a healthy, prioritized backlog that enables effective sprint planning and predictable delivery.**
