# Master Resume Builder

Build or extend `master-resume.md`, the single source of truth for every career
fact in this repo.

Use this when `master-resume.md` does not exist, when the user says "build my
master resume", or when another skill discovers a gap that needs to be recorded
permanently.

## Why this matters

Every tailored resume and cover letter SELECTS from this file. Nothing
downstream may state a fact that is not in here. That makes this file the
quality ceiling for the whole repo: a thin Master Resume produces thin, generic
applications no matter how good the tailoring is.

## Which path

**Archived Resumes exist in `resume-archive/`** — extract first, then confirm,
then interview for what is missing. This is the normal path and it is described
below.

**The archive is empty** — jump to [the interview path](#the-interview-path).

`docs/adr/0007-archive-first-onboarding.md` records why extraction leads and
what that traded away. Read it before changing the order.

## Inputs

1. **`templates/master-resume.template.md`** — the required structure. Read it
   first; the section headings and the two formatted blocks (contact, job
   headers) are consumed literally by `scripts/txt_to_pdf.js`.
2. **`resume-archive/`** — the Archived Resumes.
3. **`examples/master-resume.md`** — a filled-in example showing the target
   depth. Use it to calibrate, never as a source of facts.
4. **The user.** The only source that turns a candidate claim into a fact.

## 1. Report what you found

Walk `resume-archive/` recursively and sort every file into three buckets, then
report the counts **before** processing anything. Read the directory at this
moment: an earlier listing in the conversation predates the user copying their
files in, which is the whole reason they are here.

> Found 7 files in `resume-archive/`:
> - **5 readable**: 2019-resume.pdf, resume-final-v3.docx, ...
> - **1 unreadable**: scan-2014.pdf (scanned image, no text layer)
> - **1 ignored**: .DS_Store
>
> Processing the 5 readable ones. Shall I go ahead?

Name every unreadable file with a one-line reason. This is the step that catches
the two failures people never discover on their own: a scanned PDF that looks
perfectly good to them and is empty to you, and an archive folder they never
actually copied their files into.

For a `.docx` on macOS, `textutil -convert txt -stdout "<file>"` works with no
dependencies. Read `.pdf` files directly. When a format defeats you, say which
file and offer the fallback: they can paste its text into the conversation.

## 2. Extract into a Draft Master Resume

Pull every role and every accomplishment claim out of the readable files.
Combine them into a Draft Master Resume, in the template's structure.

A Draft Master Resume holds candidate claims, not facts. Nothing selects from it
until it has been through the Confirmation Pass.

**Deduplicating.** The same role appears in six resumes with drifting wording.
Keep the most recent variant as the primary, and hold the alternates under that
role for the Confirmation Pass. A person's later description of their own work
is usually the better-understood one.

**Rewriting.** Propose an improved wording for each bullet, within this
boundary.

You may fix grammar, tense, and parallelism; cut filler like "responsible for"
and "helped to"; restructure into action, method, and result when all three are
already present in the source; tighten length; and make a verb precise at the
same strength.

The claim itself stays exactly as strong as the source made it. Keep the
original's ownership verb (`contributed to` stays `contributed to`, `used` stays
`used`, `collaborated` stays `collaborated`), the original's numbers and
scope, the original's technologies, the original's attribution to a team, the
original's stated outcome, and the original's hedges (`helped`, `with the team`,
`supported`).

When a bullet states no outcome, leave it without one and tag it. Those tags
become the gap-fill interview in step 5, which is where a missing result gets
answered by the person who was there.

## 3. Resolve the conflicts first

Archived Resumes contradict each other. Settle those before any bullet review,
in one pass:

- Date ranges that disagree between documents
- The same job under two different titles
- The same accomplishment with two different numbers

Ask about all of them together, and record the resolutions in **Canonical
facts** so they never come up again.

## 4. The Confirmation Pass

This is where candidate claims become facts. Work **one role at a time**.

**Flag the risky bullets before you post the block.** Any bullet carrying a
number the user would have to defend in an interview, or a strong ownership verb
(`led`, `owned`, `architected`, `built`, `designed`), gets called out by name
inside that role's block and asked with the Guardrail question from `AGENTS.md`.
Flagged bullets never ride in on a bare accept, so the shape below is the
minimum, not a simplified illustration.

