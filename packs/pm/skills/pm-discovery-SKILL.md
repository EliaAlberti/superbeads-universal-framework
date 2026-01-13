# PM Discovery Skill

## Description

You MUST use this skill before conducting user research or problem validation. This applies to user interviews, surveys, and discovery activities.

---

## Purpose

Conduct effective discovery that:
- Validates problem assumptions
- Uncovers user needs and pain points
- Generates actionable insights
- Reduces risk before building
- Informs product decisions

## When to Use

- Starting new product initiatives
- Validating feature assumptions
- Understanding user behavior
- Exploring market opportunities

## Prerequisites

- Research questions defined
- Access to users/customers
- Time and resources allocated
- Stakeholder buy-in on approach

## Process

### Step 1: Define Research Objectives

Set clear goals:

```markdown
## Research Objectives

### Business Context
We're considering adding a "Quick Reorder" feature. Before investing
engineering resources, we need to validate that repeat purchasing friction
is a real, significant problem.

### Research Questions
1. **Problem validation**: Is repeat purchasing actually painful?
2. **Frequency**: How often do users repurchase the same items?
3. **Current behavior**: How do users currently handle repeat purchases?
4. **Alternatives**: What workarounds exist?
5. **Willingness**: Would users adopt a reorder feature?

### Success Criteria
| Question | Signal for "Go" | Signal for "No Go" |
|----------|-----------------|-------------------|
| Problem validation | 7/10+ cite friction | < 4/10 cite friction |
| Frequency | 50%+ buy same items | < 30% buy same items |
| Willingness | 6/10+ would use | < 4/10 would use |

### Out of Scope
- Feature-specific feedback (too early)
- Pricing research
- Competitive deep-dive
```

### Step 2: Design Research Plan

Structure the approach:

```markdown
## Research Plan

### Methodology
| Method | Sample | Purpose |
|--------|--------|---------|
| User interviews | 12-15 | Deep understanding of behavior |
| Survey | 500+ | Quantitative validation |
| Analytics review | All users | Behavioral patterns |

### Timeline
| Week | Activity |
|------|----------|
| Week 1 | Recruit participants, design interview guide |
| Week 2 | Conduct interviews (6-8) |
| Week 3 | Conduct interviews (6-8), launch survey |
| Week 4 | Analyze, synthesize, present |

### Participants (Interviews)
| Criteria | Target |
|----------|--------|
| Order history | 3+ orders in past 6 months |
| Recency | Ordered in past 30 days |
| Mix | 50% power users, 50% regular |
| Platform | 60% mobile, 40% desktop |

### Recruitment
- Source: Existing customer panel
- Incentive: $50 gift card
- Scheduling: Calendly link, 45-min slots
```

### Step 3: Create Interview Guide

Prepare for conversations:

```markdown
## Interview Guide

### Introduction (5 min)
"Thanks for joining. I'm [name], a product manager at [company].
I'm researching how people shop for products they buy regularly.
There are no right or wrong answers—I'm just trying to understand your experience.

This will take about 45 minutes. I'll record for note-taking only,
and your responses are confidential. Any questions before we start?"

### Warm-Up (5 min)
1. Tell me a bit about yourself. How often do you shop online?
2. What types of products do you typically buy from us?

### Exploration (25 min)

**Current Behavior**
3. Walk me through the last time you bought something you'd purchased before.
   - Probe: How did you find the product?
   - Probe: How long did it take?
   - Probe: Any frustrations?

4. How often do you repurchase the same products?
   - Probe: What products?
   - Probe: What triggers a repurchase?

5. Have you ever wanted to buy something again but didn't?
   - Probe: Why not?
   - Probe: What happened instead?

**Pain Points**
6. What's the most frustrating part of buying something again?
   - Probe: Can you give me a specific example?
   - Probe: How did that make you feel?

7. How do you currently keep track of products you want to rebuy?
   - Probe: Any workarounds or tricks?

**Alternatives**
8. Have you used features like "Buy Again" on other sites?
   - Probe: What worked well?
   - Probe: What didn't?

### Concept Reaction (10 min)
"We're exploring making it easier to reorder. Imagine you could see your
past orders and reorder everything with one tap."

9. How would that fit into how you shop?
   - Probe: When would you use it?
   - Probe: When wouldn't you?

10. What would make this really useful for you?
    - Probe: Any concerns?

### Wrap-Up (5 min)
11. Is there anything else about repurchasing you'd like to share?
12. Any questions for me?

"Thank you so much. Your input is incredibly valuable."

### Post-Interview
- Send thank you + incentive within 24 hours
- Complete notes within 2 hours
- Tag themes and quotes
```

### Step 4: Conduct Research

Execute systematically:

