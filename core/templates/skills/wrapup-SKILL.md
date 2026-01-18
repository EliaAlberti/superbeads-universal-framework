# /wrapup - Quick Session End

## Description

Quick session end with summary and optional CLAUDE.md update. Use this for shorter sessions that don't need full /compress treatment.

Use this skill for quick session endings. For sessions with significant learnings, use /preserve instead. For sessions before /compact, use /compress instead.

---

## Purpose

End sessions quickly:
- Summarize what was accomplished
- Note any blockers or warnings
- Optionally update CLAUDE.md
- Prepare for next session

## Usage

- `/wrapup` - Quick summary with optional CLAUDE.md update
- Use when session was short or straightforward
- Use /compress instead if you plan to run /compact

---

## Process

### Step 1: Generate Session Summary

Analyze the conversation and create a brief summary:

```
══════════════════════════════════════════════════════════════
 SESSION SUMMARY
══════════════════════════════════════════════════════════════

**Duration:** ~{estimated time}
**Focus:** {main topic/task}

**Accomplished:**
* {What was done 1}
* {What was done 2}
* {What was done 3}

**Files Changed:**
* `{path/to/file}` - {brief description}

**Blockers/Warnings:**
* {Any issues, or "None"}

**Next Session:**
* {What to work on next}

══════════════════════════════════════════════════════════════
```

### Step 2: Ask About CLAUDE.md Update

Ask: "Update CLAUDE.md with this progress? [Yes / No]"

**If Yes:**
- Read current CLAUDE.md
- Update relevant sections (usually "Current Status" or "Next Steps")
- Keep updates minimal - just status and next steps
- Confirm the update

**If No:**
- End with the summary
- Remind: "Run /preserve if you want to save learnings, or /compress before /compact."

### Step 3: Output Final Message

```
Session ended.

{If CLAUDE.md updated:}
CLAUDE.md updated with current progress.

{If not updated:}
No changes saved. Run /preserve for detailed preservation or /compress before /compact.

Ready for next session - start with /resume.
```

---

## When to Use Each Command

| Command | When to Use |
|---------|-------------|
| `/wrapup` | Quick sessions, minor work, no /compact planned |
| `/preserve` | Significant learnings to save to CLAUDE.md |
| `/compress` | Before running /compact (saves full session log) |

---

## Best Practices

### Do's

- Use for quick, straightforward sessions
- Note any blockers for next session
- Update CLAUDE.md if status changed

### Don'ts

- Don't use before /compact - use /compress instead
- Don't skip noting blockers - they're easy to forget
- Don't use for sessions with complex learnings - use /preserve

---

## Related Skills

- [resume-SKILL](./resume-SKILL.md) - Start sessions by loading context
- [preserve-SKILL](./preserve-SKILL.md) - Detailed preservation to CLAUDE.md
- [compress-SKILL](./compress-SKILL.md) - Full session log before /compact

---

*This skill provides quick session endings without full preservation overhead.*
