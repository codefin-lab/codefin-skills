#!/usr/bin/env bash
# check-templates.sh - run the templates this repository ships.
#
# docs/adding-a-skill.md says a template only ships after it has been executed against
# something real. This is how that is enforced rather than promised: each unit-test template is
# copied over a minimal fixture in tests/fixtures/ and actually run.
#
#   check-templates.sh [go|python|typescript]...   (default: whichever toolchains are present)

set -uo pipefail
root=$(git rev-parse --show-toplevel) || exit 2
cd "$root" || exit 2

T=$root/plugins/delivery-dev/skills/delivery-dev/templates
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail=0
want=("$@")

wanted() { [ ${#want[@]} -eq 0 ] && return 0; printf '%s\n' "${want[@]}" | grep -qx "$1"; }
skip()   { printf '  skip %s - %s\n' "$1" "$2"; }
ok()     { printf '  pass %s\n' "$1"; }
bad()    { printf '  FAIL %s\n' "$1"; fail=1; }

echo "templates"

if wanted go; then
  if command -v go >/dev/null; then
    cp -R tests/fixtures/go "$work/go"
    cp "$T/unit-test.go" "$work/go/portfolio_test.go"
    if (cd "$work/go" && go test -race ./... >"$work/go.log" 2>&1); then ok "unit-test.go"
    else bad "unit-test.go"; sed 's/^/       /' "$work/go.log"; fi
  else skip "unit-test.go" "go not installed"; fi
fi

if wanted python; then
  if command -v python3 >/dev/null; then
    cp -R tests/fixtures/python "$work/py"
    cp "$T/unit-test.py" "$work/py/test_portfolio.py"
    if python3 -c 'import pytest' 2>/dev/null; then
      if (cd "$work/py" && python3 -m pytest -q >"$work/py.log" 2>&1); then ok "unit-test.py"
      else bad "unit-test.py"; sed 's/^/       /' "$work/py.log"; fi
    else skip "unit-test.py" "pytest not installed"; fi
  else skip "unit-test.py" "python3 not installed"; fi
fi

if wanted typescript; then
  if command -v npm >/dev/null; then
    cp -R tests/fixtures/typescript "$work/ts"
    cp "$T/unit-test.ts" "$work/ts/portfolio.test.ts"
    if (cd "$work/ts" && npm install --silent >"$work/ts.log" 2>&1 \
         && npx vitest run >>"$work/ts.log" 2>&1); then ok "unit-test.ts"
    else bad "unit-test.ts"; tail -20 "$work/ts.log" | sed 's/^/       /'; fi
  else skip "unit-test.ts" "npm not installed"; fi
fi

# The e2e and integration templates need a running system, so they are checked for syntax only.
# Saying so is better than implying they were run.
if wanted typescript && command -v node >/dev/null; then
  if node --experimental-strip-types --check "$T/e2e-spec.ts" 2>/dev/null \
     || npx --yes esbuild --log-level=error "$T/e2e-spec.ts" --outfile=/dev/null >/dev/null 2>&1; then
    ok "e2e-spec.ts (syntax only - needs a deployed system to run)"
  else
    printf '  note e2e-spec.ts not syntax-checked: no checker available\n'
  fi
fi

echo
[ "$fail" -eq 0 ] && echo "templates ok" || echo "TEMPLATES FAILED"
exit "$fail"
