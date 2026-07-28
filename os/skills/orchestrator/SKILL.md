---
name: orchestrator
description: Consolidate outputs from your other skills into one daily intelligence briefing — cross-referencing sources to surface connections and blind spots no single skill would catch alone.
user-invocable: true
---

# Orchestrator — Signal Mesh

**Overlaps with `briefing-morning`** — both synthesize "what matters today"
into one Telegram message. If you enable both, either stagger them enough to
tell apart (orchestrator earlier, briefing-morning later) and treat one as
the deeper cross-source pass and the other as the quick daily nudge, or just
run one of the two. This skill does not currently read or suppress
briefing-morning's output (and vice versa) — running both as-is means two
separate messages, not one enriched one.

This is the skill that reads what your other skills produced and looks for
what none of them individually would notice: the same conclusion reached
three different ways (redundant, weight it once), or two unrelated signals
that are actually the same underlying pattern (a real find, weight it high).

Reads config from `{config.identity.*}`, `{config.channels.telegram.chat_id}`,
and the output locations of whatever other skills you run
(`email-triage`, `followups`, `meeting-prep`, plus any research/idea-tracking
skills of your own).

## Execution steps

### 1. Load everything
Pull the latest output from every skill you run: email triage results,
follow-up state, meeting preps, any research/idea backlog you maintain, and
your calendar for today/tomorrow. If a skill's last output is well past its
expected refresh window, note it as stale and fall back to whatever's still
current rather than presenting stale data as fresh.

### 2. Build the signal mesh
This is the core value-add — apply an **independence check** before
synthesizing:
- Does this insight come from a genuinely different source than the others?
- Or is it the same conclusion reached by reading the same input twice?
- If N sources say the same thing, that's one signal expressed N times —
  weight it as one, note it as corroboration, don't inflate it.

Optionally report an "effective independent signal count" so you can see how
concentrated vs. diverse the day's inputs were (e.g. "3 independent signals
from 7 total outputs").

**Cross-connections** — actively look for these, they're the hard part:
- Does a contact from one source relate to a topic surfaced by another?
- Does an open idea/thread connect to something that just came in?
- What structural similarity exists between two seemingly unrelated items?

**Blind spots** — actively look for absence, not just presence:
- What do you usually engage with that's gone quiet?
- What got classified as low-priority that might actually matter?
- Who do you usually respond to that you haven't?

### 3. Write the briefing
```
# Daily Intelligence Briefing — {date}

## Top 3 Today
1. [most important — with why it matters NOW]
2. [second priority]
3. [third — could be a blind spot or emerging signal]

## Today's Schedule
- time — meeting — prep notes / relevant context

## Signal Mesh — Cross-Connections
- [connection between source A and source B]
- Effective-N: [X] independent signals from [Y] total outputs.

## Blind Spots
- [what's being under-attended]

## Pending Actions
- [count] awaiting your approval; oldest: [description, age]
```

Add sections specific to your own domain (a pipeline tracker, a writing
backlog, whatever you actually run) — the structure above is the generic
skeleton, not an exhaustive template.

### 4. Maintain shared state
If you keep a running "active threads" or similar file that other skills
read from, merge new signal into it here, and prune it periodically: archive
weak/stale threads, keep anything still active or recently touched. Keep any
shared memory files under a reasonable size (e.g. archive past ~500 lines).

### 5. Deliver
Compose a short, conversational message (not the full structured briefing —
that goes to a file/log) via `{config.channels.telegram.chat_id}`:
- No emoji section headers, no bullet dashboards.
- Weave the top items into natural sentences.
- End with one suggestion or question.
- Keep it short enough to read on a phone screen without scrolling.
- If you track energy/mood state, calibrate length and content to it —
  shorten sharply on a high-pressure day, skip non-essential content on a
  quiet day.

## Quality bar
- No filler — every line should be actionable or genuinely informative.
- Cross-reference, don't repeat — if two sources say the same thing, say it
  once and note the corroboration.
- Time-bound urgency — say why something matters today, not just that it
  exists.
