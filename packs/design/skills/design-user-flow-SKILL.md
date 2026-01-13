# Design User Flow Skill

## Description

You MUST use this skill before creating user flows, journey maps, or flow diagrams. This applies to task flows, user journeys, and process documentation.

---

## Purpose

Create complete, actionable user flow documentation that:
- Maps all user paths through a feature
- Identifies decision points and branches
- Documents happy and error paths
- Informs screen design requirements
- Enables development planning

## When to Use

- Starting new feature design
- Documenting existing flows
- Planning user onboarding
- Mapping complex multi-step processes

## Prerequisites

- User goals and tasks understood
- Entry and exit points identified
- Key decision points known
- Stakeholder alignment on scope

## Process

### Step 1: Define Flow Scope

Document the boundaries:

```markdown
## Flow: Checkout Process

### Scope
- Start: Cart review
- End: Order confirmation
- Included: Payment, shipping, order review
- Excluded: Returns, account creation

### User Goal
Complete purchase quickly and confidently

### Entry Points
1. "Checkout" button from cart
2. "Buy Now" from product page
3. Deep link from abandoned cart email

### Exit Points
- Success: Order confirmation
- Abandon: Close browser, navigation away
- Error: Payment failure (retry or exit)
```

### Step 2: Identify User Tasks

Break down the process:

```markdown
## User Tasks

### Primary Tasks
1. Review cart contents
2. Enter shipping address
3. Select shipping method
4. Enter payment information
5. Review order
6. Place order

### Secondary Tasks
- Apply discount code
- Save address for future
- Choose gift wrapping
- Add gift message

### Decision Points
- Guest checkout vs. sign in
- Standard vs. express shipping
- Credit card vs. PayPal
- Edit cart vs. continue
```

### Step 3: Create Flow Diagram

Document the flow visually:

```markdown
## Flow Diagram

### Notation
- ▢ Screen/Page
- ◇ Decision point
- → Action/Navigation
- ⊗ End point

### Happy Path
```
[Cart]
   │
   ▼ [Checkout]
   │
   ◇ Logged in?
   │      │
   No     Yes
   │      │
   ▼      ▼
[Login/Guest] ──▶ [Shipping Address]
                        │
                        ▼ [Continue]
                        │
                  [Shipping Method]
                        │
                        ▼ [Continue]
                        │
                  [Payment]
                        │
                        ▼ [Continue]
                        │
                  [Order Review]
                        │
                        ▼ [Place Order]
                        │
                  ⊗ [Confirmation]
```

### Alternative Paths

**Path: Guest Checkout**
```
[Login/Guest] ──▶ [Email Entry] ──▶ [Shipping Address]
```

**Path: Payment Failure**
```
[Payment] ──▶ [Error] ──▶ [Retry Payment] or [Exit]
```

**Path: Edit Cart**
```
[Order Review] ──▶ [Edit Cart] ──▶ [Cart] ──▶ [Restart Flow]
```
```

### Step 4: Document Each Step

Detail every screen/state:

```markdown
## Step Details

### Step 1: Cart Review
| Attribute | Value |
|-----------|-------|
| Screen | Cart page |
| Purpose | Verify items before checkout |
| Key actions | Checkout, Update quantity, Remove item |
| Data needed | Cart items, prices, totals |
| Validations | Minimum order amount |
| Error states | Item out of stock, price changed |
| Next step | Checkout (login or shipping) |

### Step 2: Shipping Address
| Attribute | Value |
|-----------|-------|
| Screen | Shipping form |
| Purpose | Collect delivery address |
| Key actions | Enter address, Select saved address |
| Data needed | Saved addresses (if logged in) |
| Validations | Required fields, address verification |
| Error states | Invalid address, undeliverable area |
| Next step | Shipping method |
```

### Step 5: Map Data Requirements

Document data flow:

```markdown
## Data Flow

### Data Collected
| Step | Data | Persisted |
|------|------|-----------|
| Cart | Items, quantities | Session |
| Shipping | Name, address, phone | Account (optional) |
| Shipping | Method selection | Order |
| Payment | Card/PayPal details | Payment processor |
| Review | Final confirmation | Order record |

### Data Displayed
| Step | Data Source |
|------|-------------|
| Cart | Cart API |
| Shipping | Address API, user profile |
| Payment | Saved payment methods |
| Review | Aggregated from previous steps |
| Confirmation | Order API response |
```

### Step 6: Identify Error Paths

Document failure scenarios:

```markdown
## Error Paths

### Cart Errors
| Error | Trigger | Recovery |
|-------|---------|----------|
| Item out of stock | Inventory check | Remove item, suggest alternative |
| Price changed | Price check | Update cart, notify user |
| Cart expired | Session timeout | Restore or re-add items |

### Checkout Errors
| Error | Trigger | Recovery |
|-------|---------|----------|
| Invalid address | Validation | Show field errors, suggest fix |
| Payment declined | Payment processor | Retry, try different method |
| Session expired | Timeout | Re-authenticate, preserve data |
| Server error | System failure | Retry, contact support |
```

### Step 7: Create Screen Inventory

List required screens:

```markdown
## Screen Inventory

### Required Screens
1. Cart (existing, may need updates)
2. Login/Guest choice
3. Guest email entry
4. Shipping address form
5. Shipping method selection
6. Payment form
7. Order review
8. Order confirmation
9. Payment error
10. General error

### Modal/Overlays
- Address validation suggestion
- Payment method selector
- Edit item quantity

### Empty/Edge States
- Empty cart
- No shipping options available
- No saved addresses
```

## Best Practices

### Do
- Start with the happy path, then add branches
- Include all error and edge cases
- Document data requirements at each step
- Consider returning users differently
- Validate with stakeholders before design

### Don't
- Skip error states
- Ignore edge cases (empty cart, etc.)
- Forget about mobile differences
- Design screens without flow context
- Assume linear-only navigation

## Common Patterns

### Linear Flow
```
Step 1 → Step 2 → Step 3 → Complete
Best for: Onboarding, simple forms
```

### Branching Flow
```
Start → Decision → Path A or Path B → Converge → End
Best for: Role-based flows, conditional features
```

### Hub and Spoke
```
Dashboard ↔ Feature A
          ↔ Feature B
          ↔ Feature C
Best for: Settings, multi-feature apps
```

### Wizard with Back
```
Step 1 ↔ Step 2 ↔ Step 3 → Complete
Best for: Complex forms, checkout
```

## Output Checklist

- [ ] Flow scope and boundaries defined
- [ ] User tasks and goals documented
- [ ] Flow diagram created (visual)
- [ ] Each step detailed with attributes
- [ ] Decision points identified
- [ ] Error paths documented
- [ ] Data requirements mapped
- [ ] Screen inventory created
- [ ] Edge cases considered
- [ ] Stakeholder review complete

---

**This skill creates comprehensive user flow documentation that drives informed screen design and enables accurate development planning.**
