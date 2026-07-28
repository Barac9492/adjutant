---
name: today
description: "Pull daily notes, tasks, and priorities into a focused plan for today"
disable-model-invocation: true
allowed-tools: Grep, Read, Glob
---

# Plan Today

Read the notes vault at `{config.vault.path}` (see `config/os.config.yaml` —
if unset, tell the user this skill needs `vault.path` configured and stop)
and generate a prioritized plan for today.

## Steps

### 1. Find today's daily note
Look for a file matching today's date. Read it fully. Extract any tasks,
plans, or notes already written for today.

### 2. Read recent daily notes
Read notes from the past 3-5 days. Look for:
- Unfinished tasks (`- [ ]`) that should carry over
- Commitments or deadlines mentioned for this week
- Themes or priorities stated recently

### 3. Scan for this week's priorities
Search the vault for mentions of this week's dates and priority/deadline
language (in whatever language the vault is written in). Check any planning
or weekly-review notes.

### 4. Generate the daily plan

```
## Today's Plan — [Date, Day of Week]

### Top Priority
1. [The single most important thing to do today, based on stated priorities]

### Must Do
- [ ] [Carried-over unfinished task]
- [ ] [Task from today's daily note]
- [ ] [Deadline-driven item]

### Should Do
- [ ] [Important but not urgent items]

### Could Do
- [ ] [Nice-to-have items if time allows]

### Context
- [Relevant notes or reflections that inform today's priorities]
- [Anything mentioned as blocking or dependent]
```

## Notes
- If there's no daily note for today, say so and offer to create one.
- Prioritize ruthlessly. The user wants clarity, not a complete list — put
  the single most impactful item at the top.
- Match the language of the daily notes.
- Reference source notes so the user can trace your reasoning.
