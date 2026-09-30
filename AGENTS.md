# Resume Kit

A workspace for building a master resume once, then generating tailored resumes
and cover letters from it for specific job postings.

This file is the canonical instruction set for any coding agent working in this
repo. It is agent-agnostic and works with Claude Code, Codex, or anything else
that reads a project instruction file.

## The core idea

There is exactly one source of truth for career facts: **`master-resume.md`** at
the repo root.

It is a bank, not a resume. It is deliberately much too long to send anyone. Every
tailored document SELECTS from it and reorders. Nothing downstream may state a
fact that is not in it or confirmed by the user in the current conversation.

Tailored resumes are never the source for the next tailored resume. Errors
compound that way. Always go back to `master-resume.md`.

## Skills

Read the relevant file and follow it. Do not improvise a workflow that one of
these already covers.

| When the user... | Read |
| --- | --- |
| Says "start", has just cloned this repo, or `master-resume.md` is missing | `skills/start.md` |
| Wants to build or update their master resume | `skills/master-resume-builder.md` |
| Says their Archived Resumes are in Google Docs or Drive | `skills/google-docs-export.md` |
| Shares a job posting, or asks for a resume for a company | `skills/resume-builder.md` |
| Asks for a cover letter | `skills/cover-letter-builder.md` |

## Vocabulary

`CONTEXT.md` at the repo root is the glossary. Use its terms exactly in this
file, in `skills/`, and in the stubs. It names two exemptions, `README.md` and
what you say out loud to the user, and explains why. It resolves words that are
genuinely overloaded here, including **Skill** (an agent workflow) versus
**Competency** (a line in a resume's CORE SKILLS section).

## Modifying this repo

If you are changing how this kit works rather than using it, read
**`docs/adr/` first.** Several things that look like oversights are deliberate,
and each ADR names one. The most likely to be "fixed" by mistake:

- `0002` — the `.claude/skills/` stubs are meant to be empty of content
- `0005` — PDF generation must stay dependency-free
- `0006` — the role-type taxonomy was removed on purpose
- `0007` — the Confirmation Pass confirms per role, not per bullet

`docs/STATUS.md` records what has and has not been verified, and what is still
open.

## Layout

```
master-resume.md          the source of truth (gitignored, you create it)
CONTEXT.md                glossary — the words this repo uses and means
templates/                the master resume template
skills/                   canonical workflow instructions
docs/adr/                 why this repo is built the way it is
docs/STATUS.md            what is verified, what is open
scripts/
  setup.sh                environment preflight; `--agent` when you run it
  txt_to_pdf.js           .txt resume -> ATS-safe PDF
  check-clean.sh          scans for personal data before publishing a fork
  check-clean.test.sh     tests for check-clean.sh; runs in CI
examples/                 a fictional worked example, committed on purpose
opportunities/            one folder per company you apply to (gitignored)
resume-archive/           Archived Resumes, source material (gitignored)
History/                  log of what was created and why (gitignored)
```

### Per-company folders

```
opportunities/[Company]/
  Job Description - [Job Title] - [Company].txt     original URL on line 1
  [Name] - Resume - [Job Title] - [Company].txt
  [Name] - Resume - [Job Title] - [Company].pdf     generated from the .txt
  [Name] - Cover Letter - [Job Title] - [Company].txt
```

Use the company name exactly as it appears in the posting.

## Privacy

Everything personal is gitignored by default: `master-resume.md`,
`opportunities/`, `resume-archive/`, `History/`, and local agent settings. A user
can commit their own data by editing `.gitignore`, but the default is safe.

`examples/` is the one content directory that is committed. It contains a
fictional person. Never put real user data there.

Before anyone publishes a fork, `bash scripts/check-clean.sh` scans the tree for
personal data and exits nonzero on a hit in tracked or untracked files. It needs
search terms (your name, employers, domain) and fails without them. Personal data
in ignored files only warns. It cannot read `.docx` or `.pdf`.

## Accuracy guardrails

These apply to every document produced in this repo, without exception. They
outrank keyword matching, they outrank making the application look stronger, and
they outrank the user's own enthusiasm in the moment.

- If the user says **"contributed to"**, do not write "built" or "led".
- If the user says **"collaborated with"** a team, do not write "managed" it.
- If the user says they **"used"** a technology, do not write "architected" or
  "designed" it.
- If the user has **adjacent** experience, do not claim direct experience.
- If a number cannot be defended in an interview, leave it out. A true bullet
  with no metric beats a metric that collapses under one follow-up question.
- When the target company operates at far greater scale than the user's
  experience, frame that experience as transferable, not equivalent.

When uncertain, ask the user this exact question and wait for an answer:

> "Is it accurate to say [exact proposed wording]?"

Never treat silence as approval for something you inferred rather than were
told.

**One exception, and only one.** During the Confirmation Pass in
`skills/master-resume-builder.md`, a user accepts a whole role's extracted
bullets at once. Bullets carrying an unverifiable number or a strong ownership
verb are still asked individually, by name. Everywhere else, per claim.
`docs/adr/0007-archive-first-onboarding.md` records why the exception exists.

## Fetching job postings

Ask the user to paste the posting text. That is the primary path and it always
works.

Most applicant tracking systems (Greenhouse, Lever, Ashby, Workable) block
automated fetching, so a plain HTTP request usually returns a login wall or
nothing. If you have a real browser automation tool available, it is worth one
attempt. Otherwise ask for a paste. Do not burn several turns trying to fetch.

Always save the posting text to the company folder before doing anything else
with it. Postings get taken down, and this is often the only copy that survives.

## Generating PDFs

```
node scripts/txt_to_pdf.js "opportunities/[Company]/[resume].txt"
```

The `.txt` is the source of truth and the PDF is derived from it. Never
copy-paste resume text into a word processor to produce the PDF; it breaks the
layout and often the ATS parsing.

The script has no npm dependencies. It renders through a Chrome-based browser
already on the machine. If it cannot find one, its error message lists the
options (`CHROME_PATH`, or `npm install puppeteer`).

This command launches a real browser process, not a library call. On macOS,
Codex's default sandboxed execution blocks that unconditionally: it denies
the browser the system calls it needs just to start, with no flag or
alternate browser that works around it (openai/codex#30043). If you are
Codex running on macOS, check for `CODEX_SANDBOX` in your environment before
you run this command (or `scripts/setup.sh`) at all, and if it is set,
request escalated or unsandboxed permissions for that one command up front —
do not run it inside the sandbox first and wait for it to fail. The script
also detects this itself and exits with the same guidance instead of
attempting the launch, but asking for escalation before running it is faster
for the user: one approval prompt instead of a failed attempt and a retry.
Other sandboxed agents can hit the same wall without setting that variable;
if the script reports a Chrome crash (SIGABRT), the fix is identical.

It parses the `.txt` literally, so the layout rules in `skills/resume-builder.md`
are functional, not cosmetic.

## Local overrides

If LOCAL.md exists, read it, and it overrides anything above.
