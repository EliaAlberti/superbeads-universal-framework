# PM Experiment Skill

## Description

You MUST use this skill before designing product experiments. This applies to A/B tests, feature experiments, and hypothesis validation.

---

## Purpose

Design rigorous experiments that:
- Test specific hypotheses
- Produce statistically valid results
- Minimize risk to users
- Enable data-driven decisions
- Learn quickly and iterate

## When to Use

- Validating feature assumptions
- Testing design variations
- Optimizing conversion funnels
- Measuring behavior changes

## Prerequisites

- Hypothesis formed from research
- Baseline metrics available
- Technical capability for testing
- Sample size achievable

## Process

### Step 1: Form the Hypothesis

Structure clearly:

```markdown
## Hypothesis

### Hypothesis Statement
**We believe** adding a "Quick Reorder" button to order history
**Will result in** increased repeat purchase rate
**For** returning customers with 2+ previous orders
**Because** reducing friction in repurchasing encourages more frequent orders

### Hypothesis Type
- [ ] New feature hypothesis
- [x] Optimization hypothesis
- [ ] Problem validation hypothesis

### Confidence Level
**Pre-experiment confidence:** 70%
**Based on:** User research (11/15 mentioned reorder pain), competitor analysis
```

### Step 2: Define Success Metrics

Set measurable criteria:

```markdown
## Success Metrics

### Primary Metric
| Metric | Definition | Current | Target |
|--------|------------|---------|--------|
| Repeat purchase rate | Orders by returning customers / Total returning customers | 23% | 28% |

### Secondary Metrics
| Metric | Definition | Direction |
|--------|------------|-----------|
| Time to repurchase | Seconds from opening app to order placed | Decrease |
| Reorder feature adoption | % of repeat orders using reorder button | Increase |
| Average order value | Revenue per order | Neutral or increase |

### Guardrail Metrics (Must Not Regress)
| Metric | Threshold |
|--------|-----------|
| First-time purchase rate | No decrease > 2% |
| App crash rate | No increase |
| Page load time | No increase > 200ms |

### Minimum Detectable Effect (MDE)
We need to detect a **5% relative lift** in repeat purchase rate (23% → 24.15% absolute)
```

### Step 3: Design the Experiment

Structure the test:

```markdown
## Experiment Design

### Experiment Type
- [x] A/B Test (control vs. treatment)
- [ ] Multivariate test
- [ ] Holdout test
- [ ] Sequential test

### Variants
| Variant | Description | Traffic |
|---------|-------------|---------|
| Control | Current order history (no reorder button) | 50% |
| Treatment | Order history with "Reorder" button | 50% |

### Randomization Unit
**User-level** — Same user always sees same variant

### Targeting
| Criteria | Value |
|----------|-------|
| User type | Returning customers |
| Order history | 2+ previous orders |
| Platform | iOS and Android |
| Geography | US only |

### Exclusions
- Internal users
- Users in other active experiments on order history
- New users (< 1 order)
```

### Step 4: Calculate Sample Size

Ensure statistical validity:

```markdown
## Sample Size Calculation

### Inputs
| Parameter | Value | Notes |
|-----------|-------|-------|
| Baseline rate | 23% | Current repeat purchase rate |
| MDE | 5% relative (1.15% absolute) | Minimum meaningful lift |
| Significance level (α) | 0.05 | 95% confidence |
| Power (1-β) | 0.80 | 80% chance to detect effect |

### Calculation
Using two-proportion z-test:
```
n = 2 × [(Z_α + Z_β)² × p × (1-p)] / (MDE)²
n = 2 × [(1.96 + 0.84)² × 0.23 × 0.77] / (0.0115)²
n ≈ 21,500 per variant
n_total ≈ 43,000 users
```

### Duration Estimate
| Parameter | Value |
|-----------|-------|
| Daily eligible users | ~3,500 |
| Required sample | 43,000 |
| Estimated duration | 12-14 days |
| Recommended duration | 14 days (includes weekends) |
```

### Step 5: Plan for Risks

Anticipate issues:

