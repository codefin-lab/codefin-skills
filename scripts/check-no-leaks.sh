#!/usr/bin/env bash
# check-no-leaks.sh - this repository is public and was written from internal evidence.
#
#   check-no-leaks.sh              scan the tracked working tree
#   check-no-leaks.sh --history    scan every blob reachable from every ref as well
#
# Two layers, because the denylist is itself confidential:
#
#   1. Structural patterns, in rules() below. They name nobody, so they are safe to publish, and
#      they catch the shapes internal material arrives in - credentials, home paths, ticket keys,
#      private addresses, personal email, internal hostnames.
#   2. An optional denylist of actual names - clients, private repositories, people. It must
#      never be committed. Supply it as $LEAK_DENYLIST (newline separated) or in a gitignored
#      .leakpatterns file. CI reads it from a repository secret.
#
# Why --history exists: deleting a file does not unpublish it. A leak committed and then removed
# leaves the working tree clean while the blob stays readable to anyone who clones. Run the
# history scan before pushing; if it fails, the fix is to rewrite history, not to delete again.
#
# Exit 1 on any finding.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2

mode=tree
[ "${1:-}" = "--history" ] && mode=history

fail=0

# label <TAB> extended regex <TAB> regex of accepted matches to drop
# grep -E has no negative lookahead, so exclusions are a second pass; an inline (?!...) silently
# matches nothing, which is a gate that cannot fail.
rules() {
  printf '%s\t%s\t%s\n' \
    "credentials" \
    'ghp_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----|(password|passwd|secret|api[_-]?key|auth[_-]?token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']{6,}' \
    ''
  printf '%s\t%s\t%s\n' \
    "home directory path - use a neutral example instead" \
    '(/Users/|/home/)[a-z][a-z0-9_-]+' \
    ''
  printf '%s\t%s\t%s\n' \
    "personal or company email" \
    '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.(io|com|co\.th|net)' \
    ''
  printf '%s\t%s\t%s\n' \
    "ticket key that is not a documented placeholder" \
    '\b[A-Z]{2,6}-[0-9]{2,6}\b' \
    'ABC-123|DEF-118|TS-900|WCAG-|UTF-|RFC-|ISO-|SHA-|AES-|CIS-|MIT-'
  printf '%s\t%s\t%s\n' \
    "private network address or cloud account id" \
    '\b(10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|192\.168\.[0-9]{1,3}\.[0-9]{1,3}|[0-9]{12}\.dkr\.ecr\.)' \
    ''
  printf '%s\t%s\t%s\n' \
    "internal hostname" \
    '[a-z0-9-]+\.(internal|local|intranet|corp)\b' \
    ''
}

denylist() {
  [ -n "${LEAK_DENYLIST:-}" ] && { printf '%s\n' "$LEAK_DENYLIST"; return; }
  [ -f .leakpatterns ] && grep -vE '^\s*(#|$)' .leakpatterns
}

# ---------------------------------------------------------------- working tree
scan_tree() {
  local files label re allow hits
  files=$(git ls-files | grep -vE '^scripts/check-no-leaks\.sh$')
  echo "working tree: $(printf '%s\n' "$files" | grep -c .) tracked files"

  while IFS=$'\t' read -r label re allow; do
    hits=$(printf '%s\n' "$files" | xargs -r grep -nEI "$re" 2>/dev/null)
    [ -n "$allow" ] && hits=$(printf '%s\n' "$hits" | grep -vE "$allow")
    hits=$(printf '%s\n' "$hits" | grep -v '^$')
    [ -z "$hits" ] && continue
    printf '\n%s\n' "$label"; printf '%s\n' "$hits" | sed 's/^/  /'; fail=1
  done < <(rules)

  local dl; dl=$(denylist)
  if [ -z "$dl" ]; then
    printf '\nno denylist supplied - structural checks only.\n'
    printf 'Set LEAK_DENYLIST or create a gitignored .leakpatterns to also check real names.\n'
  else
    printf '\nchecking %s denylisted term(s)\n' "$(printf '%s\n' "$dl" | grep -c .)"
    while IFS= read -r term; do
      [ -z "$term" ] && continue
      local n; n=$(printf '%s\n' "$files" | xargs -r grep -lIiF -- "$term" 2>/dev/null)
      [ -z "$n" ] && continue
      # The term is confidential: report files, never the matched line.
      printf '\ndenylisted term found in:\n'; printf '%s\n' "$n" | sed 's/^/  /'; fail=1
    done <<< "$dl"
  fi
}

# ------------------------------------------------------------------- history
scan_history() {
  local blobs count dl
  blobs=$(git rev-list --objects --all \
          | git cat-file --batch-check='%(objecttype) %(objectname) %(rest)' 2>/dev/null \
          | awk '$1=="blob"{print $2"\t"$3}')
  count=$(printf '%s\n' "$blobs" | grep -c .)
  printf '\nhistory: %s blobs across every ref\n' "$count"
  dl=$(denylist)

  while IFS=$'\t' read -r sha path; do
    [ -z "$sha" ] && continue
    case $path in scripts/check-no-leaks.sh) continue ;; esac
    # grep -I skips binary content, which is why there is no hand-rolled NUL check here: a
    # `case $content in *$'\0'*)` never works, because a bash string cannot hold a NUL, so the
    # pattern collapses to ** and silently skips every blob.
    local content; content=$(git cat-file -p "$sha" 2>/dev/null) || continue

    while IFS=$'\t' read -r label re allow; do
      local hits; hits=$(printf '%s\n' "$content" | grep -nEI "$re" 2>/dev/null)
      [ -n "$allow" ] && hits=$(printf '%s\n' "$hits" | grep -vE "$allow")
      hits=$(printf '%s\n' "$hits" | grep -v '^$')
      [ -z "$hits" ] && continue
      printf '\n%s\n  in blob %s (%s)\n' "$label" "${sha:0:12}" "${path:-unnamed}"
      printf '%s\n' "$hits" | sed 's/^/    /'
      fail=1
    done < <(rules)

    if [ -n "$dl" ]; then
      while IFS= read -r term; do
        [ -z "$term" ] && continue
        printf '%s\n' "$content" | grep -qiIF -- "$term" && {
          printf '\ndenylisted term in blob %s (%s)\n' "${sha:0:12}" "${path:-unnamed}"; fail=1; }
      done <<< "$dl"
    fi
  done <<< "$blobs"
}

scan_tree
[ "$mode" = history ] && scan_history

echo
if [ "$fail" -eq 0 ]; then
  echo "clean"
else
  echo "FAILED - this repository is public. Remove the findings above before pushing."
  [ "$mode" = history ] && echo "A finding in history is not fixed by deleting the file; rewrite history."
fi
exit "$fail"
