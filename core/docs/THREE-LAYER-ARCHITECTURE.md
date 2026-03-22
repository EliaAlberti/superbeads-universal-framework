# Three-Layer Architecture

> **How CLAUDE.md, capabilities, and agent teams fit together**

SuperBeads runs on three layers. Each builds on the one below it.

---

## Layer 1: CLAUDE.md (The Brain)

Auto-loaded by every Claude Code session and every agent. The single source of truth.

| Section | Purpose |
|---------|---------|
| Spawn Protocol | Instructions for reading agent templates and spawning teams |
| Team Patterns | Pre-defined team compositions with trigger phrases |
| Task Rules | The 10-15 minute atomic task rule |
| Persistence Config | Beads, sprint tracking, verification settings |
| Key Decisions | Architectural choices that agents must respect |
| Working Rules | Constraints that apply to all agents |

When the lead spawns an agent, that agent also receives CLAUDE.md automatically.

---

## Layer 2: Capabilities

Three types of capabilities sit alongside CLAUDE.md:

### Agent Templates (`.claude/agents/`)

Markdown files defining each agent's role, tools, and communication patterns. The lead reads these on demand and uses their content as spawn prompts. NOT auto-loaded.

- Four universal roles: strategist, executor, specialist, critic
- Domain packs add specialized variants (e.g., ios-executor, web-specialist)

### Skills (auto-loaded slash commands)

Automatically available to every session and agent. No configuration required.

- Session: `/resume`, `/preserve`, `/compress`, `/wrapup`
- Domain: provided by packs (networking, navigation, testing, etc.)
- Community: verification, debugging, TDD, code review

### Persistence (Beads + Sprint)

Agents spawn fresh each session with no memory. Persistence comes from disk:

- **Beads** (`.beads/`): Structured task database with context, dependencies, status
- **Sprint** (`.sprint/`): Progress log and machine-readable sprint state
- **Git**: Atomic commits per task with `[task-id]` prefixes

---

## Layer 3: Agent Teams

Agent Teams use Claude Code's native multi-agent coordination:

- The lead (main Claude Code session) spawns agents
- Each agent runs as a separate process with its own context
- Agents communicate directly with each other via messages
- Shared task list coordinates work
- All agents share access to MCP servers and tools

Teams are requested by trigger phrase ("feature team", "bug squad", etc.) and the lead handles all spawning and coordination.

---

## Information Flow

```
1. User starts Claude Code       --> CLAUDE.md auto-loaded
2. User requests a team          --> Lead reads team pattern from CLAUDE.md
3. Lead reads agent templates    --> Spawns agents with full template content
4. Each agent auto-loads         --> CLAUDE.md + skills + MCP servers
5. Each agent queries state      --> bv --robot-triage for project context
6. Agents work on tasks          --> Communicate directly, follow task rules
7. On task completion            --> Verify, commit, update Beads, log progress
8. Session ends                  --> State persisted to disk
9. Next session starts           --> New agents get project state from Beads
```

---

## Why Three Layers

| Principle | How the architecture supports it |
|-----------|----------------------------------|
| Core works alone | Layer 1 + Layer 2 deliver full value without teams |
| Mid-project adoption | Layers are additive, non-destructive |
| Domain-agnostic | Layers are universal; domain packs extend, not replace |
| Session independence | Persistence layer bridges sessions without shared memory |
| Observable verification | Each layer has checkable outputs, not trust-based handoffs |

---

*Three-Layer Architecture - Core Engine Documentation*
