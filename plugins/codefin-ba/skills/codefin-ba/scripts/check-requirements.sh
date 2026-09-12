#!/usr/bin/env bash
# check-requirements.sh - read a requirements document and report what a reviewer would find.
#
#   check-requirements.sh <file.md>...
#
# It checks the things that are mechanical, and says nothing about the things that are not:
#
#   - a requirement with no acceptance criteria - nobody can prove it
#   - an acceptance criterion carrying a word that hides a decision ("quickly", "properly")
#   - a requirement with no objective link - no stated reason to build it
#   - a duplicate identifier - two requirements that cannot both be cited
#   - an identifier referenced but never defined
#
# It cannot tell you whether a criterion is complete, whether the unhappy paths were considered,
# or whether the customer meant something else. Those need a person; this just clears the noise
# so the person has attention left for them.
#
# Expects the Codefin shape: requirement ids as US-<epic>.<n> or BR-<n>, objective links as
# OBJ-<n>, and acceptance criteria under each requirement.

set -uo pipefail
[ $# -ge 1 ] || { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

fail=0
vague='quickly|properly|correctly|gracefully|appropriate(ly)?|as needed|user.friendly|seamless(ly)?|efficient(ly)?|robust|intuitive|relevant|optimal|if necessary|where applicable|and so on|etc\.'

for doc in "$@"; do
  [ -f "$doc" ] || { echo "no such file: $doc" >&2; fail=1; continue; }
  printf '\n=== %s ===\n' "$doc"

  ids=$(grep -oE '\b(US-[0-9]+\.[0-9]+|BR-[0-9]+)\b' "$doc" | sort -u)
  [ -z "$ids" ] && { echo "  no requirement identifiers found - is this the right document?"; continue; }
  printf '  %s requirement identifier(s)\n' "$(printf '%s\n' "$ids" | grep -c .)"

  # duplicate definitions: an id that begins a line, or a table row, more than once
  dupes=$(grep -oE '^[|[:space:]]*\**\b(US-[0-9]+\.[0-9]+|BR-[0-9]+)\b' "$doc" \
          | grep -oE '(US-[0-9]+\.[0-9]+|BR-[0-9]+)' | sort | uniq -d)
  if [ -n "$dupes" ]; then
    printf '\n  defined more than once - a citation would be ambiguous:\n'
    printf '%s\n' "$dupes" | sed 's/^/    /'; fail=1
  fi

  # every requirement needs acceptance criteria and an objective
  missing_ac=""; missing_obj=""
  while IFS= read -r id; do
    [ -z "$id" ] && continue
    block=$(awk -v id="$id" '
      index($0, id) { hit=1 }
      hit { print; n++ }
      n > 12 { exit }' "$doc")
    # Look for a criterion, not merely for words that also occur in requirement prose:
    # an explicit Acceptance/AC line, or a Given...then construction on one line.
    printf '%s' "$block" \
      | grep -qiE '^[|[:space:]>*-]*(acceptance|AC)[[:space:]]*[:.]|given .*then |when .*then ' \
      || missing_ac="$missing_ac $id"
    printf '%s' "$block" | grep -qE 'OBJ-[0-9]+' || missing_obj="$missing_obj $id"
  done <<< "$ids"

  if [ -n "$missing_ac" ]; then
    printf '\n  no acceptance criteria found near:\n'
    for i in $missing_ac; do printf '    %s\n' "$i"; done; fail=1
  fi
  if [ -n "$missing_obj" ]; then
    printf '\n  no objective link (OBJ-<n>) near:\n'
    for i in $missing_obj; do printf '    %s\n' "$i"; done; fail=1
  fi

  # objectives cited but never defined
  cited=$(grep -oE '\bOBJ-[0-9]+\b' "$doc" | sort -u)
  if [ -n "$cited" ]; then
    while IFS= read -r o; do
      grep -qE "^[|[:space:]]*\**$o\b" "$doc" || { printf '\n  %s is cited but never defined\n' "$o"; fail=1; }
    done <<< "$cited"
  fi

  # the words that hide a decision
  vhits=$(grep -nEi "$vague" "$doc")
  if [ -n "$vhits" ]; then
    printf '\n  words that hide a decision - ask the question each one is concealing:\n'
    printf '%s\n' "$vhits" | sed 's/^/    /' | head -30
    n=$(printf '%s\n' "$vhits" | grep -c .)
    [ "$n" -gt 30 ] && printf '    ... %s more\n' "$((n - 30))"
    fail=1
  fi
done

printf '\n'
if [ "$fail" -eq 0 ]; then
  echo "nothing mechanical left to find. The judgement is still yours:"
  echo "  are the unhappy paths covered, are the numbers anchored, is this what they meant?"
else
  echo "findings above. None of them is fatal; all of them are cheaper to fix now than at UAT."
fi
exit "$fail"
