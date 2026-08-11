#!/usr/bin/env bash
# Scan the repo for personal data before publishing a fork.
#
# Usage:
#   bash scripts/check-clean.sh                      # generic detectors only
#   bash scripts/check-clean.sh "Jane Doe" Acme      # plus your own terms
#
# You can also put one term per line in .check-clean-terms (gitignored) instead
# of passing them every time. Good terms: your name, every employer, your
# personal domain, your city, your school.
#
# Exits 0 if clean, 1 if anything was found.

set -uo pipefail
cd "$(dirname "$0")/.."

if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'
  GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RESET=$'\033[0m'
else
  BOLD=""; DIM=""; RED=""; GREEN=""; YELLOW=""; RESET=""
fi

# ---------------------------------------------------------------------------
# what to scan
# ---------------------------------------------------------------------------
# Git-tracked files only when possible: those are what actually get published.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
   [ -n "$(git ls-files 2>/dev/null)" ]; then
  MODE="git-tracked files"
  list_files() { git ls-files; }
else
  MODE="all files (repo has no commits yet)"
  list_files() {
    find . -type f \
      -not -path './.git/*' \
      -not -path './node_modules/*' \
      -not -name '*.pdf' \
      -not -name '.DS_Store' | sed 's|^\./||'
  }
fi

# ---------------------------------------------------------------------------
# allowlist: the fictional example is supposed to be here
# ---------------------------------------------------------------------------
ALLOW='example\.com|example\.org|alexdoe|alex\.doe|\(555\) 010-|555-010-|Northwind|Contoso|Fabrikam|Adventure Works|janedoe|jane\.doe|\(555\) 010-0100'

# ---------------------------------------------------------------------------
# generic detectors
# ---------------------------------------------------------------------------
EMAIL='[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
PHONE='(\+1[ -]?)?(\([0-9]{3}\)|[0-9]{3})[ .-][0-9]{3}[ .-][0-9]{4}'
LINKEDIN='linkedin\.com/in/[A-Za-z0-9_-]+'
STREET='[0-9]{1,6} [A-Z][A-Za-z]+ (Street|St|Avenue|Ave|Road|Rd|Drive|Dr|Lane|Ln|Boulevard|Blvd|Court|Ct|Way)\b'

FOUND=0

report() {
  local label="$1" pattern="$2" fixed="${3:-}"
  local hits
  if [ "$fixed" = "fixed" ]; then
    hits=$(list_files | tr '\n' '\0' | xargs -0 grep -InFH -- "$pattern" 2>/dev/null \
           | grep -Ev "$ALLOW" || true)
  else
    hits=$(list_files | tr '\n' '\0' | xargs -0 grep -InEH -- "$pattern" 2>/dev/null \
           | grep -Ev "$ALLOW" || true)
  fi
  if [ -n "$hits" ]; then
    FOUND=1
    printf '\n%s%s%s\n' "$RED$BOLD" "$label" "$RESET"
    printf '%s\n' "$hits" | sed 's/^/  /'
  fi
}

printf '\n%sScanning %s%s\n' "$BOLD" "$MODE" "$RESET"
printf '%sThe bundled fictional example is allowlisted.%s\n' "$DIM" "$RESET"

report "Email addresses" "$EMAIL"
report "Phone numbers" "$PHONE"
report "LinkedIn profiles" "$LINKEDIN"
report "Street addresses" "$STREET"

# ---------------------------------------------------------------------------
# user-supplied terms
# ---------------------------------------------------------------------------
TERMS=()
[ "$#" -gt 0 ] && TERMS+=("$@")
if [ -f .check-clean-terms ]; then
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    case "$line" in \#*) continue ;; esac
    TERMS+=("$line")
  done < .check-clean-terms
fi

if [ "${#TERMS[@]}" -gt 0 ]; then
  for term in "${TERMS[@]}"; do
    report "Term: \"$term\"" "$term" fixed
  done
else
  printf '\n%sNo custom terms given.%s Pass your name, employers, and personal\n' "$YELLOW" "$RESET"
  printf 'domain as arguments, or list them in .check-clean-terms, for a real check.\n'
fi

# ---------------------------------------------------------------------------
printf '\n'
if [ "$FOUND" -eq 1 ]; then
  printf '%s%sPersonal data found. Review every line above before publishing.%s\n' "$BOLD" "$RED" "$RESET"
  printf '%sA hit in LICENSE is normal if you are the copyright holder.%s\n\n' "$DIM" "$RESET"
  exit 1
fi

printf '%s%sNo personal data detected.%s\n' "$BOLD" "$GREEN" "$RESET"
printf '%sThis is a mechanical check. Still read what you are publishing.%s\n\n' "$DIM" "$RESET"
exit 0
