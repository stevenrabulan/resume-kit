# Resume Builder

Produce a tailored resume for a specific job posting, as a plain `.txt` file plus
an ATS-safe `.pdf`.

Use this when the user shares a job posting, asks for a resume for a company, or
says they are applying somewhere.

## Prerequisite

`master-resume.md` must exist. If it does not, stop and follow
`skills/master-resume-builder.md` first. A Tailored Resume is built from
confirmed facts, so it selects from the Master Resume alone. An Archived Resume
in `resume-archive/` holds candidate claims that have not been through a
Confirmation Pass, which is what building the Master Resume is for.

## Workflow

### 1. Get the job description

Ask the user to paste the job description text. This is the primary path and it
always works.

If the user gives you a URL instead: most applicant tracking systems (Greenhouse,
Lever, Ashby, Workable) block automated fetching, so a plain HTTP fetch usually
returns nothing useful. If you have a browser automation tool available, use it.
Otherwise ask them to paste the text. Do not spend more than one attempt on
fetching before asking.

### 2. Save it

Create `opportunities/[Company]/` and save the posting as:

```
opportunities/[Company]/Job Description - [Job Title] - [Company].txt
```

The first line of that file must be the URL of the original posting, followed by
the full text. Postings get taken down; this is often the only copy.

Do this before writing anything else.

### 3. Read the posting properly

Extract and hold onto:

- **Required skills and tools**, in the posting's exact spelling and casing
- **The responsibilities**, especially the first two or three listed
- **The hardest-to-fill requirement** — the one thing that most applicants will
  not have
- **Seniority and scope language** — "own", "lead", "partner with", "mentor"

### 4. Check for gaps, and ask

Compare the posting's requirements against `master-resume.md`. Where the posting
asks for something important that the master resume does not cover, ask the user
directly whether they have that experience.

Ask before drafting, not after. Anything they confirm gets appended to
`master-resume.md` (see `skills/master-resume-builder.md`, "Extending") so it is
never lost again.

### 5. Select and order

Pull the bullets from `master-resume.md` that match the posting. Drop the rest.

- Lead each role with its most relevant bullet, not its chronologically first.
- Cut roles that add nothing. A 12-year-old job unrelated to the posting is
  taking space from something better.
- Aim for one page for under ten years of experience, two pages above that.

### 6. Mirror the posting's language

Recruiters and ATS keyword matching both key off the posting's literal wording.
Where a phrase from the posting truthfully describes the user's experience, use
that phrase word for word.

- Match their spelling exactly: write "A/B testing" if they do, not "split
  testing"; "TypeScript", not "TS".
- Prefer their term over a synonym already in the master resume, when both are
  accurate.
- Only mirror a phrase when it is true. The accuracy guardrails in `AGENTS.md`
  always win over keyword matching.
- Do not keyword-stuff. Weave phrases into real accomplishment lines. Never bolt
  on a phrase with nothing behind it.

### 7. Write the `.txt`

Save to:

```
opportunities/[Company]/[Name] - Resume - [Job Title] - [Company].txt
```

Use this exact layout. `scripts/txt_to_pdf.js` parses it literally, so the
formatting rules are not cosmetic:

```
Full Name
City, ST | (555) 010-0100 | email@example.com | linkedin.com/in/handle | site.com

Summary paragraph, two to four sentences, tailored to this posting.

CORE SKILLS

Skill Label: Description text on one line.
Skill Label: Description text on one line.

WORK EXPERIENCE

JOB TITLE | Company, City, ST (Remote)    MM/YYYY – MM/YYYY
Accomplishment line with no bullet character
Accomplishment line with no bullet character

EDUCATION

Bachelor of Science, Field | University, City, ST    2015
```

Rules the parser depends on:

- Line 1 is the name. Line 2 is the pipe-separated contact line.
- Section headings are ALL CAPS and contain no `|`.
- Job header lines contain a `|` and separate the date with **two or more
  spaces**.
- Accomplishment lines have **no** leading `-`, `*`, or `•`.
- Skill lines are `Label: text`.

### 8. Generate the PDF

```
node scripts/txt_to_pdf.js "opportunities/[Company]/[the .txt file]"
```

This writes the `.pdf` next to the `.txt`. Never copy-paste the text into a word
processor to make the PDF; that breaks the formatting and often the ATS parsing
too. The `.txt` is the source of truth and the PDF is derived from it.

If the script reports it cannot find a browser, its error message lists the
fixes. Relay them.

### 9. Verify with the user

Show the resume. Ask directly whether any claim needs softening. Do not treat
silence as approval on anything you inferred rather than were told.

### 10. Log it

Append to `History/log.md`:

- Date, company, job title, file path
- What the posting emphasized
- Which bullets were selected and why
- Any gap questions asked and what was learned
- Any claim that was softened for accuracy

Add a row to `History/index.md`: date (`YYYY-MM-DD`), path relative to the repo
root, company, job title.

## Do not

- Do not state anything not present in `master-resume.md` or confirmed by the
  user in this conversation.
- Do not upgrade verbs to fit the posting. "Contributed to" does not become
  "led"; "used" does not become "architected".
- Do not claim direct experience where the user has adjacent experience. Say
  what is true and let it be judged.
- Do not reuse a previous tailored resume as the source for a new one. Errors
  compound. Always go back to `master-resume.md`.
