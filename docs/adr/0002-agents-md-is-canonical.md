# AGENTS.md is canonical; CLAUDE.md and .claude/skills/ are pointers

The kit has to work in any coding agent, not just Claude Code, so the workflows
live as plain markdown in `skills/` and `AGENTS.md` is the single instruction
file. `CLAUDE.md` is a one-line pointer at it, and each
`.claude/skills/*/SKILL.md` is a stub whose only job is Claude Code's
auto-discovery.

## Consequences

The stubs are supposed to contain no workflow content. Filling them in would
create a second copy of every workflow, and the two would disagree within a
month. If you are tempted to "finish" them, that is this decision working as
intended.

**A stub's `description` is the one exception, and it is not a loophole.**
Claude Code chooses which skill to load from that text alone, so a description
that does not name what the skill routes to means the skill silently fails to
trigger. That is a worse failure than a little repetition, because nothing
surfaces it.

Naming the branches is allowed. Steps, rules, thresholds, and wording an agent
would act on are not. The test: if an agent could follow a line without opening
the file in `skills/`, that line is in the wrong place.
