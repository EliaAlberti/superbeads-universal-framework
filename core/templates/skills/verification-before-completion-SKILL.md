---
name: verification-before-completion
description: Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always
---

# Verification Before Completion

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

Claiming work is complete without verification is dishonesty, not efficiency. If you haven't run the verification command in this message, you cannot claim it passes.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## What Counts as Evidence

| Claim | Requires | Not Sufficient |
|-------|----------|----------------|
| Tests pass | Test output: 0 failures | Previous run, "should pass" |
| Build succeeds | Build command: exit 0 | Linter passing, logs look good |
| Bug fixed | Original symptom tested | Code changed, assumed fixed |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Anti-Patterns

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Done!")
- Committing/pushing/PR without verification
- Trusting agent success reports without independent check
- Thinking "just this once"

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence is not evidence |
| "Linter passed" | Linter is not the compiler |
| "Agent said success" | Verify independently |

## Good Patterns

```
Tests:   Run command -> See 34/34 pass -> "All tests pass"
Build:   Run command -> See exit 0    -> "Build passes"
Reqs:    Re-read plan -> Checklist    -> Verify each -> Report
Agent:   Agent reports -> Check diff  -> Verify      -> Report actual state
```

## Applies to ALL Roles

| Role | Verification Context |
|------|---------------------|
| Strategist | Verify task breakdown covers all requirements |
| Executor | Verify build, tests, and acceptance criteria before claiming done |
| Specialist | Verify domain-specific quality gates before handing off |
| Critic | Verify issues are reproducible before flagging them |

No role is exempt. No task is too small.

**Apply ALWAYS before:** completion claims, commits, PRs, task transitions, delegation, status reports.

## The Bottom Line

Run the command. Read the output. THEN claim the result. This is non-negotiable.

---

*Verification Before Completion - Universal Skill*
