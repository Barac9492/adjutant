---
name: briefing
description: "Load your full life and work state from your notes — projects, preferences, priorities, current focus"
disable-model-invocation: true
allowed-tools: Grep, Read, Glob
---

# Load Context from Notes

Read the notes vault at `{config.vault.path}` (from `config/os.config.yaml`
— if unset, tell the user this skill needs `vault.path` configured and stop)
and summarize the user's current context.

## Steps

### 1. Read the index
If `{config.vault.index_file}` is set, read it to understand the vault's
structure and thematic organization.

### 2. Identify recent activity
Glob for all note files, check modification times, and read anything
modified in the last 7 days in full — that's what's actively on the user's
mind.

### 3. Read daily notes
Look for files named with date patterns (`YYYY-MM-DD.md` or similar). Read
all daily notes from the past 7 days. Extract:
- Tasks and to-dos (`- [ ]` / `- [x]`)
- Reflections and observations
- Mentions of people, projects, or deadlines

### 4. Scan for priorities and active projects
Search across vault files for signals of active work — keywords for
"priority," "important," "urgent," "this week," "this month," "project,"
"TODO," "plan," "goal," "deadline" (in whatever language the vault is
written in). Look at tags/frontmatter categories for recurring themes.

### 5. Output the context summary

```
## Current Context

### Active Projects
- [Project name]: [status / what's happening]

### Recent Focus Areas
- [Topic]: [what you've been thinking/writing about]

### Open Tasks
- [ ] [task from daily notes]

### Priorities This Week
- [anything explicitly marked as important]

### Key Reflections
- [notable observations or decisions from recent notes]

### Recurring Themes
- [topics that keep appearing across recent notes]
```

## Notes
- Match the language of the vault content in your summary.
- Reference source notes (e.g. `[[wiki-links]]` if the vault uses them) so
  the user can jump to source material.
- Be concise. This is a briefing, not an essay.
