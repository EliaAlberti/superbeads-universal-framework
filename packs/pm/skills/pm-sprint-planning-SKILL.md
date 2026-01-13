# PM Sprint Planning Skill

## Description

You MUST use this skill before sprint planning activities. This applies to sprint preparation, capacity planning, and sprint commitment.

---

## Purpose

Create effective sprint plans that:
- Set achievable sprint goals
- Match capacity to commitment
- Balance features, bugs, and tech debt
- Enable predictable delivery
- Support team velocity tracking

## When to Use

- Preparing for sprint planning meetings
- Setting sprint goals and themes
- Calculating team capacity
- Finalizing sprint backlog

## Prerequisites

- Backlog groomed and prioritized
- Team capacity known
- Historical velocity available
- Stakeholder priorities clear

## Process

### Step 1: Define Sprint Goals

Set clear objectives:

```markdown
## Sprint Goals

### Sprint: 2024-Q1-S3 (Jan 15 - Jan 28)

### Primary Goal
Ship Quick Reorder MVP to 100% of users

### Supporting Goals
1. Fix critical checkout bugs (P0s only)
2. Complete analytics instrumentation
3. Reduce order history API latency by 50%

### Theme
Customer Experience: Repeat Purchase Flow

### Not This Sprint
- New feature development (except reorder)
- Major refactoring
- Non-critical bug fixes
```

### Step 2: Calculate Capacity

Determine available effort:

```markdown
## Team Capacity

### Team Composition
| Member | Role | Days Available | Notes |
|--------|------|----------------|-------|
| Alex | Frontend | 9 | - |
| Jamie | Frontend | 7 | PTO Jan 18-19 |
| Morgan | Backend | 10 | - |
| Taylor | Backend | 8 | Oncall Jan 22-24 |
| Riley | QA | 10 | - |
| Casey | Design | 5 | Supporting 50% |

### Capacity Calculation
```
Total engineering days: 9 + 7 + 10 + 8 = 34 days
QA days: 10 days
Design support: 5 days

Standard velocity: 40 points / 10 days = 4 points/day
This sprint capacity: 34 days × 0.8 (focus factor) = 27.2 effective days
Expected velocity: ~32-36 points
```

### Holidays/Events
- MLK Day (Jan 15) - US team off
- All-hands meeting Jan 22 (2 hours)

### Adjusted Capacity
**Target: 32 story points**
```

### Step 3: Review and Prioritize Backlog

Select sprint items:

```markdown
## Backlog Review

### Priority 1: Sprint Goal (Must Complete)
| Story | Points | Owner | Notes |
|-------|--------|-------|-------|
| Reorder button on order history | 5 | Alex | Core feature |
| Reorder modal implementation | 8 | Alex/Jamie | Core feature |
| Cart merge for reorder | 5 | Morgan | Backend |
| Out-of-stock handling | 3 | Morgan | Edge case |
| Reorder analytics events | 2 | Taylor | Measurement |
| QA: Reorder flow testing | - | Riley | Included |

**Subtotal: 23 points**

### Priority 2: Critical Bugs
| Bug | Points | Owner | Notes |
|-----|--------|-------|-------|
| Checkout crash on promo code | 2 | Jamie | P0, 45 users affected |
| Payment timeout not handled | 3 | Taylor | P0, causes abandoned carts |

**Subtotal: 5 points**

### Priority 3: Tech Debt
| Item | Points | Owner | Notes |
|------|--------|-------|-------|
| Order history API caching | 3 | Morgan | Supports goal |

**Subtotal: 3 points**

### Sprint Total: 31 points
```

### Step 4: Identify Dependencies

Map blockers:

```markdown
## Dependencies

### Internal Dependencies
| Story | Depends On | Status |
|-------|------------|--------|
| Reorder modal | Design finalized | READY |
| Cart merge | Order history API | READY |
| Analytics | Event schema approval | PENDING (ETA Jan 16) |

### External Dependencies
| Dependency | Owner | Status | Risk |
|------------|-------|--------|------|
| Inventory API update | Platform team | In Progress | Medium |
| App Store review | External | N/A | Submitted Jan 10 |

### Dependency Resolution
- [ ] Follow up on event schema approval by Jan 16
- [ ] Daily sync with Platform on inventory API
```

