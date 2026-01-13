# PM Roadmap Skill

## Description

You MUST use this skill before creating or updating product roadmaps. This applies to quarterly roadmaps, annual plans, and feature timelines.

---

## Purpose

Create strategic roadmaps that:
- Communicate product direction
- Align stakeholders on priorities
- Enable resource planning
- Balance short and long-term goals
- Remain flexible to change

## When to Use

- Quarterly planning cycles
- Annual strategy setting
- Stakeholder alignment
- Resource allocation discussions

## Prerequisites

- Product strategy defined
- Key initiatives identified
- Dependencies understood
- Resource constraints known

## Process

### Step 1: Define Roadmap Context

Set the frame:

```markdown
## Roadmap Context

### Timeframe
Q1-Q2 2024 (6 months)

### Product Area
E-commerce: Order Experience

### Strategic Pillars
1. Reduce friction in repeat purchases
2. Improve order visibility and tracking
3. Enable proactive communication

### Audience
- Executive leadership
- Engineering and design teams
- Customer success
- Sales and marketing

### Format
Theme-based with time horizons (Now, Next, Later)
```

### Step 2: Identify Key Initiatives

List major work:

```markdown
## Key Initiatives

### Now (This Quarter - Q1)
| Initiative | Goal | Size | Owner |
|------------|------|------|-------|
| Quick Reorder | Reduce repeat purchase time by 80% | Large | @pm1 |
| Order Status Redesign | Improve tracking clarity | Medium | @pm1 |
| Shipping Notifications | Proactive SMS/push updates | Medium | @pm2 |

### Next (Next Quarter - Q2)
| Initiative | Goal | Size | Owner |
|------------|------|------|-------|
| Subscription Orders | Enable recurring purchases | Large | @pm1 |
| Returns Portal | Self-service returns | Large | @pm2 |
| Delivery Preferences | User-set delivery windows | Medium | @pm2 |

### Later (H2 2024)
| Initiative | Goal | Size | Owner |
|------------|------|------|-------|
| Order Bundling | Combine orders for savings | Medium | TBD |
| Carbon Footprint | Show shipping impact | Small | TBD |
| International Expansion | EU shipping support | Large | TBD |
```

### Step 3: Map Dependencies

Show relationships:

```markdown
## Dependency Map

### Q1 Dependencies
```
Quick Reorder ──depends on──▶ Order History API (ready)
                              ▼
Order Status ──depends on──▶ Tracking Service Update (in progress)
                              ▼
Shipping Notifications ──depends on──▶ Notification Platform (Q1)
```

### Cross-Team Dependencies
| Initiative | Depends On | Team | Status |
|------------|------------|------|--------|
| Shipping Notifications | SMS provider integration | Platform | In progress |
| Subscription Orders | Billing system update | Payments | Planning |
| Returns Portal | Warehouse system API | Logistics | Not started |

### Risk Areas
- Notification Platform delivery in Q1 (high risk)
- Billing system update timeline (medium risk)
```

### Step 4: Create Visual Roadmap

Format for presentation:

```markdown
## Roadmap View

### Theme: Repeat Purchase Experience

#### Q1 2024
| Jan | Feb | Mar |
|-----|-----|-----|
| Quick Reorder Development | Quick Reorder Beta | Quick Reorder GA |
| Order Status Discovery | Order Status Design | Order Status Dev Start |
| Notification Platform Work | Shipping Notifications Dev | Shipping Notifications Beta |

#### Q2 2024
| Apr | May | Jun |
|-----|-----|-----|
| Order Status GA | Subscription Orders Discovery | Subscription Orders Dev |
| Shipping Notifications GA | Returns Portal Discovery | Returns Portal Dev |
| --- | Delivery Preferences | Delivery Preferences |

### Milestone View
```
Q1: Repeat purchase friction eliminated
Q2: Self-service order management complete
H2: Proactive order experience established
```
```

### Step 5: Define Success Criteria

Set measurable outcomes:

