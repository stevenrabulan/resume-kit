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
| Has just cloned this repo, or `master-resume.md` is missing | `skills/setup.md` |
| Wants to build or update their master resume | `skills/master-resume-builder.md` |
| Shares a job posting, or asks for a resume for a company | `skills/resume-builder.md` |
| Asks for a cover letter | `skills/cover-letter-builder.md` |

## Modifying this repo

If you are changing how this kit works rather than using it, read
**`docs/DECISIONS.md` first.** It records which choices are load-bearing and why.
Several things that look like oversights are deliberate, and it names them.

## Layout

```
master-resume.md          the source of truth (gitignored, you create it)
templates/                the master resume template
skills/                   canonical workflow instructions
docs/DECISIONS.md         why this repo is built the way it is
scripts/
  txt_to_pdf.js           .txt resume -> ATS-safe PDF
  check-clean.sh          scans for personal data before publishing a fork
examples/                 a fictional worked example, committed on purpose
opportunities/            one folder per company you apply to (gitignored)
resume-archive/           your old resumes, source material (gitignored)
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
personal data and exits nonzero on a hit.

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

It parses the `.txt` literally, so the layout rules in `skills/resume-builder.md`
are functional, not cosmetic.
