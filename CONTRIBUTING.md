# Contributing

Thanks for looking. This repo is a **template**, not an application. The most
common good contribution is a bug report about something that broke on a machine
unlike the one it was built on.

## Before you open anything

**Never include your own resume data.** Not in an issue, not in a PR, not in a
screenshot. Personal files are gitignored by default for exactly this reason, and
a paste into a public issue defeats that. If you need to show a failure, use the
fictional example in `examples/`, or redact.

Run the scanner on your own tree before pushing a fork:

```bash
bash scripts/check-clean.sh "Your Name" "Your Employer" yourdomain.com
```

## Good issues

- A PDF that renders wrong, with the `.txt` that produced it (redacted, or from
  `examples/`), your OS, and your browser
- `setup.sh` failing a check it should pass
- `check-clean.sh` missing a pattern it should catch, or flagging something it
  should not
- A skill that led an agent into a bad workflow, with the prompt you used

## Before you open a PR

**Read `docs/adr/` first.** Several things in here look like oversights and are
not. Each one has a decision record explaining why. The three most likely to be
"fixed" by mistake:

| ADR | What it protects |
| --- | --- |
| `0002` | The `.claude/skills/` stubs are meant to contain no content |
| `0005` | PDF generation must stay dependency-free |
| `0006` | The role-type taxonomy was removed on purpose |

If you disagree with a decision record, that is a fair conversation. Open an
issue arguing against the ADR rather than a PR quietly reversing it.

## House rules for changes

- **`AGENTS.md` is canonical.** Agent instructions go there or in `skills/`, not
  into a tool-specific file. `CLAUDE.md` is a pointer and stays a pointer.
- **`skills/*.md` is the real content.** The `.claude/skills/` files exist only
  so Claude Code can discover the skills.
- **Use the glossary.** `CONTEXT.md` defines the words this repo means precisely,
  including Skill versus Competency.
- **No npm dependencies** in `scripts/`. Puppeteer stays an optional fallback the
  user installs themselves.
- **Nothing real in `examples/`.** It is a fictional person on purpose.

## Adding a new skill

1. Write `skills/your-skill.md` as the canonical instructions
2. Add a pointer stub at `.claude/skills/your-skill/SKILL.md`
3. Add a row to the skills table in `AGENTS.md`

## License

Contributions are accepted under the MIT license in `LICENSE`.
