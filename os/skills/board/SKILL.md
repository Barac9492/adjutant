---
name: board
description: Persistent Adversarial Board — three standing critics with memory across sessions. Use for /board [convene|minutes], when the user asks for a devil's advocate, adversarial review, or a gut-check on a tracked decision. Proactively suggest convening when any Decision Ledger deadline is within 14 days.
user-invocable: true
---

# Persistent Adversarial Board

Three standing seats, each an agent in `os/agents/` with its own memory.
Minutes: `{config.decisions.board_minutes_path}/` (format spec in
`docs/decision-format.md`). Notification channel:
`{config.channels.telegram.chat_id}` if enabled. Today's date: always from
the environment, never guess.

## Prime directive — critique with memory, or don't bother

A one-off "be the devil's advocate" prompt produces sharp critique that
resets to zero every session — critique as entertainment. This board exists
to make critique **compound**: a challenge issued once is remembered,
tracked, and re-raised until answered or beaten on the merits.

**If the user asks for an ad-hoc adversarial persona on a tracked decision,
don't improvise one — run `convene`.** An improvised critic with no memory is
the failure mode this skill replaces.

## The seats

| Agent | Seat | Memory (local backend) |
|---|---|---|
| `board-veteran` | Domain veteran — real or just interesting? | `_memory/veteran.md` |
| `board-pragmatist` | Downside-protection — the safe path's strongest case | `_memory/pragmatist.md` |
| `board-operator` | Execution accountability — committed vs. done | `_memory/operator.md` |

If `config.board.memory_backend` is `nessie`, pass each seat its Nessie
context ID instead of a local file path (configure these once and note them
here).

## Subcommands

Parse the argument after `/board`. No argument → `convene`.

### convene

1. **Run all three board agents IN PARALLEL** — agent names `board-veteran`,
   `board-pragmatist`, `board-operator` — in a single message with three
   agent calls. Pass each its memory location from the table above and the
   environment date. Each agent reads its own memory, reads the Decision
   Ledger, optionally checks recent activity, and returns: (1) sharpest
   challenge, (2) what changed since last board, (3) one demand with a date.
2. **Synthesize** — three short verdicts, then:
   - **Where they agree** (consensus across three different lenses is the
     closest this board gets to a fact)
   - **Sharpest unresolved challenge** (the one nobody answered)
   - **ONE action** with an owner and a date. Not three. One.
3. **Write minutes** to `{config.decisions.board_minutes_path}/<YYYY-MM-DD>.md`
   per the format spec. Append-only; if a session already exists for today,
   suffix `-2`.
4. **Update each seat's memory.** For each seat, append a dated entry to its
   `## Session Log` (challenge delivered, response if any, demand + date) and
   update `## Demands outstanding` (add new, mark met/conceded). Do this
   directly on the local memory files — never let an agent edit its own
   memory; only the convener writes, after synthesis.
5. **Brief the user** on the configured channel: three lines (one per seat's
   challenge) + consensus point + unresolved challenge + one action with a
   date. No analysis. If no channel is configured, the minutes file is the
   record — say so.

### minutes

List `{config.decisions.board_minutes_path}/*.md` (excluding README): date,
session number, consensus line, the ONE action + due date, and whether that
date has passed. Newest first. Close with one line of push: name the most
recent committed action and ask whether it shipped — if not, suggest
`/board convene`.

## Deadline trigger

When any open decision has a deadline within 14 days (check frontmatter
`deadline` against the environment date), suggest `/board convene` at the
next natural moment — the board is most useful immediately BEFORE a forced
decision, not after.

## Editing rules

- Minutes are append-only, dated, never rewritten — they're the record that
  critique happened and what it cost.
- Memory: Session Log entries are append-only. Never delete a seat's memory —
  the memory IS the tool.
- Composes with `/decide`: a board demand the user accepts should land in the
  relevant decision file's Decision Log (via `/decide review` or `commit`),
  not float unrecorded.
