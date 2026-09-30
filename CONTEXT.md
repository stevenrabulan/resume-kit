# Resume Kit

A workspace where a person and a coding agent build one exhaustive record of a
career, then produce job-specific application documents by selecting from it.

## Language

The _Avoid_ lists bind the documents an agent reads and follows: `AGENTS.md`,
everything in `skills/`, and the `.claude/` stubs. Inside those, use the term.

Two deliberate exemptions. `README.md` is read by someone who cloned this five
minutes ago, to whom "Archived Resume" is jargon and "old resumes" is simply what
they are; it stays in plain English. So does anything an agent says out loud to
the user, including the quoted example blocks in `skills/`. This glossary exists
to stop two documents meaning different things by the same word, not to push
vocabulary onto the person using the kit.

**Master Resume**:
The single exhaustive record of every truthful claim about a person's career.
Deliberately far too long to send anyone.
_Avoid_: bullet bank, resume bank, source resume, profile

**Draft Master Resume**:
A Master Resume assembled from Archived Resumes but not yet put to the person.
Every claim in it is unconfirmed. No Tailored Resume may select from it.
_Avoid_: draft, extracted resume, provisional resume

**Tailored Resume**:
An application document for one Opportunity, produced by selecting from the
Master Resume. Never a source for another Tailored Resume.
_Avoid_: generated resume, output resume, final resume

**Archived Resume**:
A resume the person wrote before adopting this kit. The primary source material
for a Draft Master Resume. A claim in one is a candidate, never a fact, until it
survives a Confirmation Pass.
_Avoid_: old resume, historical resume, previous resume

**Confirmation Pass**:
The step where a person is shown what was extracted from their Archived Resumes,
one role at a time, and accepts, edits, or drops each claim. What turns a Draft
Master Resume into the Master Resume.
_Avoid_: review, approval, verification step

**Posting**:
The full text of one advertised job at one company.
_Avoid_: JD, job description, job ad, listing, req

**Opportunity**:
One role at one company that the person is applying to. Holds the Posting and
every document produced for it.
_Avoid_: application, company folder, lead, prospect

**Bullet**:
One accomplishment statement: what a person did, how, and what changed as a
result. Lives in the Master Resume and is selected into Tailored Resumes.
_Avoid_: achievement, line item, highlight

**Skill**:
A workflow document that an agent reads and follows. Always the agent-facing
meaning in this repo.
_Avoid_: using "skill" for a line in a resume's Core Skills section — call that a
Competency

**Competency**:
A capability claim in a resume's Core Skills section, written as `Label: text`.
Distinct from a Skill, which is an agent workflow.
_Avoid_: skill, strength, proficiency

**Guardrail**:
One of the accuracy rules in `AGENTS.md` that constrains what an agent may claim
on a person's behalf. Outranks keyword matching and outranks making an
application look stronger.
_Avoid_: rule, constraint, policy
