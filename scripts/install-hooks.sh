#!/usr/bin/env bash
# install-hooks.sh - run the leak check before the irreversible step.
#
# Opt in, because a hook changes how your git behaves:
#
#   ./scripts/install-hooks.sh          install
#   ./scripts/install-hooks.sh --remove uninstall
#
# There is deliberately no sanitiser here. What actually leaks is rarely a name a script can
# substitute - it is a sentence describing something internal, which only a person reading it
# will catch. A tool that rewrites text automatically would hide that work rather than do it.
# So this verifies and refuses; the judgement stays with the author.

set -uo pipefail
root=$(git rev-parse --show-toplevel) || exit 2
hook="$root/.git/hooks/pre-push"

if [ "${1:-}" = "--remove" ]; then
  [ -f "$hook" ] && rm -f "$hook" && echo "removed $hook" || echo "no hook installed"
  exit 0
fi

cat > "$hook" <<'HOOK'
#!/usr/bin/env bash
# Installed by scripts/install-hooks.sh. Remove with ./scripts/install-hooks.sh --remove.
root=$(git rev-parse --show-toplevel)
echo "pre-push: checking for leaks, history included"
if ! "$root/scripts/check-no-leaks.sh" --history; then
  echo
  echo "push refused. This repository is public."
  echo "A finding in history is not fixed by deleting the file - rewrite history first."
  exit 1
fi
HOOK
chmod +x "$hook"
echo "installed $hook"
echo "it runs check-no-leaks.sh --history before every push"
