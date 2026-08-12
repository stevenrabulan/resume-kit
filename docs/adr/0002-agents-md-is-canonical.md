# AGENTS.md is canonical; CLAUDE.md and .claude/skills/ are pointers

The kit has to work in any coding agent, not just Claude Code, so the workflows
live as plain markdown in `skills/` and `AGENTS.md` is the single instruction
file. `CLAUDE.md` is a one-line pointer at it, and each
`.claude/skills/*/SKILL.md` is a five-line stub whose only job is Claude Code's
auto-discovery.

## Consequences

The stubs are supposed to contain no workflow content. Filling them in would
create a second copy of every workflow, and the two would disagree within a
month. If you are tempted to "finish" them, that is this decision working as
intended.
