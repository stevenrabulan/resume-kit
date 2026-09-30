# Cover Letter Builder

Write a tailored cover letter for a specific job posting, as a plain `.txt` file.

Use this when the user asks for a cover letter, says "write a letter for this
role", or wants to round out an application that already has a resume.

## Prerequisites

Both must already exist in the company folder:

1. `opportunities/[Company]/Job Description - [Job Title] - [Company].txt`
2. The tailored resume `.txt` for this role

If the resume does not exist, follow `skills/resume-builder.md` first. The cover
letter's job is to add what the resume cannot, which means you have to know what
the resume already says.

## What a cover letter is for

It provides the narrative and the "why" that bullet points cannot carry. It is
not a prose restatement of the resume. If an achievement appears in the resume,
the letter either tells the story behind it or leaves it alone.

Assume it gets 30 to 45 seconds of attention.

## Choosing the shape

There is no fixed template per job family. Read the posting and decide which of
these it rewards, then build the "Why You" paragraph accordingly:

- **Outcome-led** — the posting talks about metrics, growth, revenue, or user
  behavior. Tell one story: the problem, the hypothesis, what the user did, and
  what measurably changed.
- **Craft-led** — the posting talks about systems, scale, quality, or specific
  technologies. Give two or three proof points: what they built, in what, at
  what scope, and what it enabled.
- **Mission-led** — the posting leads with who it serves and why the work
  matters, more than with requirements. Connect the user's genuine interest to
  the specific problem the company works on, and back it with one concrete thing
  they have done in that space.

Most postings are a blend. Pick the dominant one and let it drive the middle
paragraph. If you are unsure, ask the user which angle they want to lead with.

## Structure

Four paragraphs, in this order.

**The Hook (1-2 sentences).** Name the exact role in the first sentence, then
state why this specific background fits this specific job. The opening sentence
decides whether the rest gets read. Lead with a concrete fact or a real claim.

Avoid: "I'm excited to apply", "I'm drawn to this role", "I believe I would be a
great fit."

**Why You (one paragraph, 4-6 sentences).** Built per the shape you chose above.
Address the posting's hardest-to-fill requirement if the user can honestly speak
to it. Keep each proof point to one or two sentences.

**Why Them (2-4 sentences).** Must contain at least one detail that could only
apply to this company: a specific product, a recent launch, a market position, a
stated problem. This is what separates a real letter from a template. If you do
not have such a detail and cannot find one in the posting, ask the user rather
than writing something generic.

**Close (1-2 sentences).** Forward-looking and brief. Suggest a conversation
about something specific.

## Writing principles

- **Cut hard.** Two to four paragraphs, none longer than six sentences.
- **Split long sentences.** If a sentence has more than two commas, or uses a
  dash to bolt on an extra clause, make it two sentences.
- **No corporate filler.** Not "leverage synergies", not "I humbly submit".
- **Stay honest about scale.** If the target company operates at far greater
  scale than the user has worked at, frame the experience as transferable rather
  than equivalent. "I've built systems that did X" is honest. "I've already
  solved exactly this" usually is not, and reads badly.
- **Let some personality through.** Enthusiasm for the actual problem space is
  the most credible thing in the letter.

## Before you finalize

If a detail you do not have would make the letter stronger, such as a personal
connection to the company or a product the user actually uses, ask for it before
finalizing. Otherwise present the draft as it is.

## Output format

Save to:

```
opportunities/[Company]/[Name] - Cover Letter - [Job Title] - [Company].txt
```

Plain text, no bold, italics, or special characters:

```
Full Name
City, ST
(555) 010-0100
email@example.com

[Company Name] Hiring Team

Dear Hiring Team,

[Hook paragraph]

[Why You paragraph]

[Why Them paragraph]

[Close paragraph]

Best regards,
Full Name
```

Contact details go on separate lines here, not pipe-separated as in the resume.
Use "Dear Hiring Team," unless the posting names a specific person.

## Log it

Append to `History/log.md`: date, company, role, file path, which shape you chose
and why, what the "Why Them" hooked onto, and any claim that was softened.

Add a row to `History/index.md` marking this as a cover letter.

## Do not

- Do not state anything not present in `master-resume.md` or the tailored resume,
  or confirmed by the user in this conversation.
- Do not restate resume bullets in sentence form.
- Do not write a "Why Them" that would be true of any company in the industry.
- Do not upgrade verbs. The accuracy guardrails in `AGENTS.md` apply here exactly
  as they do to resumes.
