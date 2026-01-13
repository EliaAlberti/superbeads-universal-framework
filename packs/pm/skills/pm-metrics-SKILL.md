# PM Metrics Skill

## Description

You MUST use this skill before defining product metrics, KPIs, or OKRs. This applies to success metrics, health metrics, and measurement frameworks.

---

## Purpose

Define actionable metrics that:
- Measure what matters
- Enable data-driven decisions
- Track product health
- Align teams on goals
- Drive improvement

## When to Use

- Defining feature success metrics
- Setting OKRs
- Creating dashboards
- Establishing product health checks

## Prerequisites

- Product goals understood
- Data infrastructure available
- Baseline measurements accessible
- Stakeholder alignment on priorities

## Process

### Step 1: Identify Metric Objectives

Define what to measure:

```markdown
## Metric Framework

### Product Area
E-commerce: Order Experience

### Metric Objectives
1. **Understand behavior**: How users interact with ordering
2. **Measure success**: Are we achieving our goals?
3. **Monitor health**: Is the system performing well?
4. **Drive action**: What should we improve?

### Metric Categories
- Input metrics (actions users take)
- Output metrics (results we achieve)
- Health metrics (system performance)
- Leading indicators (predict future outcomes)
- Lagging indicators (measure past results)
```

### Step 2: Define North Star Metric

Identify the key measure:

```markdown
## North Star Metric

### Metric
**Weekly Repeat Orders**

### Definition
Number of orders placed by customers who have ordered before, measured weekly

### Formula
```
Weekly Repeat Orders = COUNT(orders) WHERE customer.order_count > 1
                       AND order.date IN last_7_days
```

### Why This Metric
- Directly tied to revenue growth
- Captures retention and satisfaction
- Actionable by product decisions
- Leading indicator of LTV

### Current State
| Period | Value | Trend |
|--------|-------|-------|
| Last week | 12,450 | ↑ 3% |
| 4-week avg | 11,800 | ↑ 5% |
| YoY | 10,200 | ↑ 22% |

### Target
**15,000 weekly repeat orders by Q2 end** (+25%)
```

### Step 3: Create Metrics Hierarchy

Build supporting metrics:

```markdown
## Metrics Hierarchy

### Level 1: North Star
Weekly Repeat Orders

### Level 2: Primary Drivers
| Metric | Definition | Relationship |
|--------|------------|--------------|
| Repeat purchase rate | % of customers who order again | Conversion |
| Repeat order frequency | Orders per repeat customer per month | Engagement |
| Repeat customer base | Total customers with 2+ orders | Pool size |

### Level 3: Feature Metrics
| Metric | Definition | Impacts |
|--------|------------|---------|
| Quick Reorder adoption | % orders using reorder | Repeat rate |
| Reorder time | Seconds to complete reorder | Friction |
| Cart abandonment (repeat) | % abandoned by repeat users | Conversion |

### Level 4: Health Metrics
| Metric | Definition | Threshold |
|--------|------------|-----------|
| Order success rate | % orders completed without error | > 99% |
| Checkout latency | P95 checkout page load | < 2s |
| Payment failure rate | % failed payment attempts | < 3% |
```

### Step 4: Write Metric Specifications

Document each metric:

```markdown
## Metric Specification: Repeat Purchase Rate

### Definition
Percentage of customers with at least one previous order who place another order within a given period

### Formula
```
Repeat Purchase Rate = (Customers with new order this month
                        AND had previous order)
                       /
                       (All customers with at least 1 previous order
                        active in last 90 days)
                       × 100
```

### Data Sources
| Source | Table | Fields |
|--------|-------|--------|
| Orders DB | orders | customer_id, order_date, order_id |
| Customers DB | customers | customer_id, first_order_date |

### Filters
- Exclude: Canceled orders, internal test users
- Include: All payment methods, all platforms

### Dimensions
| Dimension | Values |
|-----------|--------|
| Platform | iOS, Android, Web |
| Customer tenure | New (<90d), Established (90d-1yr), Loyal (1yr+) |
| Product category | Electronics, Home, Fashion, etc. |

### Refresh Frequency
- Real-time: Not available
- Daily: Yes, updated at 6 AM UTC
- Monthly: Aggregated on 1st of month

### Owner
@pm-analytics
```

### Step 5: Set Targets with OKRs

Create goal framework:

