#!/usr/bin/env bash
# trace-gaps.sh - where the chain from requirement to proof is broken.
#
#   trace-gaps.sh --register <file> [--requirements <file>] [--suite <dir>]
#
#   --register      the test register: .xlsx, .csv or .md holding TS-<n> and the US it proves
#   --requirements  the BRD, to find requirements with no scenario at all
#   --suite         the automation directory, to find scenarios never automated
#
# Reports four things, each of which is a hole somebody has to decide about:
#
#   1. requirements with no scenario          nobody is proving it
#   2. scenarios citing no requirement        testing something nobody asked for
#   3. scenarios never automated              fine if deliberate, a gap if forgotten
#   4. automation citing no scenario          a test the register does not know about
#
# It reads the register rather than asking you to keep a second copy of the truth. Reading .xlsx
# needs openpyxl (pip install openpyxl); .csv and .md need nothing.

set -uo pipefail

register=""; requirements=""; suite=""
while [ $# -gt 0 ]; do
  case $1 in
    --register)     register=${2:-}; shift 2 ;;
    --requirements) requirements=${2:-}; shift 2 ;;
    --suite)        suite=${2:-}; shift 2 ;;
    -h|--help)      sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option $1" >&2; exit 2 ;;
  esac
done
[ -n "$register" ] || { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }
[ -f "$register" ] || { echo "no such register: $register" >&2; exit 2; }

python3 - "$register" "$requirements" "$suite" <<'PY'
import os, re, sys, csv

register, requirements, suite = sys.argv[1], sys.argv[2], sys.argv[3]
TS = re.compile(r'\bTS-\d+\b')
US = re.compile(r'\bUS-\d+\.\d+\b')

def cells(path):
    """Every cell of the register as text, row by row, whatever the format."""
    ext = os.path.splitext(path)[1].lower()
    if ext in ('.xlsx', '.xlsm'):
        try:
            from openpyxl import load_workbook
        except ImportError:
            sys.exit("reading .xlsx needs openpyxl:  pip install openpyxl")
        wb = load_workbook(path, read_only=True, data_only=True)
        for ws in wb.worksheets:
            for row in ws.iter_rows(values_only=True):
                yield " ".join(str(c) for c in row if c is not None)
    elif ext == '.csv':
        with open(path, newline='', encoding='utf-8-sig') as fh:
            for row in csv.reader(fh):
                yield " ".join(row)
    else:
        with open(path, encoding='utf-8') as fh:
            for line in fh:
                yield line

# --- the register: scenario -> requirements it cites -------------------------------------
scenarios = {}
for row in cells(register):
    for ts in TS.findall(row):
        scenarios.setdefault(ts, set()).update(US.findall(row))

print(f"register: {len(scenarios)} scenario(s)")
if not scenarios:
    sys.exit("no TS-<n> found in the register - is this the right file?")

findings = 0

def report(title, items, note=""):
    global findings
    if not items:
        return
    findings += 1
    print(f"\n{title} ({len(items)})")
    if note:
        print(f"  {note}")
    for i in sorted(items):
        print(f"  {i}")

# 2. scenarios citing no requirement
report("scenarios citing no requirement",
       [ts for ts, us in scenarios.items() if not us],
       "each is either missing its link or testing something nobody asked for")

# 1. requirements with no scenario
if requirements and os.path.exists(requirements):
    want = set()
    with open(requirements, encoding='utf-8') as fh:
        for line in fh:
            want.update(US.findall(line))
    covered = set().union(*scenarios.values()) if scenarios else set()
    print(f"\nrequirements: {len(want)} referenced in {os.path.basename(requirements)}")
    report("requirements with no scenario", want - covered,
           "nobody is proving these")
    orphan = covered - want
    report("scenarios citing a requirement the document does not define", orphan,
           "a renumbered or withdrawn requirement, or a typo")

# 3 and 4. the suite
if suite and os.path.isdir(suite):
    automated, files_without = set(), []
    for root, _, files in os.walk(suite):
        if any(p in root for p in ('node_modules', '.git')):
            continue
        for f in files:
            if not f.endswith(('.feature', '.spec.ts', '.spec.js', '.test.ts', '_test.go', '.py')):
                continue
            path = os.path.join(root, f)
            try:
                text = open(path, encoding='utf-8', errors='ignore').read()
            except OSError:
                continue
            found = set(TS.findall(f)) | set(TS.findall(text))
            if found:
                automated |= found
            else:
                files_without.append(os.path.relpath(path, suite))
    print(f"\nsuite: {len(automated)} scenario(s) automated")
    report("scenarios in the register with no automation", set(scenarios) - automated,
           "fine where that is deliberate - a gap where it was forgotten")
    report("automation citing a scenario the register does not hold", automated - set(scenarios),
           "the register is the source; these are out of step with it")
    report("test files naming no scenario", set(files_without),
           "a failure here will not say what promise it broke")

print()
if findings == 0:
    print("the chain is unbroken. Coverage of the criteria themselves is still a judgement:")
    print("  every requirement has a scenario, but does every scenario have the cases it needs?")
    sys.exit(0)
print("findings above. Each is a decision, not necessarily a mistake - but an undecided one.")
sys.exit(1)
PY
