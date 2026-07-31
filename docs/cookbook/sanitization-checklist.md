# Sanitization checklist

Run this before every merge to `main`:

```bash
bash scripts/check-sanitization.sh
```

The script runs in GitHub Actions for pushes to `main` and for pull requests.
It looks for a small set of high-risk text patterns: email addresses, numeric
Telegram chat IDs, Telegram bot-token-shaped strings, and GitHub
personal-access-token-shaped strings. It is a **tripwire**, not proof that a
diff is safe.

## Before you publish

1. Read every changed Markdown, YAML, and shell file. Confirm it contains no
   real name, employer, client, email address, chat ID, token, calendar title,
   or identifying figure.
2. Run the script above. Treat any match as blocking until you understand it.
   False positives are cheaper than a public leak.
3. Review the rendered diff, not just the source. A plausible-looking fictional
   name, client, or number can still make a reader think a demo contains real
   work context.
4. Keep personal paths, chat IDs, and connector secrets in the gitignored
   `config/os.config.yaml` or an external secret store.
5. If a new kind of secret or identifier appears in a contribution, extend
   `scripts/check-sanitization.sh` with a pattern that catches it.

## Images and other binary assets

`docs/assets/*.gif`, `*.png`, and other binary files are invisible to the text
scanner. For every new demo asset:

- Prefer generating the visible text from a reviewed source file rather than
  hand-typing it into a screenshot tool.
- Inspect the rendered frames yourself. For a GIF, extract or play enough
  frames to check every visible scene.
- Use clearly fictional names and scenarios. Do not rely on a technical claim
  that something is fictional if it plausibly resembles a real person or
  client.

A public push cannot be fully recalled once it has been cached or forked.