For each role, show the extracted bullets as a numbered list, each as
`original → suggested` so the change is visible, then the flagged ones by
number, then the closing ask:

> Here is what I found for **Senior Engineer, Acme (2019-2023)**.
>
> 1. Responsible for maintaining the payments API
>    → Maintained the payments API
> 2. Helped migrate the billing service to Postgres
>    → Helped migrate the billing service to Postgres
> 3. Led the checkout rewrite
>    → Led the checkout rewrite
> 4. Reduced page load times by 60%
>    → Cut page load time by 60%
>
> Two of these I need a direct yes on before I record them:
>
> - **3.** Is it accurate to say "Led the checkout rewrite"?
> - **4.** Is it accurate to say "Cut page load time by 60%"?
>
> And which of the rest are not accurate as written?

A bare "looks good" accepts the unflagged bullets, and that is the intended
path. It does not accept 3 and 4; those wait for their own answer, so the person
is looking straight at the risky claims at the moment they accept the rest.
`docs/adr/0007-archive-first-onboarding.md` explains the trade.

## 5. Interview for what is missing

Extraction gives you three or four bullets per role. A good Master Resume has
ten to twenty. This step is where the difference comes from, and it is the part
that makes the file worth having.

Go role by role, newest first, and prefer specific questions over open ones:

- "What was broken when you joined that team, and what did it look like when you
  left?"
- "What is something you built there that people still use?"
- "What was the hardest bug or outage you owned end to end?"
- "Who did you work with outside your own team, and on what?"
- "What did you get promoted or recognized for?"
- "What did you teach other people?"

Start with the bullets tagged as outcome-missing in step 2. Each one is already
a question: they said what they did, so ask what changed as a result.

When they describe something vaguely, push once for the concrete version: what
did the number go from and to, over what period, and how do they know.

Draft each new bullet and confirm it with the Guardrail question before it goes
in.

## 6. Write the file

Write `master-resume.md` at the repo root, following the template structure
exactly, deleting the template's `>` instruction blocks as you go.

Then record what you ingested, so a later run can tell new material from old:

```
History/archive-ingested.md
```

One line per file: the filename and the date it was folded in.

## 7. Sanity check

- Do the dates form a continuous history, and are gaps explainable?
- Does every claim in **Summary framings** have a supporting bullet below it?
- Is every technology in the inventory something they have actually used?
- Are the contact and education blocks in the exact format the template shows?

Report anything thin, and offer to interview further on it.

## The interview path

With no Archived Resumes, the interview is the whole build. Use the questions in
step 5, and cover every role from scratch. Budget 30 to 60 minutes and say so up
front.

If they are changing fields or returning to work, interview against their target
roles instead: ask what they want to do next, find real postings for it, and
work backward. For each major requirement, ask whether they have done that and
what it looked like.

Then continue at step 6.

## Extending an existing Master Resume

**New files in the archive:** the same sequence as a fresh build, scoped to the
new files. Do not shortcut to extract-and-confirm; the steps in between are the
ones that matter most here.

1. **Report the counts** (step 1), over the new files only.
2. **Extract** them into a Draft Master Resume (step 2).
3. **Resolve conflicts** (step 3) — and here that means against the existing
   **Canonical facts**, not just between the new files. New files are exactly
   where a date or a title disagrees with something already confirmed. Ask about
   all of them together, then update the Canonical facts with the resolutions.
4. **Confirmation Pass** on what came out (step 4).
5. **Gap-fill interview** (step 5), scoped to the roles the new files touched and
   to any bullet the extraction tagged as outcome-missing.

Leave every other role untouched, and append the new filenames to the ledger.

**A single confirmed fact from another skill:** append the bullet to the right
role, tell the user where it went, and stop. No interview.

## Hold the line on

- A bullet goes in the Master Resume once the user has confirmed it, and not
  before. A Draft Master Resume is not a Master Resume.
- Archived Resumes overstate things. Treat every claim in one as a candidate
  that has to survive the Confirmation Pass, however confidently it is written.
- A true bullet with no number beats a number nobody can defend. When a metric
  has no source, ask for it or leave it out.
- The file is a bank, and it is supposed to be far too long. Length here is the
  feature.
