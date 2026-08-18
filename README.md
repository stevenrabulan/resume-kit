# Resume Kit

Build your master resume once. Generate a tailored resume and cover letter for
every job you apply to, in about two minutes each.

This is a workspace for you and a coding agent, not an app. It works with Claude
Code, Codex, Cursor, or anything else that can read files in a directory.

---

## How it works

You do the hard part once. Drop your old resumes into `resume-archive/`. The
agent reads all of them, shows you what it found one job at a time so you can
correct it, then asks you about your career to fill in what those resumes left
out. What comes out is **`master-resume.md`**, a deliberately over-long bank of
every truthful thing you have done. It is not a resume. Nobody ever sees it.

No old resumes? The agent builds it by asking you from scratch. That takes longer
and works just as well.

After that, each application is a selection problem rather than a writing
problem. You paste a job posting; the agent picks the bullets that match, mirrors
the posting's own language where it is honest to do so, and generates an
ATS-safe PDF.

The rule that makes it work: **nothing appears in a tailored document that is not
in your master resume or that you have not just confirmed.** The agent selects,
it does not invent.

## Getting started

**1. Clone it.**

Click **Use this template** at the top of the repo to get your own copy, then:

```bash
git clone https://github.com/stevenrabulan/resume-kit.git
cd resume-kit
```

**2. Copy your old resumes into `resume-archive/`.**

Any format: PDF, Word, plain text, Markdown. More is better, including the ones
you think are out of date. That folder is gitignored, so nothing you put there
can be published.

Skip this step if you have none, or if yours live in Google Docs. The agent
handles both.

**3. Open the folder in your coding agent and start.**

**Claude Code:** type `/start`.

**Codex, Cursor, or anything else:** there is no slash command, so say it in
words. Paste this:

```
Read AGENTS.md and skills/start.md, then start.
```

Codex picks up `AGENTS.md` on its own, so "start" alone often works. The paste
above is the version that works everywhere, including agents that need to be
pointed at the file. Either way you land in the same place, because the slash
command is a stub that just reads `skills/start.md`. Nothing in this kit is
Claude-specific.

Either way you get the same home menu, and everything runs from there:

1. Build or update your master resume
2. Generate a tailored resume for a job posting
3. Generate a cover letter

It checks your toolchain and runs `scripts/setup.sh` when it needs to, so there
is nothing to run by hand. Budget 30 to 60 minutes the first time through option
1. It is the whole ballgame, and every application afterward takes about two
minutes.

**Requirements:** Node.js, and Chrome or any Chromium-based browser. No npm
install, no API keys, no accounts.

## Applying to a job

Pick option 2 from `/start`, or just paste a job posting into your agent and ask
for a resume. Either way it will:

1. Save the posting to `opportunities/[Company]/`
2. Ask you about anything the posting wants that your master resume does not
   cover, and record whatever you confirm
3. Select and reorder your bullets to match
4. Write the resume as a `.txt`, then generate the PDF from it
5. Show you the result and ask whether any claim needs softening

Ask for a cover letter afterward and it will use the posting and the resume you
just made.

## Why plain text

The `.txt` file is the source of truth; the PDF is derived from it by
`scripts/txt_to_pdf.js`. That means:

- **Diffable.** You can see exactly what changed between two applications.
- **ATS-safe by construction.** Single column, real selectable text, standard
  fonts, no tables or images. Nothing an applicant tracking system can choke on.
- **Reproducible.** Same input, same PDF, every time.

Never copy-paste the text into a word processor to make the PDF. That is what
breaks the formatting.

## Your data stays yours

Everything personal is gitignored out of the box: your master resume, every
company folder, your old resumes, your application history. Clone this, use it
for a year, and you still cannot accidentally push your phone number to GitHub.

If you want to track your own data in a private fork, edit the `.gitignore`.
That is a deliberate choice you have to make, which is the point.

Before publishing any fork, run:

```bash
bash scripts/check-clean.sh
```

It scans the tree for names, emails, phone numbers, and addresses, and exits
nonzero if it finds any.

## What's in here

```
AGENTS.md                 instructions your agent reads (CLAUDE.md points here)
master-resume.md          your source of truth (the agent builds this with you)
skills/                   the workflows, as plain markdown
templates/                the master resume template
scripts/setup.sh          environment preflight
scripts/txt_to_pdf.js     .txt -> ATS-safe PDF, no dependencies
scripts/check-clean.sh    personal data scanner
examples/                 a complete worked example, fictional
opportunities/            one folder per company you apply to
resume-archive/           drop your old resumes here
History/                  a log of what was created and why
```

Have a look at `examples/` before you start. It shows a finished master resume,
a job posting, and the tailored resume and PDF that came out of them.

## Troubleshooting

**"Could not find a Chrome-based browser"** — set `CHROME_PATH` to your browser
binary, or run `npm install puppeteer` and try again. The error message lists
both.

**The PDF looks wrong** — the generator parses the `.txt` literally. Check that
line 1 is your name, line 2 is your contact line, section headings are ALL CAPS,
job headers contain a `|` with two or more spaces before the date, and no bullet
line starts with `-` or `•`. The rules are in `skills/resume-builder.md`.

**The agent is inventing things** — point it back at `AGENTS.md`. If a claim is
not in your master resume, it should be asking you, not writing it.

## Contributing

Bug reports are welcome, especially from platforms this has not been tested on.
See `CONTRIBUTING.md`, and read `docs/adr/` before proposing a change: several
things that look like oversights are deliberate.

## License

MIT. Use it, fork it, take the prompts and put them somewhere else. That is what
it is for.
