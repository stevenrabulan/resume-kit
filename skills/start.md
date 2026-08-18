# Start

The entry point to this kit. A home menu that reports where the user stands and
routes them to the right workflow.

Use this when the user has just cloned the repo, runs `bash scripts/setup.sh`,
says "start", "set this up", or "what can this do", or when any other skill
finds that `master-resume.md` is missing.

## 1. Read the state

Three lookups, before you say anything:

```
ls master-resume.md 2>/dev/null
ls resume-archive/
cat History/archive-ingested.md 2>/dev/null
```

`History/archive-ingested.md` is the ledger of Archived Resumes already folded
into the Master Resume. Files in `resume-archive/` that are absent from it are
new material.

This reading is a snapshot, and it goes stale the moment the user acts on it.
Every later step that depends on what is in `resume-archive/` scans it again.

When `master-resume.md` is missing, run the preflight before the menu:

```
bash scripts/setup.sh --agent
```

It checks Node, finds a browser, creates the working directories, and renders a
test PDF. `--agent` suppresses the closing instructions meant for a human at a
terminal. If it exits nonzero, fix what it reports before continuing: every
document this repo produces goes through that renderer.

For a returning user, skip the preflight. Run it if a PDF render fails later,
because that is what diagnoses the failure.

## 2. Show the menu

Report the state in one line, then offer the options that the state allows.

**With no `master-resume.md`:**

> You have no master resume yet, and 4 files in `resume-archive/`. That is the
> place to start.
>
> 1. **Build my master resume** (recommended)
> 2. Generate a tailored resume — needs a master resume first
> 3. Generate a cover letter — needs a master resume first

**With a `master-resume.md`:**

> Your master resume covers 5 roles, last updated 12 March. 3 new files in
> `resume-archive/` have not been folded in yet.
>
> 1. Update my master resume — 3 new files waiting
> 2. **Generate a tailored resume** for a job posting
> 3. **Generate a cover letter** for a job you have a resume for

Bold the option the state points at. Show options 2 and 3 either way, marked as
blocked, so the user learns what this kit does on their first visit.

## 3. Route

| They pick | Do this |
| --- | --- |
| 1 | Branch on the state — see [Where option 1 goes](#where-option-1-goes) |
| 2 | `skills/resume-builder.md` |
| 3 | `skills/cover-letter-builder.md` |

## Where option 1 goes

Option 1 means three different things. Use the ledger diff from step 1 to tell
them apart, and check it before you route.

**No `master-resume.md`** — the gathering menu below, then
`skills/master-resume-builder.md` for a full build.

**`master-resume.md` exists, and `resume-archive/` holds files the ledger does
not list** — skip the gathering menu. Go to `skills/master-resume-builder.md`,
"Extending an existing Master Resume", scoped to those new files.

**`master-resume.md` exists and the ledger already covers every file in
`resume-archive/`** — there is nothing to extract. Do not run the builder
unscoped: those files have been through a Confirmation Pass already, and putting
them through a second one asks the user to re-confirm work they have already
done. Say where things stand and stop:

> Your master resume is already up to date with everything in `resume-archive/`
> (5 files, all folded in). There is nothing new for me to pull from.
>
> Two ways to add to it: drop more of your old resumes into `resume-archive/` and
> pick this option again, or tell me what you want to add and I will interview you
> for it.

If they want the interview, use `skills/master-resume-builder.md` step 5, scoped
to what they name rather than every role.

## The gathering menu

Only for option 1, and only when `master-resume.md` is missing. The other two
branches are above.

Ask where their career history lives:

> Your master resume gets built from resumes you have already written. Where are
> they?
>
> 1. **They are in `resume-archive/` already** — build from them now
> 2. **They are in Google Docs** — help me get them out
> 3. **I do not have any** — interview me instead

**Option 1.** Scan `resume-archive/` again, right now, before you say anything
else. The user has almost certainly copied files in since you read it in step 1,
and that is exactly what they are telling you. Then follow
`skills/master-resume-builder.md`, which reports the counts.

When the fresh scan finds nothing, say what you looked at and give them
something to check, rather than asking again in the same words:

> `resume-archive/` still looks empty to me. I am looking at
> `<absolute path>/resume-archive/`. Two things that usually explain it: the
> files are still in Downloads, or there is a second copy of this repo and they
> went into the other one. Tell me where they are and I will move them.

**Option 2.** Follow `skills/google-docs-export.md`, then return here and offer
option 1.

**Option 3.** Follow `skills/master-resume-builder.md`, which handles the
interview path.

Whichever they pick, tell them once: **`resume-archive/` is gitignored, so
nothing they put there can be published.** People hesitate to drop a resume with
their phone number in it into a git repo, and they are right to check.

## Closing out

After any workflow finishes, return the user to the menu with the state
refreshed. The first time they land back here with a master resume in hand, say
what changed: how many roles and bullets it holds, and that every tailored
document from now on selects from it.
