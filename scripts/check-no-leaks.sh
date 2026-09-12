#!/usr/bin/env bash
# check-no-leaks.sh - this repository is public and was written from internal evidence.
#
# Two layers, because the denylist is itself confidential:
#
#   1. Structural patterns, below. They name nobody, so they are safe to publish, and they catch
#      the shapes internal material arrives in - credentials, home paths, ticket keys, private
#      addresses, personal email.
#   2. An optional denylist of actual names - clients, private repositories, people. It must
#      never be committed. Supply it as $LEAK_DENYLIST (newline separated) or in a gitignored
#      .leakpatterns file. CI reads it from a repository secret.
#
# Exit 1 on any finding. Run it before every commit; CI runs it on every push.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2

fail=0
report() { printf '  %s\n' "$1"; fail=1; }

files=$(git ls-files | grep -vE '^scripts/check-no-leaks\.sh$')

scan() { # <label> <extended regex> [regex of accepted matches to drop]
  local label=$1 re=$2 allow=${3:-} hits
  # grep -E has no negative lookahead, so exclusions are a second pass rather than an
  # inline (?!...) - which silently matches nothing and gives a gate that cannot fail.
  hits=$(printf '%s\n' "$files" | xargs -r grep -nEI "$re" 2>/dev/null) || true
  [ -n "$allow" ] && hits=$(printf '%s\n' "$hits" | grep -vE "$allow")
  hits=$(printf '%s\n' "$hits" | grep -v '^$')
  [ -z "$hits" ] && return 0
  printf '\n%s\n' "$label"
  printf '%s\n' "$hits" | sed 's/^/  /'
  fail=1
}

echo "checking $(printf '%s\n' "$files" | wc -l | tr -d ' ') tracked files"

scan "credentials" \
  'ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(password|passwd|secret|api[_-]?key|auth[_-]?token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{6,}'

scan "home directory paths - use a neutral example instead" \
  '(/Users/|/home/)[a-z][a-z0-9_-]+'

scan "personal or company email" \
  '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.(io|com|co\.th|net)'

# ABC-123 is the documented placeholder in references/conventions.md; anything else looks real.
scan "ticket key that is not the documented placeholder" \
  '\b[A-Z]{2,6}-[0-9]{2,6}\b' \
  'ABC-123|DEF-118|WCAG-|UTF-|RFC-|ISO-|SHA-|AES-|CIS-|MIT-'

scan "private network address or cloud account id" \
  '\b(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|[0-9]{12}\.dkr\.ecr\.)'

scan "internal hostname" \
  '[a-z0-9-]+\.(internal|local|intranet|corp)\b'

# --- the private denylist -------------------------------------------------------------------
denylist=""
[ -n "${LEAK_DENYLIST:-}" ] && denylist=$LEAK_DENYLIST
[ -z "$denylist" ] && [ -f .leakpatterns ] && denylist=$(grep -vE '^\s*(#|$)' .leakpatterns)

if [ -z "$denylist" ]; then
  printf '\nno denylist supplied - structural checks only.\n'
  printf 'Set LEAK_DENYLIST or create a gitignored .leakpatterns to also check real names.\n'
else
  n=$(printf '%s\n' "$denylist" | grep -c .)
  printf '\nchecking %s denylisted term(s)\n' "$n"
  while IFS= read -r term; do
    [ -z "$term" ] && continue
    hits=$(printf '%s\n' "$files" | xargs -r grep -nIiF -- "$term" 2>/dev/null | wc -l | tr -d ' ')
    # The term itself is confidential, so report a count and the files, never the matched line.
    if [ "$hits" != "0" ]; then
      printf '\ndenylisted term found in %s place(s):\n' "$hits"
      printf '%s\n' "$files" | xargs -r grep -lIiF -- "$term" 2>/dev/null | sed 's/^/  /'
      fail=1
    fi
  done <<< "$denylist"
fi

echo
if [ "$fail" -eq 0 ]; then
  echo "clean"
else
  echo "FAILED - this repository is public. Remove the findings above before pushing."
fi
exit "$fail"
