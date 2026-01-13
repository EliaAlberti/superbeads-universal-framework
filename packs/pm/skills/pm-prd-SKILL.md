# PM PRD Skill

## Description

You MUST use this skill before creating Product Requirements Documents. This applies to feature PRDs, product area PRDs, and initiative documentation.

---

## Purpose

Create complete, actionable PRDs that:
- Clearly define the problem and solution
- Align stakeholders on scope and goals
- Enable accurate estimation and planning
- Serve as source of truth throughout development
- Support decision-making with data

## When to Use

- Starting new product initiatives
- Documenting feature requirements
- Formalizing product decisions
- Aligning cross-functional teams

## Prerequisites

- Problem validated with research
- Business case understood
- Key stakeholders identified
- Technical feasibility assessed

## Process

### Step 1: Write the Executive Summary

Capture the essence:

```markdown
# Product Requirements Document: Quick Reorder

## Executive Summary

### Problem
Returning customers waste 2-3 minutes navigating our catalog to repurchase
items they've bought before. 67% of repeat purchases are the same items,
yet the experience treats them like first-time buyers.

### Solution
Introduce a "Quick Reorder" feature that surfaces past orders prominently
and enables one-tap repurchase of entire orders or individual items.

### Impact
- Reduce repeat purchase time from 3 minutes to 30 seconds
- Increase repeat purchase rate by 15%
- Improve NPS for returning customers by 5 points

### Timeline
MVP: End of Q1 2024 (6 weeks)
Full feature: End of Q2 2024
```

### Step 2: Define the Problem

Articulate clearly:

```markdown
## Problem Definition

### User Problem
Returning customers want to quickly repurchase items but currently must:
1. Remember what they bought
2. Search or browse the catalog
3. Add each item individually
4. Repeat for multiple items

This friction causes cart abandonment and reduces repeat purchase frequency.

### Business Problem
- 40% of returning customers don't complete repeat purchases
- Support tickets about "finding previous orders" = 12% of total
- Competitors offer reorder in 2 taps; we require 8+

### Evidence
| Source | Finding |
|--------|---------|
| User interviews (n=15) | 11/15 mentioned difficulty reordering |
| Analytics | Repeat customers have 2.3x cart abandonment |
| Support data | 340 tickets/month about past orders |
| Competitor analysis | Amazon: 2 taps, Target: 3 taps, Us: 8 taps |

### Jobs to Be Done
**When** I've run out of a product I use regularly
**I want to** repurchase it without hunting through the catalog
**So that** I can restock quickly and get back to my day
```

### Step 3: Define Success Metrics

Set measurable goals:

```markdown
## Success Metrics

### Primary Metrics (North Star)
| Metric | Current | Target | Timeline |
|--------|---------|--------|----------|
| Repeat purchase rate | 23% | 28% | +3 months |
| Time to repurchase | 180 sec | 45 sec | Launch |

### Secondary Metrics
| Metric | Current | Target |
|--------|---------|--------|
| Quick Reorder adoption | N/A | 40% of repeat orders |
| Cart abandonment (repeat) | 38% | 25% |
| NPS (repeat customers) | 42 | 47 |

### Guardrail Metrics
These should NOT decrease:
- Average order value
- First-time purchase rate
- App performance (load time)

### Measurement Plan
- A/B test with 20% of users
- Measure for 4 weeks post-launch
- Segment by customer tenure
```

### Step 4: Describe the Solution

Detail the approach:

```markdown
## Solution Overview

### Core Features

#### 1. Order History Quick Reorder
Users can reorder any past order with one tap from order history.
- Shows "Reorder" button on each past order
- Opens modal to review/modify before adding to cart
- Handles out-of-stock items gracefully

#### 2. Frequently Bought Items
Homepage section showing items purchased 2+ times.
- Quick-add button on each item
- Sorted by purchase frequency
- Limited to 8 items for performance

#### 3. Reorder from Confirmation
Post-purchase email includes "Reorder this" deep link.
- One-tap adds same items to cart
- Opens app directly to cart

### User Flows
See: [Quick Reorder User Flow](../design/flows/reorder.md)

### Wireframes
See: [Figma Designs](https://figma.com/...)
```

### Step 5: Define Scope

Clarify boundaries:

```markdown
## Scope

### In Scope (MVP)
- [x] Reorder button on order history
- [x] Pre-populated cart with past order items
- [x] Quantity adjustment before adding
- [x] Out-of-stock handling with message
- [x] Mobile app (iOS and Android)

### In Scope (Fast Follow)
- [ ] Frequently bought items section
- [ ] Reorder from email confirmation
- [ ] Desktop web implementation

### Out of Scope
- Subscription/auto-reorder (separate initiative)
- Reorder scheduling ("remind me in 30 days")
- Integration with Alexa/Google Home
- Partial order templates

### Open Questions
| Question | Owner | Due Date |
|----------|-------|----------|
| Should we show unavailable items? | @pm | Jan 15 |
| Include items from canceled orders? | @pm | Jan 15 |
| Maximum order age to show? | @eng | Jan 18 |
```

