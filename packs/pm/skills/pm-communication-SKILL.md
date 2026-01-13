# PM Communication Skill

## Description

You MUST use this skill before creating stakeholder communications. This applies to status updates, presentations, and cross-functional alignment documents.

---

## Purpose

Create effective communications that:
- Keep stakeholders informed
- Build alignment across teams
- Surface risks and blockers
- Celebrate wins appropriately
- Drive decisions when needed

## When to Use

- Sending weekly/monthly updates
- Presenting to executives
- Aligning cross-functional teams
- Requesting decisions or resources

## Prerequisites

- Audience identified
- Key messages clear
- Data and context gathered
- Desired outcome defined

## Process

### Step 1: Define Communication Context

Set up the communication:

```markdown
## Communication Context

### Type
- [ ] Status update (informational)
- [x] Executive presentation (decision needed)
- [ ] Team alignment (coordination)
- [ ] Announcement (celebratory)

### Audience
| Stakeholder | Role | What They Care About |
|-------------|------|---------------------|
| CEO | Final decision | Business impact, risk |
| VP Eng | Resource owner | Feasibility, timeline |
| VP Sales | Revenue driver | Customer impact, timing |
| CFO | Budget owner | Cost, ROI |

### Desired Outcome
- Decision: Approve Q2 roadmap and resource allocation
- By: End of meeting
- Fallback: Identify blockers and schedule follow-up

### Timing
- Date: January Board Meeting
- Duration: 15 minutes (10 present, 5 discuss)
```

### Step 2: Structure the Message

Organize content:

```markdown
## Message Structure

### Executive Summary (TL;DR)
Q1 on track. Repeat purchase improvements showing early results (+5% in beta).
Request: Approve Q2 roadmap with 2 additional engineers for subscription feature.

### Key Messages (Rule of 3)
1. **Progress**: Quick Reorder beta exceeds targets
2. **Plan**: Q2 roadmap ready for approval
3. **Ask**: Need 2 engineers to hit subscription timeline

### Supporting Points
| Message | Evidence | So What |
|---------|----------|---------|
| Beta success | +5% repeat rate, 40% adoption | Validates approach |
| Q2 ready | PRDs complete, designs approved | Can start on schedule |
| Need resources | Current capacity = 6 month delay | Competitive pressure |
```

### Step 3: Create Status Update

Format for regular updates:

```markdown
## Weekly Status Update: Order Experience

### Week of January 15, 2024

### TL;DR
Quick Reorder beta launched to 25%. Early metrics positive. On track for GA by Feb 1.

---

### Key Metrics
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Repeat purchase rate (beta) | +3% | +5% | 🟢 |
| Reorder adoption | 30% | 42% | 🟢 |
| Cart errors | < 1% | 0.8% | 🟢 |

### Progress This Week
- ✅ Launched beta to 25% of users (target: 25%)
- ✅ Fixed critical cart merge bug
- ✅ Analytics instrumentation complete
- 🔄 Android parity in progress (80% done)

### Next Week Focus
1. Complete Android parity
2. Monitor beta metrics for GA decision
3. Begin notification integration

### Blockers
| Blocker | Impact | Owner | ETA |
|---------|--------|-------|-----|
| None | - | - | - |

### Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Inventory API latency | Low | Medium | Caching implemented |

### Asks
- None this week

---

### Detailed Updates

#### Quick Reorder (Primary)
**Status:** 🟢 On Track

Beta launched Monday to 25% of users. Key observations:
- Adoption rate 40%+ (target was 30%)
- Users completing reorder in avg 35 seconds (target: 45)
- One bug found and fixed (cart merge edge case)

Recommend proceeding to GA on Feb 1 as planned.

#### Order Status Redesign
**Status:** 🟡 At Risk

Design taking longer than expected. New approach requires additional engineering input.
- Original timeline: Design complete by Jan 19
- New timeline: Design complete by Jan 26
- Impact: 1-week delay to development start

Mitigation: Eng to join design sessions starting tomorrow.
```

### Step 4: Create Executive Presentation

Build for leadership:

