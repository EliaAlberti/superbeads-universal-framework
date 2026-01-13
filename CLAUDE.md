# CLAUDE.md - Universal SuperBeads Framework

## Context

| Key | Value |
|-----|-------|
| **Project** | Universal SuperBeads Framework |
| **Purpose** | Meta-framework for ANY Claude Code task |
| **Status** | ✅ Ready for GitHub launch |
| **Architecture** | Core Engine (standalone) + Domain Packs (accelerators) |

---

## What Exists

```
core/
├── docs/           # 7 universal docs
├── templates/      # Agent templates (4), skill, task schema, verify.sh
└── scripts/        # superbeads CLI v1.1.0

packs/              # 5 domain packs, each with 4 agents + 9 skills
├── ios/            # Swift/SwiftUI
├── python/         # Python/FastAPI
├── web/            # React/Next.js
├── design/         # Product design (Figma, AI tools)
└── pm/             # Product management (Agile + Lean)

superbeads-ios-app/ # Demo project for screen recordings
```

**CLI:** `superbeads init|task|sprint|board|verify|status|pack install|pack list`

**Task Board:** `superbeads board` (TUI) | `--triage` | `--next` | `--plan` | `--insights` | `--alerts`

---

## Core Patterns (Immutable)

**Four Agents:** Strategist (plan) → Executor (build) → Specialist (expertise) → Critic (review)

**Task Rule:** 10-15 min, no "and", 3-5 criteria, observable signal, one commit

**Session Flow:** Query state → Report → Get direction → Execute → Summarize → Update → Handoff

**Verification:** Output exists | Build passes | Tests pass | API succeeds | Checklist done

---

## Key Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| Config format | File-based (JSON/MD) | Version-controllable, human-readable |
| Agent format | Markdown + frontmatter | AI-parseable, human-readable |
| Verification | Shell scripts | Universal, composable |
| Model per role | Sonnet (work), Haiku (review) | 5x cost savings on reviews |
| Task board | Wrap bd/bv with neutral terminology | Leverage existing tools, own the UX |
| CLI `--yes` flag | Deferred | Human install works; CI/CD is nice-to-have |
| bv "AI Integration?" prompt | Select "No thanks" | SuperBeads has its own agent system |

---

## Working Rules

1. **Universal = universal** - Domain-specific → Pack, not Core
2. **Core works alone** - No pack = full value
3. **Observable verification** - "Can check" not "looks good"
4. **Mid-project adoption** - Non-destructive, incremental, works without git

---

## Session Commands

| Command | Purpose |
|---------|---------|
| `/resume` | Start session: load context from CLAUDE.md |
| `/preserve` | End session: update CLAUDE.md with learnings |
| `/wrapup` | Quick end: summary + optional CLAUDE.md update |
| `/compress` | Pre-compact: preserve before `/compact` |

---

## Navigation

| Need | Location |
|------|----------|
| User Guide | `GUIDE.md` |
| Full vision | `VISION.md` |
| Agent pattern | `core/docs/UNIVERSAL-AGENTS.md` |
| Task sizing | `core/docs/TASK-DISCIPLINE.md` |
| Pack creation | `CONTRIBUTING.md` |
| Demo recordings | `superbeads-ios-app/SCREEN-RECORDINGS.md` |

---

## Demo App

**Location:** `superbeads-ios-app/` - WeatherApp demo for recordings

| Component | Status |
|-----------|--------|
| `.beads/` | ✅ Task database (clear before recording) |
| `.superbeads/` | ✅ Fresh init done |
| `SCREEN-RECORDINGS.md` | ✅ 5 scripts (Claude Code + standalone TUI) |

---

## Next Steps

- [x] Fix README installation (now uses install script) ✓
- [x] Run installer (`~/.superbeads/bin/` in PATH) ✓
- [x] All verification tests passed ✓
- [ ] Create screen recordings per `SCREEN-RECORDINGS.md`
- [ ] GitHub repo setup (LICENSE ✓, CONTRIBUTING.md ✓, .gitignore check)
- [ ] Launch

---

## Reference

**Original iOS framework (read-only):** `/Users/eliaalberti/VSC/projects/frameworks/superbeads-ios-framework-wiggun-flavour-reference`

**Credits:** Beads (Steve Yegge), BeadsViewer (Jeffrey Emanuel), Superpowers (obra), Ralph Wiggum (Anthropic)

---

*Updated: January 11, 2026 - Pre-launch*
