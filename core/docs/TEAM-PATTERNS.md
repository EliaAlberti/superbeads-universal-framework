# Team Patterns

> **Pre-defined team compositions for common work scenarios**

Teams are requested by saying the trigger phrase. The lead reads the team pattern from CLAUDE.md, reads the relevant agent templates, and spawns the team.

---

## Pre-defined Patterns

| Pattern | Trigger Phrase | Composition | Best For |
|---------|---------------|-------------|----------|
| Feature Team | "feature team" | strategist + executor + specialist + critic | New feature implementation |
| Bug Squad | "bug squad" | 3x executor + critic | Rapid bug fixing |
| Research Team | "research team" | strategist + 2x specialist + critic | Technical research and analysis |
| Sprint Team | "sprint team" | strategist + 2x executor + critic | Sprint execution |
| Review Team | "review team" | 2x critic + specialist | Code/design review |

---

### Feature Team

**When to use:** New features needing planning, implementation, expertise, and review.

- strategist (architecture, task breakdown) + executor (implementation) + specialist (domain expertise) + critic (quality checks)
- Workflow: Strategist creates tasks, executor and specialist work in parallel, critic reviews each task

### Bug Squad

**When to use:** Tricky bugs with multiple possible causes.

- 3x executor (each investigates a different hypothesis) + critic (validates the fix)
- Workflow: Executors investigate in parallel, first to find root cause shares, critic validates

### Research Team

**When to use:** Technical investigation, architecture decisions, technology evaluation.

- strategist (frames questions) + 2x specialist (deep-dive different aspects) + critic (evaluates findings)
- Workflow: Strategist divides scope, specialists investigate in parallel, critic reviews, strategist synthesizes

### Sprint Team

**When to use:** Sprint execution with multiple parallel tasks.

- strategist (planning, blocker resolution) + 2x executor (parallel implementation) + critic (continuous review)
- Workflow: Strategist plans via `bv --robot-triage`, executors claim tasks, critic reviews completions

### Review Team

**When to use:** Thorough review of existing work.

- 2x critic (independent review) + specialist (domain-specific assessment)
- Workflow: Critics review independently, specialist adds nuance, team consolidates findings

---

## Custom Team Compositions

You can create custom teams by specifying exactly which agents to spawn:

**Examples:**
- "Spin up a team with two executors and a critic"
- "I need a strategist and a specialist for this"
- "Give me three specialists to evaluate different approaches"

The lead reads the relevant templates and spawns just those agents. Any valid combination works.

---

## Tips for Effective Teams

- **Start with the pattern** -- pre-defined patterns cover most scenarios
- **Add agents as needed** -- you can spawn additional agents mid-session
- **Don't over-staff** -- more agents means more coordination overhead
- **Let specialists specialize** -- don't give specialized work to executors if it's complex
- **Always include a critic** -- unreviewed work is unverified work
- **Match team to scope** -- a 15-minute task doesn't need a 4-agent team

---

## When to Use Teams vs. Solo Agents

| Scenario | Recommendation |
|----------|---------------|
| Single well-defined task | Solo agent (executor or specialist) |
| Task needing review | Solo agent + critic |
| Multi-step feature | Feature Team |
| Unclear root cause | Bug Squad |
| Architectural decision | Research Team |
| Multiple parallel tasks | Sprint Team |
| Quality audit | Review Team |

**Rule of thumb:** Use teams when work benefits from parallel execution or multiple perspectives. Use solo agents when the task is clear and self-contained.

---

*Team Patterns - Core Engine Documentation*
