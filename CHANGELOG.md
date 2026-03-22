# Changelog

All notable changes to the Universal SuperBeads Framework.

---

## [2.0.0] - 2026-03-22

### Changed
- All agents default to **Opus 4.6** (was Sonnet for work, Haiku for reviews)
- "Why Haiku Model" sections in critic agents replaced with "Why Opus Model"
- Model Configuration documentation rewritten with Opus-first rationale
- Task template expanded with `verification_method`, `design_tokens`, `files_to_modify` fields

### Added

**Core Principles (backported from swiftforge):**
- **Communication Protocol** -- "Zero surprises" principle added to all 24 agent templates
- **Standby Protocol** -- Agents remain on standby between tasks (all 24 templates)
- **Verification Iron Law** -- "No completion claims without fresh verification evidence" (executor template + VERIFICATION-FRAMEWORK.md)
- **Delegation Rules** -- Anti-patterns for team lead delegation (strategist template)
- **Design-First Workflow** -- "User designs, agent implements" principle (SUPERVISOR-MODEL.md)

**New Documentation:**
- `core/docs/THREE-LAYER-ARCHITECTURE.md` -- Brain (CLAUDE.md) + Capabilities + Teams
- `core/docs/TEAM-PATTERNS.md` -- Pre-defined team compositions (Feature Team, Bug Squad, etc.)
- `core/docs/ROBOT-PROTOCOL-REFERENCE.md` -- `bv --robot-*` commands for agent use

**New Skill:**
- `core/templates/skills/verification-before-completion-SKILL.md` -- Evidence-before-claims workflow

**Framework Improvements:**
- Skill Override System -- per-project pattern customization table in CLAUDE.md template
- Community Skills reference section in GUIDE.md
- Three-Layer Architecture reference in GUIDE.md

---

## [1.1.0] - 2026-01-18

### Added
- Enhanced session skills: `/resume`, `/preserve`, `/compress`, `/wrapup`
- Skills located at `core/templates/skills/*-SKILL.md`
- Model Configuration documentation in GUIDE.md
- GitHub Releases (v1.0.0 retroactive, v1.1.0)

### Changed
- Version badge updated to 1.1.0
- README updated with session commands table and skill links

---

## [1.0.0] - 2026-01-13

### Added
- Core Engine with 4 universal agent templates (Strategist, Executor, Specialist, Critic)
- 5 domain packs: iOS, Python, Web, Design, PM
- 49 skills total (4 core + 9 per pack)
- `superbeads` CLI v1.0.0 with init, task, sprint, board, verify, status, pack commands
- Task Board TUI with Kanban, dependency graph, insights dashboard
- Sprint tracking with current.json + progress.md
- 7 core documentation files
- 9 screenshots for README
- Installation script with PATH integration

---

*Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).*
