---
name: weekly-synthesis
description: End-of-week consolidation across all your skills — decisions made, signals that strengthened or faded, pipeline health, and memory housekeeping.
user-invocable: true
---

# Weekly Synthesis

Runs once a week (e.g. Friday afternoon) and produces the strategic view a
daily briefing can't: what happened this week, what it means, what's next.
Also does memory housekeeping so your other skills' state files don't grow
unbounded.

Reads config from `{config.identity.*}`, `{config.channels.telegram.chat_id}`,
`{config.vault.path}`, and the output history of whatever skills you run.

## Execution steps

### 1. Gather the full week
Read this week's daily briefing outputs (from `orchestrator` / `briefing-morning`,
if you run them) and the memory/state files of every skill you run — email
triage, follow-ups, meeting prep, any research/idea-tracking skill.

### 2. Analyze

**Decision audit** (if you keep a decision log): how many decisions were made
fast vs. slow vs. deferred; the biggest decision of the week; anything
deferred that's becoming urgent.

**Signal strength tracker** (if you keep an active-threads file): which
threads gained evidence from multiple sources this week (strengthening);
which went quiet (fading); anything genuinely new.

**People map**: new contacts, most-engaged contacts, who you still owe a
response to, who you should proactively reach out to.

**Pipeline health** (adapt to your own domains — writing, deals, projects,
whatever you actually track): items generated this week, items that
progressed a stage, health rating (healthy / warning / critical based on how
much is in a "ready" state).

**Pattern summary**, if you track this: work-hours pattern, context-switching
level, whether your intended focus area actually got attention this week or
got displaced by lower-value work.

### 3. Write the report
```
# Weekly Report — {week}

## The Week in One Sentence

## Week by Numbers
- Decisions: X fast / X slow / X deferred
- Meetings: X — New contacts: X
- [your own pipeline counts]

## Signal Mesh — What Strengthened
## What Faded

## People
- Key relationships this week
- Owed responses
- Proactive outreach suggestion

## Next Week Preview
- Calendar highlights
- Decisions that have been deferred too long
- One highest-leverage thing to focus on

## Follow-up Audit
- Overdue / Completed
```

### 4. Memory maintenance
This step matters as much as the report:
- Archive entries older than ~30 days in each skill's state files to a
  separate archive file; keep active files under a reasonable size (e.g.
  ~500 lines).
- Prune your active-threads/connections file: drop threads with no activity
  for 2+ weeks, promote strong ones.
- If your state lives in a git-tracked notes vault, commit and push any
  pending changes.

### 5. Deliver
Send a short Friday summary via `{config.channels.telegram.chat_id}` — the
one-sentence headline, the top strengthening/fading signal, pipeline status,
and the one thing to focus on next week. Keep it scannable, not a wall of
text — a handful of short lines, not the full report (the full report goes to
a file).

## Rules
- This is a synthesis, not a diary — every section should answer "so what,"
  not just "what happened."
- Memory housekeeping runs every time, even on weeks where nothing dramatic
  happened — that's how state files stay usable.
