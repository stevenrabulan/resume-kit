#!/usr/bin/env bash
# Black-box tests for scripts/check-clean.sh.
#
# Each test builds a throwaway git repo, copies the script in, and asserts only
# exit codes and printed output.
#
# Usage: bash scripts/check-clean.test.sh

set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")" && pwd)/check-clean.sh"
export NO_COLOR=1
TERM_="ZebraCorp"

PASS=0
FAIL=0
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# make_repo <name>: fresh repo with the script, a .gitignore, and one commit.
make_repo() {
  local dir="$WORK/$1"
  mkdir -p "$dir/scripts"
  cp "$SCRIPT" "$dir/scripts/check-clean.sh"
  (
    cd "$dir"
    git init -q
    git config user.email "test@example.com"
    git config user.name "Test"
    printf 'ignored/\n.check-clean-terms\n' > .gitignore
    printf 'nothing personal here\n' > readme.txt
    git add -A
    git commit -q -m init
  )
  echo "$dir"
}

# run <dir> [args...]: sets OUT and CODE.
run() {
  local dir="$1"; shift
  OUT="$(cd "$dir" && bash scripts/check-clean.sh "$@" 2>&1)"
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

# --- clean tree -------------------------------------------------------------
d=$(make_repo clean)
run "$d" "$TERM_"
expect_code "clean tree passes" 0

# --- tracked file -----------------------------------------------------------
d=$(make_repo tracked)
printf 'I worked at %s\n' "$TERM_" > "$d/tracked.txt"
(cd "$d" && git add tracked.txt && git commit -q -m add)
run "$d" "$TERM_"
expect_code "term in tracked file fails" 1

# --- untracked, not ignored -------------------------------------------------
d=$(make_repo untracked)
printf 'I worked at %s\n' "$TERM_" > "$d/untracked.txt"
run "$d" "$TERM_"
expect_code "term in untracked file fails" 1
expect_out "untracked hit names the file" "untracked.txt"

# --- ignored: warn only -----------------------------------------------------
d=$(make_repo ignored)
mkdir -p "$d/ignored/deep"
for i in 1 2 3; do
  printf '%s line one\n%s line two\n' "$TERM_" "$TERM_" > "$d/ignored/deep/f$i.txt"
done
run "$d" "$TERM_"
expect_code "term in ignored file only warns" 0
expect_out "ignored hit is summarised" "ignored/"
expect_out "ignored summary shows counts" "6 hits in 3 files"
expect_no_out "ignored summary omits matching lines" "line one"

d=$(make_repo ignored-generic)
mkdir -p "$d/ignored"
# Built at runtime so this file itself stays clean under check-clean.sh.
printf 'reach me at %s@%s\n' someone private-host.net > "$d/ignored/contact.txt"
run "$d"  --allow-no-terms
expect_code "generic detector in ignored file only warns" 0
expect_out "generic ignored hit is warned" "ignored/"

# --- no terms ---------------------------------------------------------------
d=$(make_repo no-terms)
run "$d"
expect_code "no terms fails" 1
expect_out "no terms says why" "No search terms"

run "$d" --allow-no-terms
expect_code "--allow-no-terms passes on a clean tree" 0
expect_out "--allow-no-terms is loud" "--allow-no-terms"

# --- terms file does not match itself ---------------------------------------
d=$(make_repo terms-file-ignored)
printf '%s\n' "$TERM_" > "$d/.check-clean-terms"
run "$d"
expect_code "terms file (ignored) does not match itself" 0
expect_no_out "terms file (ignored) is not reported" ".check-clean-terms"

d=$(make_repo terms-file-untracked)
printf 'ignored/\n' > "$d/.gitignore"
(cd "$d" && git add .gitignore && git commit -q -m gi)
printf '%s\n' "$TERM_" > "$d/.check-clean-terms"
run "$d"
expect_code "terms file (untracked) does not match itself" 0

# --- binary files -----------------------------------------------------------
d=$(make_repo binary)
run "$d" "$TERM_"
expect_out "states .docx and .pdf are not scanned" ".docx"
expect_out "states .pdf is not scanned" ".pdf"

# --- repo with no commits ---------------------------------------------------
d="$WORK/no-commits"
mkdir -p "$d/scripts"
cp "$SCRIPT" "$d/scripts/check-clean.sh"
(cd "$d" && git init -q)
printf 'I worked at %s\n' "$TERM_" > "$d/notes.txt"
run "$d" "$TERM_"
expect_code "no-commits fallback fails on a hit" 1

printf '\n%s passed, %s failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