```markdown
## Executive Presentation

### Slide 1: Title
**Order Experience: Q1 Progress & Q2 Plan**
Board Meeting - January 2024

---

### Slide 2: Key Takeaways
**Bottom Line Up Front**

1. ✅ Q1 on track - Quick Reorder beta exceeds targets
2. 📋 Q2 plan ready - Subscription + Returns Portal
3. 🙋 Need decision - 2 additional engineers for subscription

---

### Slide 3: Q1 Progress
**Quick Reorder: Early Win**

| Metric | Target | Actual |
|--------|--------|--------|
| Beta adoption | 30% | 42% |
| Repeat rate lift | +3% | +5% |
| Time to reorder | 45 sec | 35 sec |

*"Best beta results in 6 months" - VP Engineering*

**Timeline**
- ✅ Jan 15: Beta launch
- 📍 Feb 1: GA target (on track)

---

### Slide 4: Q2 Roadmap
**What We're Building**

| Initiative | Goal | Q2 Impact |
|------------|------|-----------|
| Subscription Orders | Recurring revenue | +$2M ARR |
| Returns Portal | Self-service | -30% support cost |
| Delivery Preferences | Customer satisfaction | +5 NPS |

**Dependencies**
- Subscription: Needs billing system update (Platform team)
- Returns: Needs warehouse API (Logistics team)

---

### Slide 5: Resource Ask
**Request: 2 Engineers for Subscription**

**Without:** 6-month delay, Q4 launch
**With:** Q3 launch, competitive parity

| Option | Timeline | Risk | Cost |
|--------|----------|------|------|
| Current | Q4 2024 | High (competitors) | $0 |
| +2 Eng | Q3 2024 | Low | $300K |

**Recommendation:** Approve 2 engineers
**ROI:** 3-month acceleration, $2M ARR at risk

---

### Slide 6: Ask & Next Steps
**Decision Needed Today**

1. Approve Q2 roadmap as presented?
2. Approve 2 additional engineers?

**If Yes:**
- Start Q3 subscription work Feb 1
- Hiring begins this week

**If Not Today:**
- Schedule follow-up by Jan 25
- Risk: 2-week delay to subscription
```

### Step 5: Handle Q&A Preparation

Anticipate questions:

```markdown
## Q&A Preparation

### Likely Questions

**Q: Why can't the current team do subscription?**
A: Current team fully committed to Quick Reorder GA (Feb), Order Status (Mar),
and Notifications (Mar). Subscription requires dedicated focus due to
billing system complexity.

**Q: What's the competitive risk of delay?**
A: Amazon launched subscriptions 2 years ago. Target launching Q2.
Every quarter we delay = 5% market share at risk.

**Q: Can we outsource instead of hiring?**
A: Considered. Billing integration requires deep system knowledge.
Contractor ramp time = 3 months. Net: Same timeline, higher risk.

**Q: What if subscription doesn't hit targets?**
A: We'll A/B test extensively. Kill criteria defined: If < 5% adoption
after 3 months, we pivot. Engineers can redeploy to other initiatives.

### Data Points to Have Ready
- Current team allocation spreadsheet
- Competitor feature comparison
- Subscription market research
- Billing system architecture
```

### Step 6: Follow Up

Close the loop:

```markdown
## Follow-Up Communication

### Meeting Summary
**Sent to:** All attendees + relevant stakeholders
**Within:** 24 hours of meeting

---

**Subject:** Order Experience Board Review - Summary & Actions

### Decisions Made
1. ✅ Q2 roadmap approved as presented
2. ✅ 2 additional engineers approved for subscription

### Action Items
| Action | Owner | Due |
|--------|-------|-----|
| Start subscription hiring | Eng Manager | Jan 22 |
| Update Q2 timeline with new capacity | PM | Jan 19 |
| Share subscription PRD with Finance | PM | Jan 22 |
| Schedule billing integration kickoff | Tech Lead | Jan 25 |

### Open Items
| Item | Status | Next Step |
|------|--------|-----------|
| Platform team dependency | Pending | PM to follow up Jan 18 |

### Next Update
Monthly review: February 15

---

*Full deck attached. Questions: reply-all or DM.*
```

## Best Practices

### Do
- Lead with the bottom line
- Know your audience
- Use data to support claims
- Be clear about asks
- Follow up promptly

### Don't
- Bury the lead
- Overwhelm with details
- Hide bad news
- Be vague about needs
- Skip the follow-up

## Common Patterns

### Status Indicators
```
🟢 On Track - No issues
🟡 At Risk - Needs attention
🔴 Blocked - Cannot proceed
⚪ Not Started - Future work
```

### Update Cadence
```
Daily: Standup notes (team)
Weekly: Status update (stakeholders)
Monthly: Business review (leadership)
Quarterly: Strategy review (executives)
```

### Executive Communication
```
1. TL;DR (one sentence)
2. Key metrics (3-5)
3. Progress (what's done)
4. Plan (what's next)
5. Ask (what you need)
```

## Output Checklist

- [ ] Audience and context defined
- [ ] Key messages identified (max 3)
- [ ] Structure appropriate to type
- [ ] Data and evidence included
- [ ] Asks clearly stated
- [ ] Q&A prepared
- [ ] Visuals/formatting clean
- [ ] Follow-up planned
- [ ] Timing appropriate
- [ ] Feedback loop established

---

**This skill creates clear, effective communications that inform stakeholders, drive decisions, and maintain alignment across teams.**