### Step 5: Assign and Sequence

Create the sprint plan:

```markdown
## Sprint Plan

### Week 1 (Jan 15-19)
| Day | Alex | Jamie | Morgan | Taylor |
|-----|------|-------|--------|--------|
| Mon | Holiday | Holiday | Holiday | Holiday |
| Tue | Reorder button start | Bug: Checkout | Cart merge | Bug: Payment |
| Wed | Reorder button | Bug: Checkout | Cart merge | Bug: Payment |
| Thu | Reorder modal start | PTO | Cart merge complete | Out-of-stock |
| Fri | Reorder modal | PTO | Code review | Out-of-stock |

### Week 2 (Jan 22-26)
| Day | Alex | Jamie | Morgan | Taylor |
|-----|------|-------|--------|--------|
| Mon | Reorder modal | Reorder modal | API caching | Oncall |
| Tue | Integration | Integration | API caching | Oncall |
| Wed | Bug fixes | Bug fixes | API caching | Oncall |
| Thu | Polish | Polish | Support | Analytics |
| Fri | Code complete | Code complete | Support | Analytics |

### Milestones
- Jan 19: Core backend complete
- Jan 24: Feature code complete
- Jan 26: QA complete, ready for release
```

### Step 6: Set Sprint Agreements

Align the team:

```markdown
## Sprint Agreements

### Ceremonies
| Ceremony | When | Duration |
|----------|------|----------|
| Daily standup | 9:30 AM | 15 min |
| Sprint planning | Jan 15, 10 AM | 2 hours |
| Backlog grooming | Jan 22, 2 PM | 1 hour |
| Sprint review | Jan 26, 3 PM | 1 hour |
| Retrospective | Jan 26, 4 PM | 1 hour |

### Working Agreements
- Feature work blocked by P0 bugs
- Code review within 4 hours
- All stories demo-ready by Thursday
- No scope changes after Wednesday W2

### Definition of Done
- [ ] Code complete with tests
- [ ] Code reviewed and merged
- [ ] QA verified
- [ ] Analytics confirmed
- [ ] Documentation updated
- [ ] Demo-ready
```

### Step 7: Document Risks

Anticipate issues:

```markdown
## Sprint Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Inventory API delayed | Medium | High | Can mock for testing |
| Reorder modal complexity | Medium | Medium | Cut P1 features if needed |
| QA bandwidth | Low | High | Frontend assists with testing |
| Oncall interruptions | Medium | Low | Buffer in estimate |

### Contingency Plan
If behind by mid-sprint:
1. Cut API caching (P3) first
2. Simplify out-of-stock to message only
3. Delay analytics to fast-follow

### Escalation Path
- Blocked > 4 hours: Escalate to tech lead
- Scope risk: PM and tech lead sync
- Resource issue: Escalate to eng manager
```

## Best Practices

### Do
- Base commitment on velocity, not optimism
- Include buffer for unknowns (20%)
- Balance new features with bugs and debt
- Identify dependencies early
- Plan for team member availability

### Don't
- Overcommit based on pressure
- Ignore historical velocity
- Skip capacity calculation
- Plan without the team
- Forget holidays and PTO

## Common Patterns

### Capacity Factors
```
Focus factor: 0.7-0.8 (meetings, interrupts)
PTO: Subtract full days
Oncall: Reduce by 50-75%
New team members: Reduce by 30% first sprint
```

### Story Mix
```
Features: 60-70%
Bugs: 15-25%
Tech debt: 10-20%
```

### Velocity Calculation
```
Average last 3 sprints
Remove outliers (holidays, incidents)
Use range (low/high) for planning
```

## Output Checklist

- [ ] Sprint goals defined (1 primary, 2-3 supporting)
- [ ] Team capacity calculated
- [ ] Backlog items selected and prioritized
- [ ] Story points within capacity
- [ ] Dependencies identified and tracked
- [ ] Work assigned and sequenced
- [ ] Ceremonies scheduled
- [ ] Working agreements confirmed
- [ ] Risks documented with mitigations
- [ ] Contingency plan ready

---

**This skill creates realistic sprint plans that match team capacity, set clear goals, and enable predictable delivery.**
