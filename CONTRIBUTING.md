# Contributing

## The one rule that overrides all others

This repo's entire premise is that `os/` and `docs/` are generic — no real
person's name, employer, family, specific figures, or identifying detail. A
PR that adds any of that, even as an "example," will be asked to genericize
before merge, no exceptions. Before opening a PR that touches `os/` or
`docs/`, run the check in `docs/cookbook/sanitization-checklist.md` yourself.

## What's easy to contribute

- A new scheduled agent under `os/skills/<name>/SKILL.md`, following the
  existing skills' structure (frontmatter, config references, no hardcoded
  personal detail). See `docs/patterns.md` for the underlying patterns this
  repo is built from.
- A worked vertical example under `examples/verticals/` — show how you
  adapted the board/ledger/skills for your field, using invented or clearly
  fictional example content, not your actual private decisions.
- A scheduler recipe in `docs/cookbook/scheduling.md` for a platform not yet
  covered.
- Bug fixes to config-schema mismatches (a skill referencing a
  `{config.*}` field that doesn't exist in `os.config.example.yaml`, or vice
  versa) — these are easy to introduce and easy to miss; a PR that fixes one
  should also grep for the same class of mistake elsewhere.

## What needs discussion first (open an issue before a PR)

- Anything that changes `os/CLAUDE.md`'s barbell pipeline structure — this
  is load-bearing for every agent's role discipline.
- Adding a new required config field (breaks existing users' configs).
- Anything that would make a skill send something (email, a message) rather
  than draft it — the draft-only default is deliberate, not an oversight.

## PR checklist

- [ ] `bash scripts/check-sanitization.sh` passes on your diff, and you have
      visually inspected any changed demo assets.
- [ ] If you added or renamed a skill, `config/os.config.example.yaml`'s
      `agents:` block is updated to match (see the `skill:` field convention).
- [ ] If you touched an agent's memory format, `docs/decision-format.md` is
      updated to match.
