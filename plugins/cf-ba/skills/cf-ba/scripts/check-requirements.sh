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
# Reads .md, .txt, .csv, .docx, .pdf and .xlsx, because a BRD is as likely to arrive in the
# format that was sent to the customer as in the one it was drafted in. A document it cannot
# read is an error, never a pass - "no requirements found" and "could not open it" look the
# same in a report and mean opposite things.
#
# .docx needs nothing. .pdf needs pdftotext (brew install poppler) or pypdf. .xlsx needs
# openpyxl.
#
# Expects requirement ids as US-<epic>.<n> or BR-<n>, objective links as
# OBJ-<n>, and acceptance criteria under each requirement.

set -uo pipefail
[ $# -ge 1 ] || { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }


# Extracts to plain text on stdout; exits non-zero with a reason on stderr.
extract_text() {
  python3 - "$1" <<'PYEOF'
import sys
 # A BRD is as likely to arrive as .docx or PDF as it is as markdown, because those are what
# gets sent to the customer. Reading only text would mean reporting "nothing found" on the
# authoritative copy, which reads as a pass.
def extract(path):
    """Return the document's text, or raise RuntimeError saying why it could not be read."""
    import os, re, subprocess, zipfile
    ext = os.path.splitext(path)[1].lower()

    if ext in ('.md', '.txt', '.csv', '.tsv', '.markdown', '.rst', ''):
        return open(path, encoding='utf-8', errors='replace').read()

    if ext in ('.xlsx', '.xlsm'):
        try:
            from openpyxl import load_workbook
        except ImportError:
            raise RuntimeError("reading .xlsx needs openpyxl:  pip install openpyxl")
        wb = load_workbook(path, read_only=True, data_only=True)
        rows = []
        for ws in wb.worksheets:
            for row in ws.iter_rows(values_only=True):
                rows.append(" ".join(str(c) for c in row if c is not None))
        return "\n".join(rows)

    if ext == '.docx':
        # A .docx is a zip; no third-party package needed. Paragraph and row ends become
        # newlines so that line-oriented checks still mean something.
        with zipfile.ZipFile(path) as z:
            names = [n for n in ('word/document.xml',) if n in z.namelist()]
            if not names:
                raise RuntimeError(".docx has no word/document.xml - is it really a .docx?")
            xml = z.read(names[0]).decode('utf-8', errors='replace')
        xml = re.sub(r'</w:(p|tr)>', '\n', xml)
        xml = re.sub(r'<w:tab[^>]*/>', '\t', xml)
        return re.sub(r'<[^>]+>', '', xml)

    if ext == '.pdf':
        if subprocess.run(['which', 'pdftotext'], capture_output=True).returncode == 0:
            out = subprocess.run(['pdftotext', '-layout', path, '-'],
                                 capture_output=True, text=True)
            if out.returncode == 0:
                return out.stdout
            raise RuntimeError(f"pdftotext failed: {out.stderr.strip()[:120]}")
        try:
            from pypdf import PdfReader
        except ImportError:
            raise RuntimeError("reading .pdf needs pdftotext (brew install poppler) "
                               "or pypdf (pip install pypdf)")
        return "\n".join((p.extract_text() or "") for p in PdfReader(path).pages)

    raise RuntimeError(f"do not know how to read {ext or 'a file with no extension'}")


try:
    sys.stdout.write(extract(sys.argv[1]))
except RuntimeError as e:
    sys.stderr.write(str(e) + "\n"); sys.exit(3)
except Exception as e:
    sys.stderr.write(f"{type(e).__name__}: {e}\n"); sys.exit(3)
PYEOF
}

work=$(mktemp -d); trap 'rm -rf "$work"' EXIT

fail=0
vague='quickly|properly|correctly|gracefully|appropriate(ly)?|as needed|user.friendly|seamless(ly)?|efficient(ly)?|robust|intuitive|relevant|optimal|if necessary|where applicable|and so on|etc\.'

for doc in "$@"; do
  [ -f "$doc" ] || { echo "no such file: $doc" >&2; fail=1; continue; }
  printf '\n=== %s ===\n' "$doc"

  txt="$work/$(basename "$doc").txt"
  if ! extract_text "$doc" > "$txt" 2>"$work/err"; then
    printf '  CANNOT READ: %s\n' "$(cat "$work/err")"
    printf '  Not a pass - the document was never examined.\n'
    fail=1; continue
  fi

  ids=$(grep -oE '\b(US-[0-9]+\.[0-9]+|BR-[0-9]+)\b' "$txt" | sort -u)
  if [ -z "$ids" ]; then
    printf '  no requirement identifiers found.\n'
    printf '  The document was read (%s characters), so either it is the wrong file or the\n' "$(wc -c < "$txt" | tr -d ' ')"
    printf '  requirements are not numbered - both worth knowing.\n'
    fail=1; continue
  fi
  printf '  %s requirement identifier(s)\n' "$(printf '%s\n' "$ids" | grep -c .)"

  # duplicate definitions: an id that begins a line, or a table row, more than once
  dupes=$(grep -oE '^[|[:space:]]*\**\b(US-[0-9]+\.[0-9]+|BR-[0-9]+)\b' "$txt" \
          | grep -oE '(US-[0-9]+\.[0-9]+|BR-[0-9]+)' | sort | uniq -d)
  if [ -n "$dupes" ]; then
    printf '\n  defined more than once - a citation would be ambiguous:\n'
    printf '%s\n' "$dupes" | sed 's/^/    /'; fail=1
  fi

  # every requirement needs acceptance criteria and an objective
  missing_ac=""; missing_obj=""
  while IFS= read -r id; do
    [ -z "$id" ] && continue
    # The block belongs to this requirement alone: start at its identifier and stop at the
    # next one. A fixed line window instead bleeds into the following requirement and borrows
    # its criteria, which silently passes the requirement that has none - the exact failure
    # this check exists to catch.
    block=$(awk -v id="$id" '
      !hit && index($0, id) { hit = 1; print; next }
      hit && /(US-[0-9]+\.[0-9]+|BR-[0-9]+)/ { exit }
      hit { print; n++ }
      n > 30 { exit }' "$txt")
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
  cited=$(grep -oE '\bOBJ-[0-9]+\b' "$txt" | sort -u)
  if [ -n "$cited" ]; then
    while IFS= read -r o; do
      grep -qE "^[|[:space:]]*\**$o\b" "$txt" || { printf '\n  %s is cited but never defined\n' "$o"; fail=1; }
    done <<< "$cited"
  fi

  # the words that hide a decision
  vhits=$(grep -nEi "$vague" "$txt")
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