```markdown
## Success Criteria by Initiative

### Quick Reorder
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| Repeat purchase time | 180 sec | 30 sec | Q1 end |
| Repeat purchase rate | 23% | 30% | Q2 end |
| Feature adoption | N/A | 50% | Q2 end |

### Order Status Redesign
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| "Where's my order" tickets | 450/month | 200/month | Q2 end |
| Order tracking page views | 2.1/order | 1.5/order | Q2 end |
| Tracking satisfaction | 3.2/5 | 4.2/5 | Q2 end |

### Shipping Notifications
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| Notification opt-in rate | N/A | 65% | Q2 end |
| Missed delivery rate | 12% | 6% | Q2 end |
| Support tickets (shipping) | 280/month | 150/month | Q2 end |
```

### Step 6: Document Trade-offs

Explain decisions:

```markdown
## Trade-off Decisions

### What We're Prioritizing
| Decision | Rationale |
|----------|-----------|
| Reorder over Subscriptions | Higher impact, lower complexity |
| Mobile-first | 75% of repeat purchases on mobile |
| Notifications before Returns | Proactive > reactive |

### What We're Deferring
| Initiative | Reason | Revisit |
|------------|--------|---------|
| Subscription Orders | Billing system not ready | Q2 |
| Order Bundling | Lower priority, dependencies | H2 |
| International | Requires legal/compliance work | H2 |

### What We're Saying No To
| Request | Reason |
|---------|--------|
| Order editing after placement | Warehouse system limitation |
| Same-day delivery | Not economically viable |
| Gift wrapping | Low demand, high complexity |
```

### Step 7: Plan for Change

Build in flexibility:

```markdown
## Roadmap Flexibility

### Review Cadence
- Weekly: Progress against milestones
- Monthly: Roadmap health check
- Quarterly: Full roadmap refresh

### Change Triggers
| Trigger | Response |
|---------|----------|
| Major outage | Pause feature work, triage |
| Competitor launch | Evaluate reprioritization |
| Resource change | Adjust scope or timeline |
| Metric miss | Investigate, potentially pivot |

### Confidence Levels
| Horizon | Confidence | Flexibility |
|---------|------------|-------------|
| Now (Q1) | 85% | Low - committed |
| Next (Q2) | 60% | Medium - planned |
| Later (H2) | 30% | High - directional |

### Communication Plan
| Audience | Frequency | Format |
|----------|-----------|--------|
| Exec team | Monthly | Slide deck |
| Engineering | Weekly | Stand-up reference |
| All-hands | Quarterly | Roadmap presentation |
| Customers | As shipped | Release notes |
```

## Best Practices

### Do
- Use themes, not just features
- Show outcomes, not just outputs
- Include confidence levels
- Plan for change
- Communicate regularly

### Don't
- Commit to specific dates too early
- Overload the roadmap
- Hide dependencies
- Ignore resource constraints
- Set and forget

## Common Patterns

### Roadmap Formats
```
Timeline: Gantt-style with dates
Now/Next/Later: Horizon-based
Theme-based: Grouped by strategic pillar
Kanban: Flow-based, no dates
```

### Time Horizons
```
Now: This quarter (high confidence)
Next: Next quarter (medium confidence)
Later: 6+ months (low confidence)
```

### Sizing Shorthand
```
Small: 1-2 sprints, 1-2 engineers
Medium: 3-4 sprints, 2-3 engineers
Large: 5+ sprints, 3+ engineers
```

## Output Checklist

- [ ] Roadmap context and timeframe set
- [ ] Key initiatives identified with goals
- [ ] Initiatives prioritized across horizons
- [ ] Dependencies mapped
- [ ] Visual roadmap created
- [ ] Success criteria defined
- [ ] Trade-offs documented
- [ ] Flexibility and review process planned
- [ ] Stakeholder communication scheduled
- [ ] Roadmap shared with appropriate audience

---

**This skill creates strategic roadmaps that communicate direction, enable planning, and remain adaptable to change.**
