#!/usr/bin/env bash
# trace-gaps.sh - where the chain from requirement to proof is broken.
#
#   trace-gaps.sh --register <file> [--requirements <file>] [--suite <dir>]
#
#   --register      the test register holding TS-<n> and the US it proves
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
# Both documents may be .md, .txt, .csv, .docx, .pdf or .xlsx - a register and a BRD are as
# likely to arrive in the format that was sent as in the one they were drafted in. A file it
# cannot read is an error, never an empty result: "no scenarios found" and "could not open it"
# look the same in a report and mean opposite things.
#
# .docx needs nothing. .pdf needs pdftotext (brew install poppler) or pypdf. .xlsx needs
# openpyxl.

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
import os, re, sys

register, requirements, suite = sys.argv[1], sys.argv[2], sys.argv[3]
TS = re.compile(r'\bTS-\d+\b')
US = re.compile(r'\bUS-\d+\.\d+\b')

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


def cells(path):
    """The document as lines, whatever the format."""
    return extract(path).splitlines()

for label, path in (("register", register), ("requirements", requirements)):
    if path and os.path.exists(path):
        try:
            extract(path)
        except RuntimeError as e:
            sys.exit(f"cannot read the {label} ({os.path.basename(path)}): {e}\n"
                     f"This is not an empty result - the file was never examined.")

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
    for line in cells(requirements):
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
