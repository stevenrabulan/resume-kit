# User data is gitignored by default

Everything personal is ignored out of the box, so someone who forks this and
never thinks about git cannot publish their own resume and recruiter
correspondence. Tracking your own data requires deliberately editing
`.gitignore`.

## Considered options

Committing user data by default with a warning in the README. Rejected: defaults
decide outcomes, and this particular failure is irreversible once pushed.
