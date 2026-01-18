# /compress - Smart Conversation Compression

## Description

Prepares preservation notes for conversation compaction AND saves the full session to searchable logs. Run this BEFORE `/compact`.

You MUST use this skill before running /compact. This ensures session history is preserved and searchable for future /resume calls.

---

## Purpose

Prepare for context compaction:
- Capture key learnings before /compact clears context
- Save full session log for future searchability
- Extract keywords for AI scanning
- Enable /resume to find relevant past sessions

## Usage

- `/compress` - Interactive compression with options
- **Workflow:** `/compress` - answer questions - session saved - `/compact`

---

## Process

### Step 1: Ask What to Preserve

Use AskUserQuestion with multi-select:

**Question:** "What would you like to preserve from this conversation?"

**Options (multi-select enabled):**
1. **Key Learnings** - Technical insights, new knowledge, "aha" moments
2. **Solutions & Fixes** - Code solutions, bug fixes, commands that worked
3. **Decisions Made** - Choices, trade-offs, why we chose X over Y
4. **Files Modified** - List of files created/edited with brief descriptions
5. **Setup & Config** - Environment setup, credentials, paths, configurations
6. **Pending Tasks** - Unfinished work, next steps, blockers
7. **Errors & Workarounds** - Problems encountered and how they were solved

### Step 2: Ask for Custom Preservation (Optional)

Ask: "Anything specific you want to highlight or remember? (Type 'skip' to continue)"

This allows the user to add custom notes like:
- "Remember that the API key expires in 30 days"
- "The client prefers option B"
- "Need to revisit the auth flow next week"

### Step 3: Suggest Topic Name

Analyze the conversation and suggest a concise topic name (3-5 words, lowercase, hyphens):

```
Based on this session, I suggest the topic name: **fix-auth-token-refresh**

Accept this, or type your preferred topic name:
```

The user can:
- Accept by typing "ok" or "yes"
- Provide their own topic name

### Step 4: Generate Session Log

Create the session log content with this structure:

```markdown
# Session Log: DD-MM-YYYY HH:MM - {Topic Name}

## Quick Reference (for AI scanning)
**Confidence keywords:** {extracted keywords from conversation}
**Projects:** {project names mentioned}
**Outcome:** {1-sentence outcome summary}

## Decisions Made
- {Decision 1 with brief rationale}
- {Decision 2 with brief rationale}

## Key Learnings
- {Learning 1}
- {Learning 2}

## Solutions & Fixes
- {Solution 1}
- {Solution 2}

## Files Modified
- `{path/to/file}` - {what changed}

## Setup & Config
- {Config item if selected}

## Pending Tasks
- {Pending item if selected}

## Errors & Workarounds
- {Error and fix if selected}

## Key Exchanges
- {Notable exchange 1 - brief summary}
- {Notable exchange 2 - brief summary}

## Custom Notes
{User's custom notes from Step 2, or "None"}

---

## Quick Resume Context
{2-3 sentences that would help resume this work in a future session}

---

## Raw Session Log

{FULL CONVERSATION - Copy the entire conversation history here, preserving all user messages and assistant responses. This is the searchable archive.}
```

**IMPORTANT:** Only include sections the user selected in Step 1. Always include:
- Quick Reference (for AI scanning)
- Quick Resume Context
- Raw Session Log

### Step 5: Detect Project Root and Save

**Generate filename:**
```
DD-MM-YYYY-HH_MM-{topic-name}.md
```
Example: `16-01-2026-18_05-fix-auth-token-refresh.md`

**Detect project root:**
```
1. Get current working directory (pwd)
2. Walk up from pwd looking for CLAUDE.md or .git
3. If found: project_root = that directory
4. If not found: project_root = pwd
```

**Session logs path:**
```
{project_root}/CC-Session-Logs/
```

**Save the session:**
```bash
# Create folder if needed
mkdir -p "{project_root}/CC-Session-Logs/"

# Write session log using Write tool
Write → {project_root}/CC-Session-Logs/{filename}
```

### Step 6: Confirm and Instruct

Output confirmation:

```markdown
## Session Saved Successfully

### File Created

**Session Log:**
`{project_root}/CC-Session-Logs/{filename}`

### Session Summary
- **Project:** {project_root basename}
- **Topic:** {topic-name}
- **Sections preserved:** {list of selected sections}
- **Keywords:** {confidence keywords}

---

**Next step:** Run `/compact` to compress the conversation context.

The session log is saved locally. Use `/resume` to load context from recent sessions.
```

---

## Confidence Keywords Extraction

When generating the "Confidence keywords" field, extract:
- Project names (e.g., my-app, auth-service)
- Technical terms (e.g., JWT, API, database, MCP)
- Action types (e.g., fix, create, update, refactor)
- Tool/skill names (e.g., superbeads, verify.sh)
- People mentioned (if relevant to project)
- Specific identifiers (e.g., ticket numbers, version numbers)

These keywords enable the `/resume` skill to find relevant sessions via grep search.

---

## Guidelines

- **Be concise** - Each bullet should be actionable or informative
- **Use code blocks** for commands, paths, and code snippets
- **Include file paths** with line numbers where relevant
- **Preserve exact values** - Don't paraphrase credentials, IDs, or specific configs
- **Link context** - If something depends on something else, note the relationship
- **Extract keywords** - The "Confidence keywords" field is critical for future AI scanning
- **Full raw log** - The Raw Session Log must contain the COMPLETE conversation for searchability

---

## Best Practices

### Do's

- Run /compress before every /compact
- Choose preservation options that match the session's content
- Accept or provide meaningful topic names
- Let the full conversation be saved to Raw Session Log

### Don'ts

- Don't skip /compress before /compact - you'll lose searchable history
- Don't use vague topic names like "work" or "stuff"
- Don't exclude the Raw Session Log - it enables future search

---

## Example Output

```markdown
## Session Saved Successfully

### File Created

**Session Log:**
`/Users/dev/my-project/CC-Session-Logs/16-01-2026-18_05-fix-auth-token-refresh.md`

### Session Summary
- **Project:** my-project
- **Topic:** fix-auth-token-refresh
- **Sections preserved:** Decisions Made, Key Learnings, Files Modified
- **Keywords:** JWT, refresh token, auth, API, fix, token expiry

---

**Next step:** Run `/compact` to compress the conversation context.

The session log is saved locally. Use `/resume` to load context from recent sessions.
```

---

## Related Skills

- [resume-SKILL](./resume-SKILL.md) - Start sessions by loading session logs
- [preserve-SKILL](./preserve-SKILL.md) - Update CLAUDE.md with learnings
- [wrapup-SKILL](./wrapup-SKILL.md) - Quick session end without full compression

---

*This skill preserves full session history for searchable archives.*
