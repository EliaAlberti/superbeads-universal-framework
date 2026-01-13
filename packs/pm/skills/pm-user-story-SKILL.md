# PM User Story Skill

## Description

You MUST use this skill before writing user stories. This applies to feature stories, bug stories, and technical stories.

---

## Purpose

Create complete, development-ready user stories that:
- Follow INVEST criteria
- Include testable acceptance criteria
- Provide clear user value
- Enable accurate estimation
- Are ready for sprint planning

## When to Use

- Creating new feature stories
- Writing bug fix stories
- Documenting technical improvements
- Breaking down epics into stories

## Prerequisites

- User persona or role identified
- Problem or need understood
- Success criteria known
- Dependencies identified

## Process

### Step 1: Identify the User

Define who benefits:

```markdown
## User Identification

### Primary User
- Persona: Returning Customer
- Role: Logged-in user with purchase history
- Context: Mobile app, browsing during commute

### User Goal
Quickly reorder previously purchased items without navigating full catalog

### Pain Points
- Current reorder takes 6+ taps
- Hard to find past orders
- No quick-add for frequent items
```

### Step 2: Write the Story Statement

Use standard format:

```markdown
## Story

**As a** returning customer
**I want to** quickly reorder items from my purchase history
**So that** I can complete repeat purchases in seconds instead of minutes
```

### Step 3: Apply INVEST Criteria

Validate the story:

```markdown
## INVEST Checklist

### Independent
- [x] Can be developed without other sprint stories
- [x] Can be tested in isolation
- [ ] Note: Requires Order History API (exists)

### Negotiable
- [x] Implementation approach flexible
- [x] No specific technical solution prescribed
- [x] Scope can be adjusted if needed

### Valuable
- [x] Clear user benefit (time savings)
- [x] Business value (increased repeat purchases)
- [x] Not a technical task disguised as story

### Estimable
- [x] Team understands the scope
- [x] Similar work done before
- [x] No major unknowns

### Small
- [x] Fits in one sprint
- [x] 3-5 story points estimated
- [x] Can be completed in 1-3 days

### Testable
- [x] Acceptance criteria defined
- [x] Can write automated tests
- [x] QA can verify manually
```

### Step 4: Write Acceptance Criteria

Use Given/When/Then format:

```markdown
## Acceptance Criteria

### AC1: View reorder button on order history
**Given** I am viewing my order history
**When** I look at any past order
**Then** I see a "Reorder" button on each order

### AC2: Reorder adds all items to cart
**Given** I am viewing a past order with 3 items
**When** I tap the "Reorder" button
**Then** all 3 items are added to my cart
**And** I see a confirmation message

### AC3: Handle out-of-stock items
**Given** a past order contains an out-of-stock item
**When** I tap "Reorder"
**Then** available items are added to cart
**And** I see a message about unavailable items
**And** I'm shown alternatives if available

### AC4: Modify quantities before adding
**Given** I tap "Reorder" on a past order
**When** the reorder modal appears
**Then** I can adjust quantities before confirming
**And** I can remove items I don't want

### AC5: Cart merge behavior
**Given** I already have items in my cart
**When** I reorder a past order
**Then** new items are added to existing cart
**And** duplicate items increase quantity
```

### Step 5: Add Story Details

Include supporting information:

```markdown
## Story Details

### Story Points
**Estimate:** 5 points

### Priority
- **RICE Score:** 12,000
- **Priority:** High
- **Sprint:** 2024-Q1-S3

### Labels
- `feature:reorder`
- `epic:order-experience`
- `platform:mobile`

### Dependencies
- **Requires:** Order History API (available)
- **Blocks:** None
- **Related:** Quick-add from favorites (future)

### Design
- **Figma:** [Link to reorder flow designs]
- **Prototype:** [Link to interactive prototype]

### Technical Notes
- Leverage existing cart merge logic
- Consider caching recent orders for performance
- Analytics: Track reorder conversion rate

### Out of Scope
- Subscription/auto-reorder (future epic)
- Desktop implementation (separate story)
- Partial reorder scheduling
```

### Step 6: Define Done

Clarify completion:

```markdown
## Definition of Done

### Development
- [ ] Feature implemented per acceptance criteria
- [ ] Unit tests written and passing
- [ ] Integration tests for cart merge
- [ ] Code reviewed and approved

### Quality
- [ ] QA tested on iOS and Android
- [ ] Accessibility verified
- [ ] Performance tested (< 2s load time)
- [ ] Edge cases validated

### Release
- [ ] Feature flag configured
- [ ] Analytics events implemented
- [ ] Documentation updated
- [ ] Demo to stakeholders complete
```

### Step 7: Link Related Artifacts

Connect to other documents:

```markdown
## Related Documents

### Product
- **PRD:** [Order Experience PRD](../prd/order-experience.md)
- **Epic:** [Order Experience Epic](../epics/order-experience.md)
- **Research:** [Reorder User Research](../research/reorder-study.md)

### Design
- **Flow:** [Reorder User Flow](../design/flows/reorder.md)
- **Screens:** [Reorder Screens](../design/screens/reorder/)
- **Components:** [Quick Action Button](../design/components/quick-action.md)

### Technical
- **API:** [Order History API Docs](../api/orders.md)
- **Architecture:** [Cart Service Architecture](../architecture/cart.md)
```

## Best Practices

### Do
- Write from the user's perspective
- Include clear acceptance criteria
- Make criteria testable
- Keep stories small and focused
- Link to design and research

### Don't
- Prescribe technical solutions
- Write vague acceptance criteria
- Combine multiple features
- Skip the "So that" clause
- Forget error and edge cases

## Common Patterns

### Story Types

**Feature Story**
```
As a [user type]
I want to [action]
So that [benefit]
```

**Bug Story**
```
As a [user type]
I expect [expected behavior]
But currently [actual behavior]
```

**Technical Story**
```
As a developer
I want to [technical improvement]
So that [technical benefit]
```

### Acceptance Criteria Patterns

**Positive Case**
```
Given [precondition]
When [action]
Then [expected result]
```

**Negative Case**
```
Given [precondition]
When [invalid action]
Then [error handling]
```

**Edge Case**
```
Given [unusual condition]
When [action]
Then [appropriate handling]
```

## Output Checklist

- [ ] User identified with context
- [ ] Story statement complete (As a/I want/So that)
- [ ] INVEST criteria validated
- [ ] 3-7 acceptance criteria in Given/When/Then
- [ ] Story points estimated
- [ ] Priority and labels assigned
- [ ] Dependencies documented
- [ ] Design links included
- [ ] Definition of Done clear
- [ ] Related artifacts linked

---

**This skill creates development-ready user stories with clear value, testable criteria, and complete context for estimation and implementation.**
