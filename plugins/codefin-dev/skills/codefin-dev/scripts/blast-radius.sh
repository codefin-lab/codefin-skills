#!/usr/bin/env bash
# blast-radius.sh - who depends on the thing you are about to change.
#
# Step 5 of the defect procedure (references/defects.md). It exists because that step is the
# one most often skipped, and it is skipped because doing it by hand is tedious.
#
#   blast-radius.sh [options] <symbol>        (options may also follow the symbol)
#
#   <symbol>   a function, type, column, topic, field, component or config key
#   -C         the repository you are changing        (default: cwd)
#   -l         root holding sibling clones            (default: parent of -C)
#   -o         a GitHub org to search too, repeatable (costs one code-search call each)
#   -x         restrict remote search by extension, repeatable (e.g. -x go -x sql)
#   -q         quiet: counts only, no matching lines
#
# Local search is free and always runs. Remote search needs `gh auth` and is limited to about
# ten queries a minute, so it runs one query per org rather than one per repository.
#
# This tool finds candidates. It cannot tell you an indirect call through an interface - for
# that, ask the language server for references as well (references/stacks.md).

set -uo pipefail

die() { printf 'blast-radius: %s\n' "$1" >&2; exit 2; }

repo=$PWD; local_root=""; quiet=0; orgs=(); exts=(); positional=()

# Parsed by hand rather than with getopts so that options may appear anywhere, including after
# the symbol - which is how people actually type it.
while [ $# -gt 0 ]; do
  case $1 in
    -C) [ $# -ge 2 ] || die "-C needs a value"; repo=$2; shift 2 ;;
    -l) [ $# -ge 2 ] || die "-l needs a value"; local_root=$2; shift 2 ;;
    -o) [ $# -ge 2 ] || die "-o needs a value"; orgs+=("$2"); shift 2 ;;
    -x) [ $# -ge 2 ] || die "-x needs a value"; exts+=("$2"); shift 2 ;;
    -q) quiet=1; shift ;;
    -h|--help) sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --) shift; while [ $# -gt 0 ]; do positional+=("$1"); shift; done ;;
    -*) die "unknown option $1" ;;
    *) positional+=("$1"); shift ;;
  esac
done
set -- "${positional[@]+"${positional[@]}"}"

[ $# -ge 1 ] || die "give me a symbol to trace. -h for usage."
symbol=$1
[ -d "$repo" ] || die "no such directory: $repo"
repo=$(cd "$repo" && pwd)
[ -n "$local_root" ] || local_root=$(dirname "$repo")

hits_here=0
declare -a siblings_hit=()

printf '\n=== blast radius: %s ===\n' "$symbol"

# --- the repository you are changing -----------------------------------------------------
printf '\n-- this repository (%s) --\n' "$(basename "$repo")"
if git -C "$repo" rev-parse --git-dir >/dev/null 2>&1; then
  hits_here=$(git -C "$repo" grep -InF -- "$symbol" 2>/dev/null | wc -l | tr -d ' ')
  if [ "$hits_here" -eq 0 ]; then
    printf '   no match. Check the spelling, or the symbol is only reached indirectly.\n'
  else
    printf '   %s matching lines\n' "$hits_here"
    [ "$quiet" -eq 1 ] || git -C "$repo" grep -InF -- "$symbol" 2>/dev/null | head -40 | sed 's/^/   /'
    [ "$quiet" -eq 1 ] || [ "$hits_here" -le 40 ] || printf '   ... %s more\n' "$((hits_here - 40))"
  fi
else
  printf '   not a git repository, skipped\n'
fi

# --- sibling clones on this machine ------------------------------------------------------
printf '\n-- sibling clones under %s --\n' "$local_root"
found_sibling=0
while IFS= read -r gitdir; do
  sib=$(dirname "$gitdir")
  [ "$sib" = "$repo" ] && continue
  n=$(git -C "$sib" grep -IlF -- "$symbol" 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" -eq 0 ] && continue
  found_sibling=1
  siblings_hit+=("$sib")
  printf '   %-34s %s files\n' "$(basename "$sib")" "$n"
  [ "$quiet" -eq 1 ] || git -C "$sib" grep -IlF -- "$symbol" 2>/dev/null | head -6 | sed 's|^|      |'
done < <(find "$local_root" -maxdepth 2 -name .git 2>/dev/null)
[ "$found_sibling" -eq 1 ] || printf '   nothing\n'

# --- GitHub code search, one query per org ------------------------------------------------
if [ ${#orgs[@]} -gt 0 ]; then
  if ! command -v gh >/dev/null 2>&1; then
    printf '\n-- remote --\n   gh is not installed, skipped\n'
  else
    extargs=()
    for e in "${exts[@]:-}"; do [ -n "$e" ] && extargs+=(--extension "$e"); done
    for org in "${orgs[@]}"; do
      printf '\n-- github: %s --\n' "$org"
      out=$(gh search code --owner "$org" "$symbol" "${extargs[@]}" \
              --limit 60 --json repository,path 2>&1) || {
        printf '   search failed (rate limit is ~10/min): %s\n' "$(printf '%s' "$out" | head -1)"
        continue
      }
      printf '%s' "$out" | python3 -c '
import json,sys,collections
try: rows=json.load(sys.stdin)
except Exception: sys.exit(0)
by=collections.defaultdict(list)
for r in rows: by[r["repository"]["nameWithOwner"]].append(r["path"])
if not by: print("   nothing"); sys.exit(0)
for name,paths in sorted(by.items(), key=lambda kv:(-len(kv[1]),kv[0])):
    print(f"   {name:<44} {len(paths)} files")
    for p in paths[:4]: print(f"      {p}")
    if len(paths)>4: print(f"      ... {len(paths)-4} more")
'
    done
  fi
else
  printf '\n-- remote --\n   not searched. Add -o <org> when the thing you are changing is shared.\n'
fi

# --- what to do with this ------------------------------------------------------------------
cat <<'NOTE'

-- next --
   Record this in the defect record even if nothing was found: "checked, nothing depends on it"
   is evidence; a blank field is not.

   Watch for a COPY of the thing rather than a use of it - a vendored or pasted duplicate will
   not receive your fix, and is a common source of a defect that reopens.

   grep cannot see an indirect call through an interface. Ask the language server for
   references as well.

   Anything found here that crosses a repository boundary makes the integration layer
   mandatory in step 9, not optional.
NOTE
