---
name: followups
description: Scan email, calendar, and notes for commitments (things you owe, things owed to you) and track them to completion — surfacing overdue items without nagging.
user-invocable: true
---

# Follow-up Tracker

An accountability system: extract commitments from your communications, track
them to done, and surface the ones going stale — without turning into a nag.

Reads config from `{config.identity.name}`, `{config.channels.telegram.chat_id}`,
`{config.vault.path}` (if you keep a follow-ups file there).

## Execution steps

### 1. Load state
Read your existing follow-ups file (create if missing) and the timestamp of
the last run.

### 2. Scan for new commitments
- **From email**: look for commitment language — "I'll send this by...",
  "can you...", "let's follow up on...". Also note threads where you sent
  something and are still awaiting a reply.
- **From calendar**: past meetings often imply action items (check
  descriptions/notes); future meetings imply prep work.
- **From notes/decision logs**, if you keep them: deferred decisions carry
  implicit follow-ups.

### 3. Classify each commitment

```
### [Commitment title]
- Type: YOU_OWE | OWED_TO_YOU | MUTUAL
- Source: email / meeting / conversation
- Contact: [who]
- Deadline: [date, "ASAP" if implied, "NONE" if open]
- Status: PENDING | OVERDUE | DONE | DROPPED
- Context: [one line]
```

Priority order when several compete for attention: external deadlines before
internal ones; most-overdue first; your highest-stakes relationships before
routine ones; things YOU_OWE before things OWED_TO_YOU (you control those).

### 4. Auto-resolve before flagging
Before marking anything overdue, check whether you already handled it — search
sent mail to that contact in the relevant window. If a matching sent message
exists, mark DONE automatically and don't surface it as overdue. If the thread
has gone cold with no activity for a while, flag it for review instead of
auto-closing it.

### 5. Update the follow-ups file
Group into: Overdue, Due This Week, Upcoming, Waiting On Others, Completed
This Week. Keep it clean — archive completed items on a regular cadence
(weekly synthesis, if you run that skill, is a good place for this).

### 6. Alert on overdue items
If anything is overdue, surface **the single most critical item**, not a
list — one thought per message. State facts, offer to help; never state days-
overdue with implied judgment. If the same item has been surfaced repeatedly
and dismissed, stop surfacing it — respect the no.

### 7. Optional: draft the follow-up
If a commitment has an originating thread, you may draft (never send) a
follow-up reply in that thread, matching your own tone. If there's no
originating thread (e.g. a verbal commitment from a meeting), don't guess the
content — ask for a few keywords first, then draft.

Any reminder you create in your own calendar, with no external attendees, is
safe to create directly. Anything that would notify or reach another person
(sending a drafted email, inviting someone) requires the user's explicit
go-ahead — this skill only drafts and proposes.

## Rules
- Be conservative extracting commitments — track real promises, not vague
  "let's catch up sometime."
- If ambiguous, track as PENDING with a note rather than skipping it.
- Don't nag: surface once per item per escalation tier, not on every run.
- Don't stack multiple alerts into one message.
