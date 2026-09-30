#!/usr/bin/env bash
# Scan the repo for personal data before publishing a fork.
#
# Usage:
#   bash scripts/check-clean.sh "Jane Doe" Acme      # generic detectors + your terms
#   bash scripts/check-clean.sh --allow-no-terms     # generic detectors only (CI)
#
# You can also put one term per line in .check-clean-terms (gitignored) instead
# of passing them every time. Good terms: your name, every employer, your
# personal domain, your city, your school.
#
# Three scopes, two severities:
#   tracked files                        FAIL  (what a push publishes)
#   untracked, not ignored files         FAIL  (what `git add -A` would publish)
#   ignored files                        WARN  (what your .gitignore is protecting)
# No search terms configured also FAILS, unless you pass --allow-no-terms.
# .docx and .pdf files are binary and are not scanned.
#
# Exits 0 if nothing failed (warnings alone do not change this), 1 otherwise.

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
ALLOW_NO_TERMS=0
ARGS=()
for arg in "$@"; do
  case "$arg" in
    --allow-no-terms) ALLOW_NO_TERMS=1 ;;
    *) ARGS+=("$arg") ;;
  esac
done

# Never scan the terms file: it is made of the very strings we search for.
drop_terms_file() { grep -vx '\.check-clean-terms' || true; }
drop_noise() { grep -Ev '(^|/)(\.DS_Store|node_modules)(/|$)' || true; }

# Each scope is "name:severity:lister".
if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && \
   [ -n "$(git ls-files 2>/dev/null)" ]; then
  MODE="tracked files (fail), untracked files (fail), ignored files (warn)"
  list_tracked()   { git ls-files | drop_terms_file; }
  list_untracked() { git ls-files --others --exclude-standard | drop_terms_file | drop_noise; }
  list_ignored()   { git ls-files --others --ignored --exclude-standard | drop_terms_file | drop_noise; }
  SCOPES=("tracked:fail:list_tracked" "untracked:fail:list_untracked" "ignored:warn:list_ignored")
else
  # No commits yet: every file is one `git add` away from being published.
  MODE="all files (repo has no commits yet)"
  list_all() {
    find . -type f \
      -not -path './.git/*' \
      -not -path './node_modules/*' \
      -not -name '*.pdf' \
      -not -name '.DS_Store' | sed 's|^\./||' | drop_terms_file
  }
  SCOPES=("all:fail:list_all")
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

FAILED=0  # drives exit 1
WARNED=0  # display only

# report <label> <pattern> [fixed]: runs one detector over every scope.
report() {
  local label="$1" pattern="$2" fixed="${3:-}"
  local spec name severity lister
  for spec in "${SCOPES[@]}"; do
    IFS=: read -r name severity lister <<<"$spec"
    report_scope "$label" "$pattern" "$fixed" "$name" "$severity" "$lister"
  done
}

# report_scope <label> <pattern> <fixed|""> <scope name> <fail|warn> <lister>
report_scope() {
  local label="$1" pattern="$2" fixed="$3" name="$4" severity="$5" lister="$6"
  local flag="-InEH" hits
  [ "$fixed" = "fixed" ] && flag="-InFH"
  hits=$("$lister" | tr '\n' '\0' | xargs -0 grep "$flag" -- "$pattern" 2>/dev/null \
         | grep -Ev "$ALLOW" || true)
  [ -z "$hits" ] && return 0

  if [ "$severity" = "fail" ]; then
    FAILED=1
    printf '\n%s%s [%s]%s\n' "$RED$BOLD" "$label" "$name" "$RESET"
    printf '%s\n' "$hits" | sed 's/^/  /'
  else
    WARNED=1
    printf '\n%s%s [%s, warning]%s\n' "$YELLOW$BOLD" "$label" "$name" "$RESET"
    summarise_hits "$hits"
  fi
}

# summarise_hits: one line per top-level file or directory, with counts.
# Ignored trees can hold hundreds of Opportunities; listing lines is unreadable.
summarise_hits() {
  printf '%s\n' "$1" | awk -F: '
    {
      path = $1
      split(path, parts, "/")
      key = (index(path, "/") > 0) ? parts[1] "/" : path
      hits[key]++
      if (!((key SUBSEP path) in seen)) { seen[key SUBSEP path] = 1; files[key]++ }
    }
    END {
      for (k in hits)
        printf "  %s  %d %s in %d %s\n", k, hits[k], (hits[k] == 1 ? "hit" : "hits"), files[k], (files[k] == 1 ? "file" : "files")
    }' | sort
}

printf '\n%sScanning %s%s\n' "$BOLD" "$MODE" "$RESET"
printf '%sThe bundled fictional example is allowlisted.%s\n' "$DIM" "$RESET"
printf '%s.docx and .pdf files are binary and are NOT scanned. Check Archived Resumes by hand.%s\n' "$DIM" "$RESET"

report "Email addresses" "$EMAIL"
report "Phone numbers" "$PHONE"
report "LinkedIn profiles" "$LINKEDIN"
report "Street addresses" "$STREET"

# ---------------------------------------------------------------------------
# user-supplied terms
# ---------------------------------------------------------------------------
TERMS=()
[ "${#ARGS[@]}" -gt 0 ] && TERMS+=("${ARGS[@]}")
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
elif [ "$ALLOW_NO_TERMS" -eq 1 ]; then
  printf '\n%s%sRunning with --allow-no-terms: only the generic detectors ran.%s\n' "$YELLOW" "$BOLD" "$RESET"
  printf '%sThis is NOT a real pre-publish check. Names, employers, and domains were not searched.%s\n' "$YELLOW" "$RESET"
else
  FAILED=1
  printf '\n%s%sNo search terms configured, so this check cannot certify anything.%s\n' "$RED" "$BOLD" "$RESET"
  printf 'Pass your name, employers, and personal domain as arguments, or list them in\n'
  printf '.check-clean-terms. To run without terms on purpose (CI), pass --allow-no-terms.\n'
fi

# ---------------------------------------------------------------------------
printf '\n'
if [ "$WARNED" -eq 1 ]; then
  printf '%sWarning: personal data sits in ignored files (summary above). Git will not\n' "$YELLOW"
  printf 'publish it, but a changed .gitignore or a forced add would.%s\n\n' "$RESET"
fi

if [ "$FAILED" -eq 1 ]; then
  printf '%s%sCheck failed. Review every line above before publishing.%s\n' "$BOLD" "$RED" "$RESET"
  printf '%sA hit in LICENSE is normal if you are the copyright holder.%s\n\n' "$DIM" "$RESET"
  exit 1
fi

printf '%s%sNo personal data in tracked or untracked files.%s\n' "$BOLD" "$GREEN" "$RESET"
printf '%sThis is a mechanical check. Still read what you are publishing.%s\n\n' "$DIM" "$RESET"
exit 0