```markdown
## Research Execution

### Interview Notes Template

**Participant:** P01
**Date:** January 15, 2024
**Duration:** 42 minutes
**Recorder:** [Name]

#### Background
- 35F, busy parent, orders 2-3x/month
- Primary: household supplies, kids items
- Mostly mobile shopping

#### Key Observations
| Theme | Quote | Insight |
|-------|-------|---------|
| Friction | "I know what I want but spend 10 minutes finding it again" | Search is not optimized for rebuy |
| Workaround | "I take screenshots of products I like" | Users create manual solutions |
| Frequency | "Baby wipes, same ones, every 3 weeks" | High-frequency rebuy categories |

#### Journey Mapping
1. Realizes need (runs out of product)
2. Opens app
3. Tries to remember product name
4. Searches (often wrong keywords)
5. Browses results
6. Recognizes product
7. Adds to cart
8. Completes purchase

**Pain points:** Steps 3-6 (finding the product)

#### Reaction to Concept
- Very positive: "That would save me so much time"
- Concern: "Would it remember the right quantities?"
- Would use: "Definitely, especially for regular stuff"

#### Quotables
> "I wish I could just push a button and get my usual order"

> "The hardest part is remembering what I bought before"
```

### Step 5: Analyze Findings

Synthesize insights:

```markdown
## Research Synthesis

### Participants
- 12 interviews completed
- Demographics: 7F, 5M, ages 28-52
- Order frequency: 2-6 orders/month

### Key Findings

#### Finding 1: Problem is Real and Significant
**Evidence:** 10/12 participants cited significant friction in repeat purchases
**Quotes:**
- "It's annoying to search for things I already know I want"
- "I've given up and just bought from Amazon because it was easier"

**Insight:** Users waste 3-10 minutes per repurchase finding known products

#### Finding 2: High Repeat Purchase Behavior
**Evidence:**
- 8/12 buy the same products regularly
- Average: 40% of orders are repeat items
- Categories: consumables, household, personal care

**Insight:** Significant opportunity—almost half of orders are repeats

#### Finding 3: Workarounds Indicate Demand
**Evidence:**
- 6/12 have created workarounds (screenshots, notes, bookmarks)
- 3/12 use competitor "buy again" features

**Insight:** Users are solving this problem manually—high demand signal

#### Finding 4: Concept Resonates Strongly
**Evidence:**
- 11/12 would use a reorder feature
- Average enthusiasm: 8/10
- Most requested: One-tap reorder, quantity memory

**Insight:** Strong concept validation

### Themes
| Theme | Frequency | Strength |
|-------|-----------|----------|
| Finding products is hard | 10/12 | Strong |
| Repeat purchases common | 8/12 | Strong |
| Would use reorder | 11/12 | Very Strong |
| Quantity memory important | 7/12 | Medium |
| Mobile-first behavior | 9/12 | Strong |

### Recommendations
1. **Proceed with Quick Reorder** - Strong problem/solution validation
2. **Prioritize mobile** - 75% primary platform
3. **Include quantity memory** - Frequently mentioned need
4. **Surface in multiple places** - Order history + homepage
```

### Step 6: Share Findings

Communicate results:

```markdown
## Research Readout

### Presentation Outline

**Slide 1: Research Overview**
- Objective: Validate repeat purchase pain point
- Method: 12 interviews + 523 survey responses
- Timeline: 4 weeks

**Slide 2: Key Findings**
1. Problem is real: 10/12 cite friction
2. Behavior exists: 40% orders are repeats
3. Demand is strong: 11/12 would use reorder

**Slide 3: User Journey Pain Points**
[Visual of journey with pain points highlighted]
Biggest friction: Finding previously purchased products

**Slide 4: Quantitative Validation**
Survey results:
- 67% often rebuy same products
- 54% frustrated by repeat purchase process
- 78% would use one-tap reorder

**Slide 5: User Quotes**
[Compelling quotes with photos/avatars]

**Slide 6: Recommendations**
1. ✅ Build Quick Reorder (strong validation)
2. 📱 Mobile-first design
3. 🔢 Include quantity memory
4. 📍 Multiple entry points

**Slide 7: Next Steps**
- Share findings with Design (this week)
- Begin PRD (next week)
- Target MVP: Q1

### Documentation
- Full report: [link to document]
- Interview recordings: [link to folder]
- Survey raw data: [link to spreadsheet]
- Synthesis board: [link to Miro/FigJam]
```

## Best Practices

### Do
- Define objectives before recruiting
- Use open-ended questions
- Listen more than talk
- Document everything
- Synthesize across participants

### Don't
- Lead the witness
- Confirm your biases
- Skip synthesis
- Hide negative findings
- Research without acting

## Common Patterns

### Interview Question Types
```
Behavior: What do you do?
Belief: What do you think?
Feeling: How did that make you feel?
Probe: Tell me more about that.
```

### Synthesis Approaches
```
Affinity mapping: Group related observations
Journey mapping: Visualize user path
Jobs-to-be-done: Frame as user jobs
Empathy mapping: Think, feel, do, say
```

### Sample Size Guidelines
```
Interviews: 8-12 for patterns
Surveys: 100+ for significance
Usability: 5-8 for major issues
A/B tests: Calculator-based
```

## Output Checklist

- [ ] Research objectives defined
- [ ] Research plan created
- [ ] Participants recruited
- [ ] Interview guide prepared
- [ ] Research conducted systematically
- [ ] Notes taken and organized
- [ ] Findings synthesized
- [ ] Themes identified
- [ ] Recommendations made
- [ ] Findings shared with stakeholders

---

**This skill enables effective user discovery that validates assumptions, uncovers needs, and informs confident product decisions.**
