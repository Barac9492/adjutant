# Vertical example: venture capital

A worked example of tuning agent-os for VC work. This is illustrative —
invented example content, not anyone's real portfolio or decisions — meant
to show *what kind of customization* is useful, not to be copy-pasted
verbatim into your own config.

## Board tuning

`config/os.config.yaml`:
```yaml
board:
  veteran:
    domain: "venture capital"
```

That single field changes the veteran seat's implicit frame of reference
(fund economics, LP dynamics, the difference between a fundable thesis and
an interesting one) without touching `os/agents/board-veteran.md` at all —
the generic seat already asks "is this real or just interesting," which
translates directly.

## Decision Ledger example entries (invented, not real)

```yaml
---
id: fund-structure-choice
title: "On solo GP vs. co-GP structure"
status: open
category: fundraising
deadline: 2027-03-01
deadline_basis: "LP conversations stall without a firm structure to pitch"
lean: "leaning co-GP — solo GP may not clear the regulatory bar in some jurisdictions"
review_count: 0
last_reviewed: null
---

## What's being decided
Whether to structure the first fund as solo GP or bring in a co-GP for
regulatory eligibility and shared operating load.

## What Would Change My Mind
- A confirmed co-GP candidate commits in writing
- Regulatory counsel confirms solo GP is viable in the target jurisdiction
- An LP anchor conditions their commitment on a specific structure
```

## Scheduled agents worth enabling first

For LP-facing work, `meeting-prep` and `followups` pay off fastest — most VC
work is relationship-and-commitment-tracking heavy, and those two agents are
the most directly leveraged in that cadence. `weekly_synthesis` becomes
useful once you have 3+ other agents running and want a single rollup rather
than five separate check-ins.

## What NOT to build into core from this vertical

Deal-sourcing logic, specific LP-database integrations, or fund-regulatory
compliance rules are all genuinely valuable but genuinely vertical — they
belong in your own private fork or in a separate downstream project, not in
`os/`. This file is deliberately just configuration and Decision Ledger
examples, not a VC-specific skill.
