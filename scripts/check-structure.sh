#!/usr/bin/env bash
# check-structure.sh - the things that break a skill silently.
#
# A skill with a mistyped frontmatter name, or a plugin whose json does not parse, fails at load
# time in someone else's session rather than here. Cheap to check, so check it.

set -uo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 2
fail=0
note() { printf '  %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; fail=1; }

echo "json"
for f in $(git ls-files '*.json'); do
  python3 -c "import json,sys;json.load(open('$f'))" 2>/dev/null && note "ok   $f" || bad "$f does not parse"
done

echo
echo "marketplace lists every plugin that exists"
listed=$(python3 -c "
import json;print(' '.join(p['name'] for p in json.load(open('.claude-plugin/marketplace.json'))['plugins']))")
for d in plugins/*/; do
  name=$(basename "$d")
  case " $listed " in *" $name "*) note "ok   $name listed" ;; *) bad "$name is not in marketplace.json" ;; esac
done

echo
echo "plugins"
for d in plugins/*/; do
  name=$(basename "$d")
  pj="$d.claude-plugin/plugin.json"
  [ -f "$pj" ] || { bad "$name has no plugin.json"; continue; }
  got=$(python3 -c "import json;print(json.load(open('$pj'))['name'])")
  [ "$got" = "$name" ] && note "ok   $name" || bad "$pj says name=$got but lives in $name/"
done

echo
echo "skills"
for s in plugins/*/skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$s")")
  head -1 "$s" | grep -q '^---$' || { bad "$s has no frontmatter"; continue; }
  got=$(awk 'NR>1 && /^---$/{exit} NR>1' "$s" | sed -n 's/^name:[[:space:]]*//p' | tr -d '"')
  desc=$(awk 'NR>1 && /^---$/{exit} NR>1' "$s" | sed -n 's/^description:[[:space:]]*//p')
  [ "$got" = "$dir" ] && note "ok   $dir" || bad "$s says name=$got but lives in $dir/"
  [ -n "$desc" ] || bad "$s has no description - it is how the model decides to load the skill"
done

echo
echo "shell scripts parse and are executable"
for f in $(git ls-files '*.sh'); do
  bash -n "$f" 2>/dev/null || bad "$f has a syntax error"
  [ -x "$f" ] && note "ok   $f" || bad "$f is not executable - git records the bit"
done

echo
[ "$fail" -eq 0 ] && echo "structure ok" || echo "STRUCTURE FAILED"
exit "$fail"