```markdown
## Risk Assessment

### Experiment Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Sample ratio mismatch | Low | High | Daily monitoring, auto-pause |
| Novelty effect | Medium | Medium | Run 2 full weeks minimum |
| Cart merge bugs | Medium | High | Staged rollout, error monitoring |
| Metric instrumentation | Low | High | Pre-launch QA of events |

### Rollback Criteria
Immediately stop if:
- Crash rate increases > 0.5%
- Cart errors increase > 1%
- Page load time increases > 500ms
- Sample ratio > 51/49

### Staged Rollout
| Phase | Traffic | Duration | Criteria to Proceed |
|-------|---------|----------|---------------------|
| 1 | 5% | 24 hours | No critical issues |
| 2 | 25% | 48 hours | Error rates stable |
| 3 | 50% | Experiment duration | Continue per plan |
```

### Step 6: Define Analysis Plan

Pre-specify analysis:

```markdown
## Analysis Plan

### Pre-Registration
Analysis approach defined BEFORE viewing results:
- Primary analysis: Two-proportion z-test
- Segmentation: By order frequency, platform, tenure
- Multiple testing: Bonferroni correction for segments

### Primary Analysis
```
Test: Two-proportion z-test
H₀: p_treatment = p_control
H₁: p_treatment ≠ p_control
α = 0.05 (two-tailed)
```

### Segmentation Analysis
| Segment | Hypothesis |
|---------|------------|
| High-frequency (5+ orders) | Larger effect |
| iOS vs Android | Similar effect |
| New vs. established (1yr+) | Similar effect |

### Timeline
| Day | Action |
|-----|--------|
| 0 | Launch experiment |
| 1-3 | Monitor for issues only |
| 7 | Mid-experiment check (sample size, no peeking at results) |
| 14 | End experiment, analyze |
| 15 | Share results |
```

### Step 7: Document Decision Framework

Pre-commit to actions:

```markdown
## Decision Framework

### If Significant Positive Result (p < 0.05, effect > MDE)
1. Ship to 100% of users
2. Update success metrics tracking
3. Move to next hypothesis

### If Significant Negative Result
1. Do not ship
2. Analyze segments for insights
3. Consider alternative approaches
4. Document learnings

### If Inconclusive (p > 0.05)
1. Evaluate if sample size was sufficient
2. Consider extending experiment
3. Analyze secondary metrics
4. Make decision based on full context

### If Guardrail Breach
1. Stop experiment immediately
2. Investigate root cause
3. Fix before re-running

### Documentation
Regardless of outcome:
- [ ] Write experiment report
- [ ] Share learnings with team
- [ ] Update hypothesis confidence
- [ ] Archive in experiment repository
```

## Best Practices

### Do
- Form hypothesis before designing test
- Calculate sample size upfront
- Pre-register analysis approach
- Run for full duration (no peeking)
- Document learnings always

### Don't
- Stop early based on partial data
- Change hypothesis mid-experiment
- Ignore guardrail metrics
- Skip staged rollout for risky changes
- Forget to account for novelty effects

## Common Patterns

### Experiment Types
```
A/B Test: Simple comparison (control vs treatment)
A/B/n: Multiple treatments
Holdout: Long-term impact measurement
Interleaving: For ranking/recommendation systems
```

### Sample Size Rules of Thumb
```
Small effect (1-2%): 50,000+ per variant
Medium effect (5-10%): 10,000-20,000 per variant
Large effect (15%+): 2,000-5,000 per variant
```

### Duration Guidelines
```
Minimum: 7 days (capture weekly patterns)
Recommended: 14 days (2 full weeks)
Complex changes: 21-28 days
```

## Output Checklist

- [ ] Hypothesis clearly stated
- [ ] Primary and secondary metrics defined
- [ ] Guardrail metrics specified
- [ ] MDE determined
- [ ] Sample size calculated
- [ ] Duration estimated
- [ ] Experiment design documented
- [ ] Risks identified with mitigations
- [ ] Analysis plan pre-registered
- [ ] Decision framework committed

---

**This skill designs rigorous experiments that produce valid, actionable results for data-driven product decisions.**
