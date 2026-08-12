# Design decisions

For anyone modifying this repo, including a future coding agent picking it up
cold. It records what was decided and why, so choices that were deliberate do not
get "fixed" by someone who assumes they were accidents.

Written 2026-08-12, covering the initial build.

---

## Origin

This started as one person's private job-search repo: a master resume, 42 company
folders, resume-generation scripts, and application history. The goal was to
extract the *tool* from it and publish that, leaving all personal data behind.

The private original is not in this repo's history. This repo was built from
scratch and its first commit is its first commit. That was deliberate: scrubbing
185 files subtractively fails open, since anything missed still ships. Building
additively meant reviewing every file by hand instead.

---

## Load-bearing decisions

These have real reasoning behind them. Change them if you have a better idea, but
know what you are trading away.

### The master resume is the only source of truth

`master-resume.md` is a deliberately over-long bank of every truthful claim. Every
tailored document SELECTS from it.

Tailored resumes are never the source for the next tailored resume. Errors
compound that way: an overstatement introduced once gets copied forward and
hardens into fact. Always go back to the master.

### User data is gitignored by default

The failure mode this prevents: someone forks this, fills it with their real
resume and recruiter correspondence, and pushes it to a public GitHub repo.

Defaults decide outcomes. Someone who wants to commit their own data can delete a
line from `.gitignore`; someone who never thinks about it is safe. `examples/` is
the single committed content directory and it is fictional.

This is the highest-value decision in the project. Do not weaken it for
convenience.

### Agent-agnostic, not Claude-specific

`AGENTS.md` is canonical. `CLAUDE.md` is a one-line pointer at it. Workflows live
in `skills/*.md` as plain markdown, with thin `.claude/skills/*/SKILL.md` stubs
that exist only for Claude Code's auto-discovery.

The requirement is that this works in Codex, Cursor, or anything else that reads
files in a directory. Two consequences that look like oversights but are not:

- **No content in the `.claude/` stubs.** They are five lines each and point at
  the canonical file. Duplicating workflow text there would guarantee the two
  copies disagree within a month.
- **No mandated browser-automation tool for fetching job postings.** The old
  private repo required a specific Chrome MCP integration and forbade `curl`.
  Correct for that setup, meaningless elsewhere. See below.

### Paste-first for job postings

Greenhouse, Lever, Ashby, and Workable block automated fetching. Pasting text
always works, in every agent, on every site, including postings behind a login.

Browser automation is mentioned as an optimization for agents that have it, never
as the primary path. A ladder of three fallbacks reads as "try three things and
fail twice" to someone on their first run.

### `scripts/txt_to_pdf.js` has no npm dependencies

It renders through a Chrome-based browser already on the machine. Zero-dependency
is a genuine feature: no install step, no lockfile, no supply chain, no version
drift. It is most of the reason setup is one shell script.

Puppeteer is an **opt-in escape hatch only**, lazily required, for people whose
machines have no usable browser. Do not promote it to a real dependency.

### The `.txt` is the source of truth, the PDF is derived

The generator parses the `.txt` literally. That is why the layout rules in
`skills/resume-builder.md` (ALL CAPS headings, `|` in job headers, two or more
spaces before dates, no bullet characters) are functional rather than cosmetic.

Benefits: diffable between applications, ATS-safe by construction, reproducible.
Never introduce a path that produces a PDF some other way.

### There is no role-type taxonomy

The private original classified every posting into one of three types, which then
selected a cover letter format. That was removed on purpose.

The reasoning: the master resume already holds every fact, and the posting already
determines which facts surface. The taxonomy forced a classification step that an
agent can skip by reading the posting directly. It was also inherently personal to
one career, so a nurse or a designer forking this would have to replace it.

`skills/cover-letter-builder.md` replaces it with format *dimensions*
(outcome-led, craft-led, mission-led) chosen per posting. **Do not reintroduce a
fixed taxonomy.**

### Accuracy guardrails outrank everything

In `AGENTS.md`. They outrank keyword matching, outrank making an application look
stronger, and outrank the user's enthusiasm in the moment.

The specific rule that matters most: never treat silence as approval for something
inferred rather than stated. The whole system's value depends on the output being
defensible in an interview.

---

## Incidental decisions

Low stakes. Change freely.

- **Name `resume-kit`**, MIT licensed.
- **Fictional persona:** Alex Doe, a backend engineer, applying to Northwind
  Traders. Contoso, Fabrikam, Adventure Works, and Northwind are standard
  placeholder company names. Contact details use `example.com` and the reserved
  `555-01xx` phone range, so `check-clean.sh` can allowlist them safely.
- **`setup.sh` is non-interactive.** It checks and reports, then prints a prompt
  to paste into an agent. Making it interactive was considered and rejected: the
  conversational part is the agent's job.
- **Section heading names** in the resume layout (`CORE SKILLS`, `WORK
  EXPERIENCE`, `EDUCATION`). The parser keys off `SKILL` and `EXPERIENCE` as
  substrings, so renaming needs a matching parser change.

---

## Deliberately excluded

Cut from the private original, with reasons:

| Cut | Why |
| --- | --- |
| Google Docs integration (620 lines, OAuth) | Support burden, least-finished piece, and the skill it belonged to already said not to use Google Docs |
| Four hardcoded `generate_resume*.js` files | They were not generators. Resume content was inline as JS constants, so each application spawned a copy |
| `assets/` cheat sheets | Personal interview-prep notes, including one for a specific assessment vendor |
| `networking/` transcripts and QR code | Personal |
| Application `History/` entries | Personal. The directory ships empty and gitignored |
| `resume-archive/` contents | 27 real historical resumes |

---

## Verified state

Checked on macOS at build time:

- `setup.sh` passes all checks
- The example PDF is generated by the real toolchain, and both pages were
  visually reviewed
- Gitignore verified per-file for both what must be ignored and what must be
  tracked
- `check-clean.sh` detectors tested against a planted leak file; all four fired

**Not verified:** the Linux and Windows browser paths in `txt_to_pdf.js` and
`setup.sh` are written from knowledge, not tested on those platforms. The
puppeteer fallback path is likewise untested. If someone reports a PDF failure on
a non-Mac machine, look there first.

---

## Open items

- No git remote. Never pushed. Publishing is a manual step.
- After pushing, GitHub's "Template repository" setting needs to be enabled so
  people get "Use this template" rather than a fork.
- `LICENSE` names a copyright holder, which is the only personal name in the
  repo and the only expected hit from `check-clean.sh`.
- The cleanup plan for the original private repo lives outside this repo, at
  `resume-tools/CLEANUP-original-repo.md`. It has not been executed.
