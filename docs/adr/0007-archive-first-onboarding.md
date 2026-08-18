# Archived resumes are the primary factual source, confirmed per role

Onboarding starts by extracting every role and bullet out of `resume-archive/`
into a Draft Master Resume, and the person confirms it a role at a time. The
interview did not go away, but it is no longer the first thing that happens: it
runs afterward, targeting the gaps extraction left behind, and it remains the
whole path for someone with no old resumes.

The original design interviewed from scratch and treated Archived Resumes as
reference for phrasing only, never for facts. That produced better material and
cost 30 to 60 minutes before the person saw anything at all, which is a long
time to trust a tool you cloned five minutes ago. Most people arrive with three
to ten old resumes that already contain their entire work history. Retyping it
through an interview is a tax on the people best equipped to use this kit.

## Consequences

**The guardrail changed shape, deliberately.** `AGENTS.md` says to ask "Is it
accurate to say [exact proposed wording]?" and never to treat silence as
approval. Asking that per bullet across a decade of roles is a few hundred
questions, and the honest prediction is that people abandon it halfway and end
up with a worse master resume than if they had been asked nothing. So the
Confirmation Pass asks per role, and a bare "looks good" accepts that role's
block.

What keeps this safe is that the default is not blind. Any bullet carrying an
unverifiable metric or a strong ownership verb is named individually inside the
role's block and needs an explicit yes, so the person is looking straight at the
risky claims when they accept. The guardrail's letter is relaxed; its purpose,
that nobody ships a claim they cannot defend in an interview, is not.

If you are about to "restore" per-bullet confirmation because it contradicts
`AGENTS.md`, this is the decision that removed it.

**Extracted bullets get rewritten, inside a fixed boundary.** Extraction does not
transcribe; it proposes an improved wording for each bullet. The line it may not
cross is that wording improves freely while the strength of the claim never
moves: not the ownership verb, not the numbers, not the technologies, not the
attribution to a team, not the hedges.

The enumerated list of what may and may not change lives in
`skills/master-resume-builder.md` §2, which is where an agent is standing when it
needs it. It is deliberately not repeated here.

A bullet with no stated outcome is not given one. It is tagged and handed to the
gap-fill interview, which turns the weakest bullets into questions rather than
into fiction.

**A Draft Master Resume is not a Master Resume.** Nothing downstream may select
from it. The distinction is in `CONTEXT.md` because it is the difference between
"a machine read this off my old PDF" and "I said this is true".

## Considered options

**Keeping the interview first, with archives as phrasing reference only.** The
status quo, and it produces the best raw material. Rejected on adoption: the
kit's value is invisible until the master resume exists, and an hour of
questions before any output is where people quit.

**A two-tier master resume, with an unverified section that tailored resumes may
not select from.** Rejected because it creates a second source of truth, which
this repo has exactly one of on purpose. The first time someone's best bullet
sits unpromoted in the unverified tier and silently misses an application, they
stop trusting the output.
