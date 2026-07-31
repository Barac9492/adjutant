# adjutant

*A forkable Claude Code operating system for turning open decisions and scattered notes into action.*

[한국어](README.ko.md)

> **Status: public pre-beta.** Adjutant is an opinionated, sanitized template
> extracted from a personal workflow. Its local core is ready to try; external
> integrations and scheduled automation require your own setup. It is not a
> hosted assistant or a one-click automation product.

![The board convening on a staged decision. Real model output, fictional scenario.](docs/assets/demo.gif)

*The board arguing about a fictional "Jordan" scenario, not anyone's real
deliberation. The text is genuine output from the prompts in
`os/agents/board-*.md`, not scripted copy. The minutes it produces follow the
single-file format in `docs/decision-format.md`.*

![A morning briefing delivered via Telegram. Real model output, fictional scenario.](docs/assets/briefing.png)

*This uses the same rule: a fictional "Jordan" scenario and genuine output from
`os/skills/briefing-morning/SKILL.md`. A real briefing is one short message,
not a dashboard.*

## What this is

Adjutant gives Claude Code a persistent decision and execution cadence:

- a three-seat adversarial board that remembers its outstanding challenges;
- a Decision Ledger that interrupts repeated analysis when the missing input is
  commitment, not another model; and
- a barbell delivery pipeline: cheap scout, strongest planner, cheap builder,
  fresh-context review.

It runs on stock Claude Code and local Markdown files. You fork it, keep what
helps, and adapt the rest to your own work.

## Who it helps

This is a good fit if you:

- already use Claude Code and are comfortable configuring a local folder;
- keep notes in Markdown or can point the system at a notes folder; and
- want help closing consequential decisions or keeping execution honest.

It is **not** a fit yet if you need calendar, email, or Telegram automation to
work immediately with no connector setup. Those workflows are protocols in this
repository, not bundled integrations.

## Quickstart

Prerequisites: Claude Code, Git, and optionally a local Markdown notes vault.
A notes vault is required for `/today` and `/briefing`; it is not required for
`/decide`.

```bash
git clone https://github.com/Barac9492/adjutant.git adjutant
cd adjutant
./install.sh
```

The installer copies the skills and agents into `~/.claude` without overwriting
existing files. It also copies the operating doctrine to this repository's root
as `CLAUDE.md` unless you already have one, so Claude Code can load it for this
project.

Then open Claude Code in this directory and run:

```
/setup
```

Start with `/decide add` for a first useful result without any external
connection. Try `/today` after you configure a notes vault.

## What works now and what needs setup

| Surface | Included here | You still need |
| --- | --- | --- |
| `/decide` | Decision files and the re-analysis gate | A decision ledger created by `/setup` |
| `/board convene` | Three agents and local, append-only memory | An open decision and the ledger paths from `/setup` |
| `/today`, `/briefing` | Local Markdown workflows | A readable Markdown notes vault |
| Barbell delivery pipeline | `CLAUDE.md`, scout, implementer, reviewer, and gates | Work in the cloned repository or merge the doctrine into your own project |
| Scheduled skills | Seven workflow protocols plus the Decision Ledger weekly review | A scheduler plus a successful manual run of each routine |
| Email, calendar, Telegram | Safe workflow instructions only | Your own tested connector or adapter. None ships with Adjutant. |

Read [the integration guide](docs/cookbook/integrations.md) before enabling a
connector-dependent skill, and [the scheduling guide](docs/cookbook/scheduling.md)
before creating cron jobs.

## Why fork instead of install

This is closer to dotfiles than a library you install and forget. You are meant
to read it, cut what you do not need, and bend the rest until it fits your
life. The `/setup` wizard creates a useful baseline; the fork is deliberately
yours to shape.

## Specializing it for your field

`examples/verticals/` contains a worked venture-capital example. More vertical
examples are welcome through pull requests. The board's veteran seat is the
best starting point: set `board.veteran.domain` in your config, then rewrite
`os/agents/board-veteran.md` only if you need a genuinely different voice.

## Privacy and safety

- `config/os.config.yaml` is gitignored and is the only place a local setup
  should hold personal paths, chat IDs, or connector secrets.
- Connector-dependent skills are intentionally draft-only or confirmation-first
  for actions that affect other people. `email-triage` never sends email.
- `scripts/check-sanitization.sh` runs locally and in GitHub Actions on pushes
  and pull requests. It is a tripwire, not a substitute for reading every
  demo asset and diff before publishing.

See [the sanitization checklist](docs/cookbook/sanitization-checklist.md) and
[CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

[MIT](LICENSE).
