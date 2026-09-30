#!/usr/bin/env bash
# Black-box tests for scripts/txt_to_pdf.js.
#
# Uses the --html mode, which prints the rendered HTML to stdout and never
# launches a browser. The PDF render itself is covered end to end by the
# "Render the example resume to PDF" step in CI.
#
# Usage: bash scripts/txt_to_pdf.test.sh

set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")" && pwd)/txt_to_pdf.js"

PASS=0
FAIL=0
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# run <file.txt> [args...]: sets OUT and CODE.
run() {
  OUT="$(node "$SCRIPT" "$@" 2>&1)"
  CODE=$?
}

ok() {
  PASS=$((PASS + 1))
  printf 'ok   %s\n' "$1"
}

bad() {
  FAIL=$((FAIL + 1))
  printf 'FAIL %s\n' "$1"
  printf '%s\n' "$OUT" | sed 's/^/     | /'
}

expect_code() {
  local name="$1" want="$2"
  if [ "$CODE" -eq "$want" ]; then ok "$name"; else bad "$name (exit $CODE, want $want)"; fi
}

expect_out() {
  local name="$1" needle="$2"
  if printf '%s' "$OUT" | grep -qF -- "$needle"; then ok "$name"; else bad "$name (missing: $needle)"; fi
}

expect_no_out() {
  local name="$1" needle="$2"
  if printf '%s' "$OUT" | grep -qF -- "$needle"; then bad "$name (unexpected: $needle)"; else ok "$name"; fi
}

# resume <file> <heading style>: writes a fixture resume. The style is either
# "caps" (WORK EXPERIENCE) or "title" (Work Experience).
resume() {
  local file="$1" core work edu
  if [ "$2" = caps ]; then
    core="CORE SKILLS"; work="WORK EXPERIENCE"; edu="EDUCATION"
  else
    core="Core Skills & Achievements"; work="Work Experience"; edu="Education"
  fi
  cat > "$file" <<EOF
Alex Doe
Portland, OR | alex.doe@example.com

Backend engineer who builds high-throughput services.

$core

Event-Driven Architecture: Designed a Kafka event backbone.

$work

Senior Software Engineer | Fabrikam, Portland, OR    03/2021 – Present
Tokenized PII and transaction details to protect customer data at rest
Owned the order pipeline through two re-architectures, cutting p99 latency

$edu

Bachelor of Science, Computer Science | State University, Portland, OR    2016
EOF
}

# --- title-case headings ----------------------------------------------------
f="$WORK/title.txt"
resume "$f" title
run "$f" --html
expect_code "--html exits 0" 0
expect_out "--html prints HTML" "<!doctype html>"
expect_out "title-case heading is a section" "<h2>Work Experience</h2>"
expect_out "title-case heading with & is a section" "<h2>Core Skills &amp; Achievements</h2>"
expect_out "skills section still renders labels" '<span class="skill-label">Event-Driven Architecture:</span>'
expect_no_out "headings are not forced to uppercase" "text-transform: uppercase"

# --- bullets are not promoted to headings -----------------------------------
expect_out "unpunctuated bullet stays a bullet" "<li>Tokenized PII and transaction details to protect customer data at rest</li>"
expect_no_out "unpunctuated bullet is not a heading" "<h2>Tokenized"

# --- ALL CAPS headings still work -------------------------------------------
f="$WORK/caps.txt"
resume "$f" caps
run "$f" --html
expect_out "ALL CAPS heading is a section" "<h2>WORK EXPERIENCE</h2>"
expect_out "bullet under ALL CAPS heading stays a bullet" "<li>Tokenized PII"

# --- page breaks ------------------------------------------------------------
# A job title stays with its first bullet, but the bullet list may split
# across pages. Keeping a whole job on one page pushes long jobs onto page 2.
expect_no_out "a job is not forced onto one page" "break-inside: avoid"
expect_out "a job title is kept with its first bullet" "break-after: avoid"

# --- --html never needs a browser -------------------------------------------
CHROME_PATH=/nonexistent run "$f" --html
expect_code "--html ignores browser resolution" 0

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
