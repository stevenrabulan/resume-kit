# Setup

First-run onboarding. Gets a new user from a fresh clone to a working master
resume, then points them at the day-to-day workflows.

Use this when the user has just cloned the repo, runs `./setup.sh`, says
"set this up", or when any other skill discovers that `master-resume.md` is
missing.

## Before you start

Read `AGENTS.md` if you have not already. It describes the repo layout and the
rules that apply to every document produced here.

## Steps

### 1. Check what already exists

```
ls master-resume.md 2>/dev/null
ls resume-archive/
```

- If `master-resume.md` exists and has real content, setup is already done.
  Skip to step 5 and just orient the user.
- If it is missing, continue.

### 2. Confirm the environment

`setup.sh` normally handles this, but verify it if the user came straight to
you:

- `node --version` succeeds (any recent version is fine)
- A Chrome-based browser is installed, or `CHROME_PATH` is set

Test both at once by rendering the bundled example:

```
node scripts/txt_to_pdf.js "examples/opportunities/Northwind Traders/Alex Doe - Resume - Backend Engineer - Northwind Traders.txt" /tmp/resume-kit-check.pdf
```

If that prints `PDF written to ...`, the toolchain works. If it fails, the error
message names the fix. Do not move on until this passes: every resume this repo
produces goes through that script.

### 3. Gather source material

Ask the user to drop anything they have into `resume-archive/`:

- Old resumes, in any format (`.pdf`, `.docx`, `.txt`, `.md`)
- LinkedIn profile export or a copy-paste of their profile
- Performance reviews, brag documents, project write-ups

Tell them explicitly: **that folder is gitignored, nothing in it gets published.**

If they have nothing, that is fine. Say so and continue. The master resume
interview works from scratch; it just takes longer.

### 4. Build the master resume

Hand off to `skills/master-resume-builder.md` and follow it. This is the bulk of
setup and the part that determines the quality of everything afterward. Do not
shortcut it.

### 5. Orient the user

Once `master-resume.md` exists, tell them what they can now do, in this shape:

- **Apply to a job:** paste the job description (or its text) and ask for a
  tailored resume. Follow `skills/resume-builder.md`.
- **Add a cover letter:** ask for one after the resume exists. Follow
  `skills/cover-letter-builder.md`.
- **Keep the master resume current:** every time they confirm a new fact about
  their experience, it gets written back to `master-resume.md`.

Mention that their data stays local by default, and that
`bash scripts/check-clean.sh` exists if they ever plan to publish a fork.

## Do not

- Do not fill in `master-resume.md` with plausible-sounding content the user has
  not confirmed. An invented master resume poisons every document downstream.
- Do not skip the PDF check in step 2 because it seems like a formality. It is
  the single most common thing to be broken on a new machine.