```markdown
## OKR Framework

### Objective
Become the easiest place to repurchase products

### Key Results

#### KR1: Increase repeat purchase rate
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| Repeat purchase rate | 23% | 30% | Q2 end |

**Milestones:**
- Q1: 25% (Quick Reorder launch)
- Q2: 30% (Subscription + notifications)

#### KR2: Reduce time to repurchase
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| Avg reorder time | 180 sec | 45 sec | Q1 end |

**Milestones:**
- Jan: 120 sec (flow optimization)
- Feb: 60 sec (Quick Reorder beta)
- Mar: 45 sec (Quick Reorder GA)

#### KR3: Increase repeat order frequency
| Metric | Baseline | Target | Timeline |
|--------|----------|--------|----------|
| Orders per customer/month | 1.3 | 1.6 | Q2 end |

**Milestones:**
- Q1: 1.4 (reorder + notifications)
- Q2: 1.6 (subscriptions live)

### Confidence
| KR | Confidence | Notes |
|----|------------|-------|
| KR1 | 70% | Depends on feature adoption |
| KR2 | 85% | Technical, in our control |
| KR3 | 50% | Requires behavior change |
```

### Step 6: Design Measurement Plan

Ensure data collection:

```markdown
## Measurement Plan

### Event Tracking Required

#### Quick Reorder Events
| Event | Trigger | Properties |
|-------|---------|------------|
| reorder_button_viewed | Button rendered | order_id, position |
| reorder_button_clicked | Button tapped | order_id, item_count |
| reorder_modal_opened | Modal displayed | order_id |
| reorder_item_modified | Qty changed/removed | item_id, action |
| reorder_confirmed | Add to cart tapped | order_id, items, total |
| reorder_completed | Checkout complete | order_id, revenue |

#### Funnel Definition
```
1. reorder_button_viewed
   ↓ (Click rate)
2. reorder_button_clicked
   ↓ (Modal open rate)
3. reorder_modal_opened
   ↓ (Confirmation rate)
4. reorder_confirmed
   ↓ (Checkout rate)
5. reorder_completed
```

### Dashboard Requirements
| Dashboard | Metrics | Audience | Refresh |
|-----------|---------|----------|---------|
| Executive | North star, KRs | Leadership | Weekly |
| Product | Full funnel, segments | PM, Design | Daily |
| Engineering | Health, errors | Engineering | Real-time |

### Alerting
| Alert | Threshold | Response |
|-------|-----------|----------|
| Repeat rate drop | > 5% week/week | Investigate immediately |
| Reorder error rate | > 1% | Page oncall |
| Checkout latency | > 3s P95 | Notify performance team |
```

### Step 7: Document Metric Governance

Establish ownership:

```markdown
## Metric Governance

### Ownership
| Metric Category | Owner | Reviewer |
|-----------------|-------|----------|
| North star | VP Product | CEO |
| Product metrics | PM | VP Product |
| Health metrics | Engineering | PM |
| Experiment metrics | Data Science | PM |

### Review Cadence
| Review | Frequency | Participants |
|--------|-----------|--------------|
| Metrics standup | Daily | PM, Eng lead |
| KR review | Weekly | PM, Design, Eng |
| OKR check-in | Monthly | Leadership |
| Metric health audit | Quarterly | Data, PM, Eng |

### Change Process
To modify metric definitions:
1. Propose change with rationale
2. Review impact on historical data
3. Data science approval
4. Update documentation
5. Communicate to stakeholders
6. Implement with versioning

### Data Quality
| Check | Frequency | Owner |
|-------|-----------|-------|
| Missing data | Daily | Data Eng |
| Metric accuracy | Weekly | Data Science |
| Definition alignment | Monthly | PM |
```

## Best Practices

### Do
- Start with outcomes, not outputs
- Define metrics before building features
- Include leading AND lagging indicators
- Set specific, measurable targets
- Review and iterate on metrics

### Don't
- Measure everything (focus on what matters)
- Set vanity metrics
- Ignore data quality
- Change definitions frequently
- Forget to document

## Common Patterns

### Metric Types
```
Input: Actions taken (clicks, views, submissions)
Output: Results achieved (conversions, revenue)
Leading: Predict future outcomes (engagement)
Lagging: Measure past results (revenue, churn)
```

### AARRR Framework
```
Acquisition: How users find us
Activation: First value experience
Retention: Coming back
Revenue: Monetization
Referral: Bringing others
```

### Goal Setting (SMART)
```
Specific: Clear definition
Measurable: Quantifiable
Achievable: Realistic
Relevant: Aligned to strategy
Time-bound: Has deadline
```

## Output Checklist

- [ ] Metric objectives defined
- [ ] North Star metric identified
- [ ] Metrics hierarchy created
- [ ] Each metric specified (formula, source, dimensions)
- [ ] OKRs set with targets
- [ ] Measurement plan documented
- [ ] Event tracking specified
- [ ] Dashboards designed
- [ ] Alerting configured
- [ ] Governance established

---

**This skill creates comprehensive metrics frameworks that measure what matters, enable decisions, and drive product improvement.**
