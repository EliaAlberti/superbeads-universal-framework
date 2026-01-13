# Design Review Skill

## Description

You MUST use this skill before conducting or requesting design reviews. This applies to formal design critiques, peer reviews, and stakeholder presentations.

---

## Purpose

Conduct effective design reviews that:
- Validate design decisions against requirements
- Catch issues before development
- Gather actionable feedback
- Build team alignment
- Improve design quality

## When to Use

- Requesting peer review of designs
- Conducting design critiques
- Presenting to stakeholders
- Final review before handoff

## Prerequisites

- Design work ready for review
- Review criteria established
- Reviewers identified
- Context documentation prepared

## Process

### Step 1: Prepare for Review

Set up the review context:

```markdown
## Review Setup

### Design Under Review
- Component: Primary Button
- Screens: Login, Signup, Checkout
- Prototype: [Figma link]

### Review Type
- [ ] Peer design review
- [ ] Stakeholder review
- [ ] Accessibility review
- [ ] Final handoff review

### Review Goals
1. Validate button states are complete
2. Verify accessibility compliance
3. Confirm alignment with design system
4. Get sign-off for development

### Time Allocated
30 minutes

### Reviewers
- @designer2 (peer)
- @a11y-specialist (accessibility)
```

### Step 2: Create Review Checklist

Define what to evaluate:

```markdown
## Review Checklist

### Completeness
- [ ] All required states designed
- [ ] All variants included
- [ ] Dark mode variant present
- [ ] Responsive breakpoints addressed
- [ ] Edge cases considered

### Consistency
- [ ] Uses design system tokens
- [ ] Follows established patterns
- [ ] Matches similar components
- [ ] Naming conventions followed

### Accessibility
- [ ] Color contrast passes (4.5:1 minimum)
- [ ] Touch targets meet 44px minimum
- [ ] Focus states defined
- [ ] Screen reader considerations noted

### Usability
- [ ] Clear visual hierarchy
- [ ] Obvious interactive elements
- [ ] Feedback for all actions
- [ ] Error states helpful

### Documentation
- [ ] Specifications complete
- [ ] Handoff notes written
- [ ] Assets exported
```

### Step 3: Gather Context for Reviewers

Provide necessary background:

```markdown
## Review Context

### Problem Being Solved
Users were confused by the previous button styling which didn't
clearly indicate clickability or provide feedback on interaction.

### Design Decisions Made
1. Increased contrast for better visibility
2. Added clear hover and active states
3. Included loading state for async actions
4. Created icon-only variant for toolbars

### Constraints
- Must work in existing codebase
- Cannot add new dependencies
- Timeline: Ship by end of sprint

### Open Questions
1. Is the disabled state visible enough?
2. Should loading spinner be centered or left-aligned?
3. Ghost button contrast sufficient?
```

### Step 4: Conduct the Review

Facilitate effective feedback:

```markdown
## Review Structure

### 1. Presentation (5 min)
- Walk through the design
- Explain key decisions
- Highlight areas needing feedback

### 2. Clarifying Questions (5 min)
- Reviewers ask about requirements, constraints
- Designer provides additional context
- Avoid solutioning

### 3. Feedback Round (15 min)
- Each reviewer provides observations
- Categorize: Must fix | Should consider | Nice to have
- Capture all feedback

### 4. Discussion (5 min)
- Discuss any disagreements
- Prioritize issues
- Agree on next steps
```

### Step 5: Document Feedback

Capture actionable feedback:

```markdown
## Feedback Captured

### Must Fix (Blocking)
| Issue | Feedback | From | Resolution |
|-------|----------|------|------------|
| Disabled contrast | 2.1:1 ratio fails WCAG | @a11y | Use neutral-400 instead |
| Missing focus | Ghost button needs focus ring | @a11y | Add 2px outline |

### Should Consider (Important)
| Issue | Feedback | From | Resolution |
|-------|----------|------|------------|
| Loading position | Center spinner looks better | @designer2 | Will test both |
| Icon spacing | Gap seems tight on small | @designer2 | Increase to 8px |

### Nice to Have (Optional)
| Issue | Feedback | From | Resolution |
|-------|----------|------|------------|
| Animation | Spring easing more playful | @designer2 | Consider for v2 |

### Positive Feedback
- Clear state differentiation
- Good use of design tokens
- Comprehensive documentation
```

### Step 6: Create Action Items

Plan resolution:

```markdown
## Action Items

### Immediate (Before Handoff)
- [ ] Fix disabled state contrast (@designer, today)
- [ ] Add focus ring to ghost button (@designer, today)
- [ ] Update specifications document (@designer, today)

### Before Next Review
- [ ] Test centered vs. left spinner (@designer, tomorrow)
- [ ] Adjust icon spacing for small size (@designer, tomorrow)

### Future Consideration
- [ ] Explore spring animation for v2 (backlog)

### Next Steps
1. Implement blocking fixes
2. Update Figma file
3. Schedule follow-up review (30 min tomorrow)
4. After approval, proceed to handoff
```

### Step 7: Close the Loop

Complete the review cycle:

```markdown
## Review Resolution

### Changes Made
- Disabled text changed to neutral-400 (now 4.1:1)
- Added 2px focus ring to ghost button
- Icon gap increased to 8px on small variant
- Spinner centered (tested, team preferred)

### Final Approval
- [x] @designer2 - Approved
- [x] @a11y-specialist - Approved
- [x] @stakeholder - Approved

### Ready for Handoff
Design approved on [date]. Proceeding to development handoff.
```

## Best Practices

### Do
- Prepare context in advance
- Use structured checklists
- Categorize feedback by priority
- Document all feedback, even disagreements
- Close the loop with follow-up

### Don't
- Review without criteria
- Take feedback personally
- Skip accessibility review
- Leave feedback unresolved
- Forget to document decisions

## Common Patterns

### Feedback Categories
```
Must Fix: Blocks handoff, accessibility failure
Should Consider: Important but not blocking
Nice to Have: Future enhancement
Out of Scope: Note for later, not this review
```

### Review Types
```
Peer Review: Design quality, patterns
Stakeholder: Business alignment, scope
Accessibility: WCAG compliance
Final: Handoff readiness
```

### Critique Frameworks
```
I like...: What works well
I wish...: What could improve
What if...: Alternative approaches
```

## Output Checklist

- [ ] Review setup documented
- [ ] Checklist created for evaluation
- [ ] Context provided to reviewers
- [ ] Review conducted with structure
- [ ] All feedback documented
- [ ] Feedback categorized by priority
- [ ] Action items assigned
- [ ] Changes implemented
- [ ] Follow-up review scheduled (if needed)
- [ ] Final approval recorded

---

**This skill ensures effective design reviews that catch issues early, gather actionable feedback, and build team alignment before development.**
