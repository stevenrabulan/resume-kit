# Master Resume Builder

Build or extend `master-resume.md`, the single source of truth for every career
fact in this repo.

Use this when `master-resume.md` does not exist, when the user says "build my
master resume", or when another skill discovers a gap that needs to be recorded
permanently.

## Why this matters

Every tailored resume and cover letter SELECTS from this file. Nothing
downstream may state a fact that is not in here. That makes this file the
quality ceiling for the whole repo: a thin master resume produces thin, generic
applications no matter how good the tailoring is.

So the goal of this skill is not to fill in a template quickly. It is to run a
genuinely good interview.

## Inputs

1. **`templates/master-resume.template.md`** — the required structure. Read it
   first; the section headings and the two formatted blocks (contact, job
   headers) are consumed literally by `scripts/txt_to_pdf.js`.
2. **`resume-archive/`** — whatever the user has dropped in. Read all of it.
3. **`examples/master-resume.md`** — a filled-in example showing the target
   depth. Use it to calibrate, never as a source of facts.
4. **The user.** The most important input.

## Workflow

### 1. Read everything they gave you

Read every file in `resume-archive/`. For `.docx` on macOS, `textutil -convert
txt -stdout "<file>"` works without dependencies. For `.pdf`, read it directly
if you can.

Extract into a working list: employers, titles, locations, date ranges,
technologies, and every accomplishment claim you can find.

### 2. Reconcile before you interview

Old resumes contradict each other. Find the conflicts first and resolve them
with the user in one pass:

- Date ranges that disagree between documents
- The same job under two different titles
- The same accomplishment with two different numbers

Ask about all of them together. Record the resolutions in the **Canonical
facts** section so they never come up again.

### 3. Interview for depth

This is the real work. For each role, the source resumes will have three or four
bullets. You want ten to twenty. Draw them out.

Ask about one role at a time, and prefer specific questions over open ones:

- "What was broken when you joined that team, and what did it look like when you
  left?"
- "What is something you built there that people still use?"
- "What was the hardest bug or outage you owned end to end?"
- "Who did you work with outside your own team, and on what?"
- "What did you get promoted or recognized for?"
- "What did you teach other people?"

When they describe something vaguely, push once for the concrete version: what
did the number go from and to, over what period, and how do they know.

**If they have no old resume**, interview against their target roles instead.
Ask what they want to do next, find real job postings for it, and work backward:
for each major requirement, ask whether they have done that and what it looked
like.

### 4. Write bullets in their voice, then verify

Draft each bullet, then show it back before it goes in the file. The verification
question is always the same shape:

> "Is it accurate to say [exact bullet text]?"

Apply the accuracy guardrails in `AGENTS.md` while drafting. When in doubt, use
the weaker verb; you can always strengthen it later with their permission.

### 5. Write the file

Write `master-resume.md` at the repo root, following the template structure
exactly. Delete the template's `>` instruction blocks as you go.

Fill in every section. If a section genuinely does not apply, say so in the file
rather than leaving a placeholder that looks like an oversight.

### 6. Sanity check the output

- Do the dates form a continuous history, and are gaps explainable?
- Does every claim in **Summary framings** have a supporting bullet below it?
- Is every technology in the inventory something they have actually used?
- Are the contact and education blocks in the exact format the template shows?

Report anything that looks thin, and offer to interview further on it.

## Extending an existing master resume

When called to add a single confirmed fact, do not rerun the interview. Append
the bullet to the right role, tell the user where it went, and stop.

## Do not

- Do not write a bullet the user has not confirmed in this conversation.
- Do not carry a claim forward from an old resume just because it is written
  down. Old resumes overstate things. Verify each one.
- Do not invent metrics. A bullet with no number that is true beats a bullet
  with a number that cannot be defended in an interview.
- Do not let the file become a resume. It is a bank, and it is supposed to be
  much too long.
