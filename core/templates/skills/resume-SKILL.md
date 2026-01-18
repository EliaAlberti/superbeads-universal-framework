# /resume - Resume Work with Full Context

## Description

Start any session by loading context from CLAUDE.md and recent session logs. Supports topic-based search for relevant past sessions.

You MUST use this skill at the start of every working session. This ensures continuity across sessions and prevents re-explaining project context.

---

## Purpose

Load project context efficiently:
- Read CLAUDE.md for project state
- Load recent session summaries
- Enable topic-based search for relevant history
- Provide structured status report

## Usage

- `/resume` - Load CLAUDE.md + last 3 session summaries
- `/resume 5` - Load CLAUDE.md + last 5 session summaries
- `/resume auth` - Load CLAUDE.md + last 3 + search for "auth" related sessions
- `/resume 10 api` - Load CLAUDE.md + last 10 + search for "api"

---

## Process

### Step 1: Parse Arguments

Check if user provided arguments:
- **Number (N):** How many recent sessions to read (default: 3, max: 50)
- **Topic keyword:** Search for related sessions beyond the last N

Examples:
- `/resume` - N=3, no topic search
- `/resume 5` - N=5, no topic search
- `/resume auth` - N=3, topic="auth"
- `/resume 10 jira` - N=10, topic="jira"

### Step 2: Find and Read CLAUDE.md

Search for project memory file in order:
1. `CLAUDE.md`
2. `Claude.md`
3. `.claude/CLAUDE.md`
4. `docs/CLAUDE.md`

Read and extract:
- Project name/purpose
- Current phase/status
- Key paths and references
- Recent decisions
- Blockers
- Next steps

### Step 3: Find Project Root and Session Logs

**Detect project root:**
```
1. Get current working directory (pwd)
2. Walk up from pwd looking for CLAUDE.md or .git
3. If found: project_root = that directory
4. If not found: project_root = pwd
```

**Session logs location:**
```
{project_root}/CC-Session-Logs/
```

**Count session logs:**
```bash
ls -1 "{project_root}/CC-Session-Logs/"*.md 2>/dev/null | wc -l
```

### Step 4: Read Session Summaries (Scaling Logic)

**IF session logs < 100:**
1. List all session log files, sorted by filename (newest first)
2. Read the SUMMARY ONLY (everything BEFORE "## Raw Session Log") for the last N files
3. If topic keyword provided, grep all summaries for keyword matches

**IF session logs >= 100:**
1. Read last N session summaries directly
2. For topic matching, use grep:
   ```bash
   grep -l "{topic keyword}" "{project_root}/CC-Session-Logs/"*.md
   ```
3. Read summaries of top 5 topic-matched results (if not already in last N)

**IMPORTANT:** Only read up to "## Raw Session Log" - never read the full raw conversation to save tokens.

### Step 5: Extract Key Information

From each session summary, extract:
- **Date and topic** (from filename and title)
- **Confidence keywords** (from Quick Reference section)
- **Projects referenced** (from Quick Reference section)
- **Outcome** (from Quick Reference section)
- **Key decisions** (if present)
- **Pending tasks** (if present)

### Step 6: Topic Search (If Keyword Provided)

If user provided a topic keyword:

```bash
grep -l "{keyword}" "{project_root}/CC-Session-Logs/"*.md
```

Find sessions where:
- Topic name contains keyword
- Confidence keywords contain keyword
- Content mentions keyword

Add matched sessions to the output (mark them as "RELATED SESSIONS").

### Step 7: Output Combined Report

```
══════════════════════════════════════════════════════════════
 RESUMING: {Project Name}
══════════════════════════════════════════════════════════════

PHASE: {Current phase} - {Status}

CONTEXT:
* {Key insight from CLAUDE.md}
* {What was last worked on}
* {Important project state}

EXISTS:
* {Key directories/files that matter}

BLOCKERS:
* {Any blockers, or "None"}

══════════════════════════════════════════════════════════════
 MOST RECENT SESSION: {DD-MM-YYYY HH:MM}
 Topic: {Topic Name}
══════════════════════════════════════════════════════════════

**Keywords:** {confidence keywords}
**Projects:** {projects referenced}
**Outcome:** {outcome summary}

**Key Points:**
* {Decision or learning 1}
* {Decision or learning 2}
* {Pending task if any}

══════════════════════════════════════════════════════════════
 PREVIOUS SESSIONS ({N-1} more)
══════════════════════════════════════════════════════════════

* {DD-MM-YYYY}: {Topic} - {Outcome snippet}
* {DD-MM-YYYY}: {Topic} - {Outcome snippet}
* {DD-MM-YYYY}: {Topic} - {Outcome snippet}

{If topic search was performed:}
══════════════════════════════════════════════════════════════
 RELATED SESSIONS (Topic: "{keyword}")
══════════════════════════════════════════════════════════════

* {DD-MM-YYYY}: {Topic} - {Why it matched}
* {DD-MM-YYYY}: {Topic} - {Why it matched}

══════════════════════════════════════════════════════════════
 READY TO:
══════════════════════════════════════════════════════════════

* {Next step from CLAUDE.md}
* {Pending task from recent session}
* {Additional next steps}

══════════════════════════════════════════════════════════════
```

### Step 8: Handle Edge Cases

**If no CLAUDE.md found:**
```
No CLAUDE.md found in this project.

Options:
1. Tell me about this project and I'll help create one
2. Just start working and run /preserve later

What would you like to do?
```

**If no session logs exist:**
- Skip the session logs sections entirely
- Just show CLAUDE.md context
- Note: "No session logs yet. Run /compress before /compact to start building session history."

**If fewer than N session logs exist:**
- Read all available logs
- Note: "Found {X} session logs (requested {N})"

---

## Session Summary Reading Pattern

When reading a session log, STOP at "## Raw Session Log":

```
content = read_file(session_log_path)
summary_end = content.find("## Raw Session Log")
if summary_end > 0:
    summary = content[:summary_end]
else:
    summary = content  # No raw log section, read all
```

This ensures context without consuming tokens on the full conversation archive.

---

## Filename Parsing

Session log filenames follow: `DD-MM-YYYY-HH_MM-topic-name.md`

Parse to extract:
- **Date:** `DD-MM-YYYY`
- **Time:** `HH:MM` (replace _ with :)
- **Topic:** Everything after the time, with hyphens replaced by spaces

Example: `16-01-2026-18_05-jira-sync-fixes.md`
- Date: 16-01-2026
- Time: 18:05
- Topic: jira sync fixes

---

## Performance Notes

- **Default N=3:** Keeps token usage low while providing recent context
- **Max N=50:** Reasonable upper limit for summary scanning
- **Summary-only reading:** Critical for token efficiency - never read raw logs in /resume
- **Grep for topics:** Simple and effective for keyword search

---

## Best Practices

### Do's

- Always run /resume at session start
- Use topic search when looking for specific past work
- Keep CLAUDE.md updated (via /preserve) for accurate context

### Don'ts

- Don't skip /resume to "save time" - context loss costs more
- Don't read raw session logs - summaries contain what you need
- Don't ignore blockers listed in the output

---

## Related Skills

- [preserve-SKILL](./preserve-SKILL.md) - End sessions by updating CLAUDE.md
- [compress-SKILL](./compress-SKILL.md) - Save session logs before /compact
- [wrapup-SKILL](./wrapup-SKILL.md) - Quick session end with summary

---

*This skill provides session continuity across Claude Code sessions.*
