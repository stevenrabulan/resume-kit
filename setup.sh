#!/usr/bin/env bash
# Preflight for resume-kit.
#
# Checks the things a coding agent cannot reliably check for itself, then hands
# off to the agent for the part that actually needs a conversation.
#
# Usage: ./setup.sh

set -uo pipefail
cd "$(dirname "$0")"

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'
  GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RESET=$'\033[0m'
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; RESET=""
fi

pass() { printf '  %s✓%s %s\n' "$GREEN" "$RESET" "$1"; }
warn() { printf '  %s!%s %s\n' "$YELLOW" "$RESET" "$1"; }
fail() { printf '  %s✗%s %s\n' "$RED" "$RESET" "$1"; FAILED=1; }
FAILED=0

printf '\n%sResume Kit setup%s\n\n' "$BOLD" "$RESET"

# ---------------------------------------------------------------------------
printf '%sChecking your environment%s\n' "$BOLD" "$RESET"

if command -v node >/dev/null 2>&1; then
  pass "node $(node --version)"
else
  fail "node is not installed. Get it from https://nodejs.org"
fi

BROWSER=""
if [ -n "${CHROME_PATH:-}" ] && [ -x "${CHROME_PATH}" ]; then
  BROWSER="$CHROME_PATH"
else
  for candidate in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
    "/usr/bin/google-chrome" \
    "/usr/bin/google-chrome-stable" \
    "/usr/bin/chromium" \
    "/usr/bin/chromium-browser" \
    "/usr/bin/microsoft-edge" \
    "/snap/bin/chromium"; do
    if [ -x "$candidate" ]; then BROWSER="$candidate"; break; fi
  done
fi

if [ -n "$BROWSER" ]; then
  pass "browser found: $(basename "$BROWSER")"
else
  warn "no Chrome-based browser found (needed for PDF output)"
  printf '    %sFix with any one of:%s\n' "$DIM" "$RESET"
  printf '      export CHROME_PATH="/path/to/chrome"\n'
  printf '      npm install puppeteer\n'
  printf '      install Chrome from https://www.google.com/chrome/\n'
fi

# ---------------------------------------------------------------------------
printf '\n%sChecking the workspace%s\n' "$BOLD" "$RESET"

for dir in opportunities resume-archive History; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir" && touch "$dir/.gitkeep"
    pass "created $dir/"
  else
    pass "$dir/ ready"
  fi
done

if [ -f .gitignore ] && grep -q '^/master-resume.md' .gitignore; then
  pass "personal data is gitignored"
else
  fail ".gitignore is missing its personal-data rules. Do not commit until fixed."
fi

if [ -f master-resume.md ]; then
  pass "master-resume.md exists"
  HAS_MASTER=1
else
  warn "master-resume.md does not exist yet (the agent builds this with you)"
  HAS_MASTER=0
fi

# ---------------------------------------------------------------------------
printf '\n%sTesting PDF generation%s\n' "$BOLD" "$RESET"

EXAMPLE="examples/opportunities/Northwind Traders/Alex Doe - Resume - Backend Engineer - Northwind Traders.txt"
if [ ! -f "$EXAMPLE" ]; then
  warn "example resume missing, skipping test"
elif ! command -v node >/dev/null 2>&1; then
  warn "skipped (node is required)"
else
  TMP_PDF="$(mktemp -t resume-kit-check).pdf"
  if node scripts/txt_to_pdf.js "$EXAMPLE" "$TMP_PDF" >/dev/null 2>&1 && [ -s "$TMP_PDF" ]; then
    pass "rendered a test PDF successfully"
  else
    fail "could not render a PDF. Run this to see why:"
    printf '      node scripts/txt_to_pdf.js "%s"\n' "$EXAMPLE"
  fi
  rm -f "$TMP_PDF"
fi

# ---------------------------------------------------------------------------
printf '\n'
if [ "$FAILED" -eq 1 ]; then
  printf '%s%sFix the items marked ✗ above, then run ./setup.sh again.%s\n\n' "$BOLD" "$RED" "$RESET"
  exit 1
fi

printf '%s%sEnvironment is ready.%s\n\n' "$BOLD" "$GREEN" "$RESET"
printf 'The rest of setup is a conversation, because building a good master resume\n'
printf 'means being interviewed about your work.\n\n'
printf '%sNext step:%s open this folder in your coding agent and paste this prompt:\n\n' "$BOLD" "$RESET"

if [ "$HAS_MASTER" -eq 1 ]; then
  printf '  %s"Read AGENTS.md, then help me tailor a resume for a job I am applying to."%s\n\n' "$DIM" "$RESET"
else
  printf '  %s"Read AGENTS.md and skills/setup.md, then walk me through setting this up."%s\n\n' "$DIM" "$RESET"
fi

printf 'Works with Claude Code, Codex, Cursor, or any agent that can read files in\n'
printf 'this directory. Claude Code will also pick up the skills automatically.\n\n'