### Step 6: Document Requirements

Detail functional requirements:

```markdown
## Functional Requirements

### FR1: Order History Display
| ID | Requirement | Priority |
|----|-------------|----------|
| FR1.1 | Show "Reorder" button on orders < 1 year old | P0 |
| FR1.2 | Button disabled if all items unavailable | P1 |
| FR1.3 | Show item count and total on button | P2 |

### FR2: Reorder Modal
| ID | Requirement | Priority |
|----|-------------|----------|
| FR2.1 | Display all items from original order | P0 |
| FR2.2 | Allow quantity adjustment (1-99) | P0 |
| FR2.3 | Allow item removal | P0 |
| FR2.4 | Show current price (may differ from original) | P0 |
| FR2.5 | Indicate out-of-stock items | P0 |
| FR2.6 | Suggest alternatives for unavailable items | P1 |

### FR3: Cart Integration
| ID | Requirement | Priority |
|----|-------------|----------|
| FR3.1 | Add items to existing cart (merge) | P0 |
| FR3.2 | Update quantity for duplicate items | P0 |
| FR3.3 | Show success confirmation | P0 |
| FR3.4 | Deep link to cart after adding | P0 |

### Non-Functional Requirements
| ID | Requirement | Target |
|----|-------------|--------|
| NFR1 | Reorder modal loads in < 1 second | P0 |
| NFR2 | Cart update completes in < 500ms | P0 |
| NFR3 | Works offline (cached recent orders) | P2 |
```

### Step 7: Address Risks and Dependencies

Document blockers:

```markdown
## Dependencies

### Technical Dependencies
| Dependency | Status | Owner | Risk |
|------------|--------|-------|------|
| Order History API | Available | @backend | Low |
| Cart Service API | Available | @backend | Low |
| Inventory Service | Needs update | @platform | Medium |

### Cross-Team Dependencies
| Team | Need | Status |
|------|------|--------|
| Design | Finalize modal designs | In Progress |
| Backend | Inventory availability endpoint | Not Started |
| Mobile | Implement on iOS and Android | Scheduled |

## Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Inventory data stale | Medium | High | Real-time check on reorder tap |
| Price changes confuse users | Medium | Medium | Show "prices may have changed" |
| Cart merge issues | Low | High | Extensive testing, rollback plan |
| Performance impact | Low | Medium | Lazy load, pagination |
```

### Step 8: Create Launch Plan

Plan the rollout:

```markdown
## Launch Plan

### Phases
| Phase | Scope | Audience | Date |
|-------|-------|----------|------|
| Alpha | Core reorder | Internal team | Feb 1 |
| Beta | Core reorder | 5% of users | Feb 15 |
| GA | Core reorder | 100% of users | Mar 1 |
| V1.1 | Frequently bought | 100% | Apr 1 |

### Feature Flags
- `quick_reorder_enabled` — Master toggle
- `quick_reorder_suggestions` — Alternative suggestions

### Rollback Plan
If critical issues discovered:
1. Disable feature flag
2. Notify support team
3. Communicate to affected users
4. Post-mortem within 48 hours

### Success Criteria for GA
- [ ] No P0 bugs in beta
- [ ] NPS neutral or positive
- [ ] Performance targets met
- [ ] Support ticket volume stable
```

## Best Practices

### Do
- Lead with the problem, not the solution
- Include measurable success criteria
- Document what's out of scope explicitly
- Link to supporting research
- Keep it updated as decisions change

### Don't
- Prescribe technical implementation
- Include every edge case in main doc
- Skip the business justification
- Forget to include risks
- Let the PRD become stale

## Common Patterns

### PRD Sections
```
1. Executive Summary
2. Problem Definition
3. Success Metrics
4. Solution Overview
5. Scope (In/Out)
6. Requirements
7. Dependencies & Risks
8. Launch Plan
9. Appendix
```

### Priority Levels
```
P0: Must have for launch
P1: Should have, will slip launch if needed
P2: Nice to have, future consideration
```

## Output Checklist

- [ ] Executive summary captures essence
- [ ] Problem clearly defined with evidence
- [ ] Success metrics are measurable
- [ ] Solution overview with features
- [ ] Scope explicitly defined (in/out)
- [ ] Functional requirements prioritized
- [ ] Dependencies and risks documented
- [ ] Launch plan with phases
- [ ] Open questions tracked
- [ ] Stakeholder review scheduled

---

**This skill creates comprehensive PRDs that align teams, enable planning, and serve as the source of truth throughout product development.**
