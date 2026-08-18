# Draft: usage telemetry and contact follow-up

**Status: tabled 2026-08-17.** Designed far enough to be resumable, deliberately
not built. Nothing in this document is implemented, and no ADR has been written
for it. If you pick this up, read the constraints section before the design.

## What it was for

Two goals, from the repo's author:

1. Understand how people use the kit, to improve it.
2. Follow up with a person who generated at least one resume PDF and then went
   quiet for two months, to ask whether the tool helped them land a job.

Goal 2 is the one that shapes everything. It is a per-person query over time, so
it cannot run on unlinkable data.

## Settled

**Contact details are joined to usage events, under one pseudonymous install
ID.** Events are keyed by a random install ID; the email and phone the user
consents to share are held as a contact record against that same ID. The word
"anonymous" must not appear in the consent copy, because the data is
pseudonymous at best and identified in practice.

Considered and rejected: two separate stores with no join path. It is the
privacy-preserving option and it makes goal 2 impossible, which is why it lost.

## Open

Each of these was asked and not answered. They are listed in the order they
block each other.

1. **Transport.** Local-only logging cannot work: a dormant user is by
   definition not running the tool, so nothing they hold locally ever reaches
   the author. Events have to leave the machine. The candidate shape is an
   append-only local queue plus a best-effort POST that flushes unsent events on
   the next run, so a failed call delays an event rather than losing it.
2. **Deletion path.** Recommended: a `PRIVACY.md` stating exactly what is
   collected, a human deletion address, and a local action that stops future
   sends and wipes the queue. A public deletion endpoint keyed on an install ID
   read off disk is trivially abusable and was not recommended at low volume.
3. **Consent copy.** The three-question script drafted by the author contains a
   trap: question 1 asks about usage data while it still reads as anonymous, and
   question 2 asks about email follow-up. A person can answer yes twice and
   never be told the two are joined into an identified behavioral profile. The
   join has to be disclosed in question 2, in roughly this shape:

   > The tool will use [email] as your email on the master resume. May I follow
   > up there to see if this helped you land a job? If yes, I'll link your email
   > to the usage data above so I know when to check in, and you can tell me to
   > delete both at any time.

4. **What the dormancy clock keys on.** Recommended: the tailored-document
   event, regardless of whether the PDF rendered, with a separate `pdf_ok`
   boolean on the payload. Keying on PDF success instead means a user with a
   broken toolchain reads as dormant and receives a "did you get the job?" text
   when the correct message is "your PDF generation is broken, here is the fix."
5. **Sequencing.** The consent script references "[extracted email address]",
   which does not exist until the archive has been parsed. The opt-in therefore
   cannot be the first thing an onboarding skill asks.

## Constraints anyone resuming this must reconcile

These are not objections to the feature. They are existing commitments that the
feature contradicts, and each one needs an explicit decision rather than a quiet
override.

- **`ADR 0003` (user data gitignored by default)** exists because "defaults
  decide outcomes, and this particular failure is irreversible once pushed."
  Shipping a phone number to a remote endpoint is the same irreversible
  disclosure through a different exit.
- **`README.md` promises**: "Clone this, use it for a year, and you still cannot
  accidentally push your phone number to GitHub." A telemetry beacon does not
  break that sentence literally, and it does break the expectation the sentence
  sets. The README copy needs revisiting alongside the feature.
- **`scripts/check-clean.sh`** exists to catch personal data leaving the repo.
  A feature whose job is to send personal data out of the repo should be
  reviewed against what that script is for.
- **There is no runtime here.** No server, no daemon, no install step. The only
  thing that can call an endpoint is the user's own agent under the user's own
  tool permissions. Events will be skipped in permission-restricted agents,
  retried inconsistently, and dropped on failure unless queued. Any metric
  derived from this is a lower bound of unknown depth.
- **SMS consent in the US is TCPA territory.** Consent captured by an AI agent
  in a terminal and stored in a text file is not the written consent record you
  would want if it were ever challenged. Get an opinion on the phone question
  specifically before shipping it. The email question is materially lower risk.

## Terms that would need to enter `CONTEXT.md`

Not added yet, because the model is not settled: **Install ID**, **Usage
Event**, **Contact Record**.
