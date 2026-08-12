# Built as a fresh repo, not a scrubbed copy

This kit was extracted from a private job-search repo that carried personal data
in nearly every one of its 185 files. We started a new repo and hand-ported six
files rather than deleting content and rewriting git history, because subtractive
scrubbing fails open: anything missed still ships.

The first commit here is genuinely the first commit. There is no inherited
history to audit, and no chance of personal data surviving in a dangling object.
