---
name: decide
description: Decision Ledger — track open high-stakes decisions, enforce a re-analysis lock, force closure. Use for /decide [list|add|review|commit|defer|weekly], when the user names a tracked decision, or whenever the user requests NEW analysis of a decision already in the ledger — in that case run the review gate INSTEAD of producing fresh analysis.
user-invocable: true
---

# Decision Ledger

Ledger location: `{config.decisions.ledger_path}` (one file per decision, YAML
frontmatter — see `docs/decision-format.md` for the spec). Notification
channel: `{config.channels.telegram.chat_id}` if telegram is enabled, else
write to a file (see `weekly` below). Today's date: always take from the
environment, never guess.

## Prime directive — the re-analysis lock

The failure mode this skill exists to break: **sophisticated analysis
followed by ambivalence.** Elaborate scenario models, then no commitment.

**If the user asks for any new analysis, comparison, scenario model, or
"let's think through X again" where X matches an open decision in the
ledger: DO NOT produce the analysis.** Instead run `review <id>` (below).
This applies even if the user didn't type `/decide`. Producing a fresh
analysis for a ledger'd decision is a failure of this skill, not a service to
the user — it's exactly the behavior the ledger exists to interrupt.

Tone: direct, peer-level, no hedging. This tool exists because the user wants
to be challenged. Don't soften the gate.

## Subcommands

Parse the argument after `/decide`. No argument → `list`.

### list
Read every `*.md` in the ledger folder except README. For each: id, title,
status, deadline, D-day, lean, review_count. Order: overdue first, then by
deadline. Render a compact table, then one line of push: name the single most
overdue decision and ask whether to review it now.

### add
Interview briefly (max 5 questions): what's the decision, what analysis
already exists (search available history for it and link real sources if
possible), current lean, what would genuinely change their mind, deadline +
basis. Refuse vague deadlines — a deadline needs a basis (a real window, an
external date, a decay you can name). Write the file per
`docs/decision-format.md`. Status `open`, review_count 0.

### review <id>
The core gate. Read the decision file fully, then proceed in strict order:

1. **State prior work**: "You analyzed this on [dates] — [one-line
   conclusion of each]. Your stated lean is: [lean]."
2. **The only question**: "Since [last_reviewed], which item on the 'What
   Would Change My Mind' list has actually happened?" Demand specifics.
   Search recent activity for movement on the decision's own terms and
   surface anything relevant — including the absence of movement.
3. **Branch:**
   - **Genuine new info** (matches the list): log it in the Decision Log,
     analyze the DELTA only — never re-run the full analysis. Update `lean`
     if it moved. Update `last_reviewed`, increment `review_count`.
   - **No new info**: say so plainly, then force the fork: **decide now**
     (→ run `commit`) or **defer** (→ run `defer`). No third option. If
     `review_count >= 2` with no new info ever logged, say that plainly —
     the pattern itself is the answer to whether more time will help.
4. Never extend a deadline during a review without an explicit defer.

### commit <id>
Record the decision: set `status: decided`, add a Decision Log entry with
date, the decision in the user's own words, and the first three concrete
actions it implies (owners + dates — feed these to a follow-up tracker if you
have one). Congratulate briefly — closure is the point — then ask if the
implied actions should go anywhere else (calendar, follow-ups, a successor
decision).

### defer <id>
A deferral must name **what is being waited for** and **a new date**. "More
thinking" is rejected. Set `status: deferred`, update `deadline`, log the
reason. A deferred decision whose wait-condition has occurred counts as
overdue.

### weekly
Scheduled entry point (default: Mondays). Steps:
1. Run `list` logic silently.
2. Compose a short brief in the user's own language for self-talk: open
   decisions with D-day, anything overdue flagged, review_count for each, and
   ONE pointed question aimed at the most overdue decision, referencing the
   user's own stated lean.
3. Send via the configured channel. If none is available, write the brief to
   `{config.decisions.ledger_path}/_weekly/<YYYY-MM-DD>.md` and say so.
4. Keep it under 12 lines. Status and the one question — no analysis.

## Editing rules

- Frontmatter format is machine-read by other parts of this OS — keep
  keys/format exactly as specced in `docs/decision-format.md`.
- Decision Log entries are append-only, dated, never rewritten.
- Closed (`decided`) files stay in place — they're the record of closure.
