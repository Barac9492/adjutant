---
name: meeting-prep
description: Deliver a prep briefing shortly before each meeting — who's attending, relevant history, open questions — and capture commitments after it ends.
user-invocable: true
---

# Meeting Prep

Runs on a schedule (e.g. every 30 min during work hours) or on demand. Two
jobs: brief you before a meeting starts, and capture commitments after it
ends so nothing said out loud gets lost.

Reads config from `{config.identity.name}`, `{config.channels.telegram.chat_id}`,
`{config.vault.path}`.

## Execution steps

### 1. Check calendar
Look at events in the next 30-60 minutes. If nothing is starting soon, exit —
nothing to do. Only prep meetings 15-40 minutes out; don't prep something
already underway or hours away. Skip "Focus Time," lunch blocks, and other
non-meeting calendar entries. Skip a meeting you already prepped this cycle.

For substantive meetings (2+ attendees, or any external contact), you may
auto-create a short "Prep: {meeting}" block in your own calendar in the gap
before it — that's a self-only calendar edit, safe to do without asking.
Don't do this for recurring internal standups/1:1s.

### 2. Gather intelligence
For each attendee, assemble a short brief: who they are, relationship warmth,
last contact, anything outstanding between you, anything to watch for. Pull
from whatever sources you maintain — a relationship/contacts store, recent
email threads, your notes vault (`{config.vault.path}`) for deal/project-
specific context if relevant. If you have no context on someone, say so
honestly rather than inventing a plausible-sounding brief.

### 3. Compose the briefing
```
## Meeting Prep: [Title]
Time / Location or link

### Attendees
- [Name] — role, relationship, recent context

### Context
What this meeting is about, backstory from prior threads.

### Key points to raise
### Open questions
```

### 4. Deliver
Send as one natural message via `{config.channels.telegram.chat_id}` — not a
bullet dashboard, a short brief someone could read on a phone in 15 seconds.
Match language to the meeting's own language if that matters to you.

### 5. Post-meeting capture (~30-60 min after it ends)
Send a short check-in tailored to the meeting type — what got promised, what's
next. Use a 2-3 question format people can answer in a few words, not
"summarize the meeting" (that has near-zero response rate). When commitments
come back:
- Update your follow-ups store with what's owed, by whom, by when (pairs well
  with the `followups` skill if you run it).
- You may draft (never send) any follow-up email implied by the commitment.
- A reminder in your own calendar (no external attendees) is safe to create
  directly; anything reaching another person needs your explicit go-ahead
  before it goes out.
- Don't check in more than once per meeting — respect silence.

## Optional: scheduling requests
When asked to schedule a meeting with someone:
1. Find their contact info from your own records; ask if you can't find it.
2. Propose 2-3 open slots (respect your own working-hours preferences).
3. Present the options in one message; on the user's choice, create the event
   — since it has an external attendee, confirm with the user before sending
   the invite.

## Rules
- Never create a calendar event or send an invitation with external attendees
  without the user's explicit confirmation.
- Always surface pending invitations with context (who, conflict check,
  optional/required) rather than auto-accepting or auto-declining.
- Keep prep briefs honest — no fabricated context.
