#!/usr/bin/env bash
# forecast.sh - at the rate this project is actually going, what will it have cost?
#
#   forecast.sh <feature-list> [--rate <days-per-week>]
#
# Reads the feature list - .xlsx, .csv, .md, .docx or PDF - and recomputes the arithmetic a
# project manager otherwise redoes by hand every week, from columns it finds by name:
#
#   feature / item          what the work is
#   estimate / estimated    days sized by the BA
#   spent / actual          days consumed
#   status                  accepted / done / in progress / not started / blocked
#
# It reports days spent against estimated, features accepted against agreed, the rate those two
# imply, and what that rate does to the work remaining. It also reports rows whose numbers
# contradict each other, because a forecast from broken data is worse than none.
#
# What it cannot see: whether "accepted" means QA proved it, whether the remaining work is like
# the work already done, and every risk in the register. It does arithmetic. The judgement -
# and the decision about what to tell the customer - stays yours.

set -uo pipefail
[ $# -ge 1 ] || { sed -n '2,22p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

file=$1; shift
rate=""
while [ $# -gt 0 ]; do
  case $1 in
    --rate) rate=${2:-}; shift 2 ;;
    *) echo "unknown option $1" >&2; exit 2 ;;
  esac
done
[ -f "$file" ] || { echo "no such file: $file" >&2; exit 2; }

python3 - "$file" "$rate" <<'PY'
import os, re, subprocess, sys, zipfile, csv, io

path, rate = sys.argv[1], sys.argv[2]

def rows(path):
    """Every row as a list of cell strings, whatever the format."""
    ext = os.path.splitext(path)[1].lower()
    if ext in ('.xlsx', '.xlsm'):
        try:
            from openpyxl import load_workbook
        except ImportError:
            sys.exit("reading .xlsx needs openpyxl:  pip install openpyxl")
        wb = load_workbook(path, read_only=True, data_only=True)
        for ws in wb.worksheets:
            for r in ws.iter_rows(values_only=True):
                yield ["" if c is None else str(c) for c in r]
        return
    if ext == '.csv':
        with open(path, newline='', encoding='utf-8-sig') as fh:
            for r in csv.reader(fh):
                yield r
        return
    if ext == '.docx':
        with zipfile.ZipFile(path) as z:
            xml = z.read('word/document.xml').decode('utf-8', errors='replace')
        xml = re.sub(r'</w:(p|tr)>', '\n', xml)
        xml = re.sub(r'</w:tc>', '\t', xml)
        for line in re.sub(r'<[^>]+>', '', xml).splitlines():
            yield [c.strip() for c in line.split('\t')]
        return
    if ext == '.pdf':
        if subprocess.run(['which', 'pdftotext'], capture_output=True).returncode == 0:
            out = subprocess.run(['pdftotext', '-layout', path, '-'], capture_output=True, text=True)
            for line in out.stdout.splitlines():
                yield re.split(r'\s{2,}', line.strip())
            return
        sys.exit("reading .pdf needs pdftotext (brew install poppler)")
    # markdown or plain text: treat pipe tables as rows
    with open(path, encoding='utf-8', errors='replace') as fh:
        for line in fh:
            if '|' in line:
                yield [c.strip() for c in line.strip().strip('|').split('|')]

WANT = {
    'feature':  re.compile(r'^(feature|item|work|deliverable|scope)', re.I),
    'estimate': re.compile(r'^(estimate|estimated|md|man.?day|effort|size)', re.I),
    'spent':    re.compile(r'^(spent|actual|used|consumed|burn)', re.I),
    'status':   re.compile(r'^(status|state|progress)', re.I),
}
ACCEPTED = re.compile(r'^(accepted|done|complete|completed|closed|passed)$', re.I)
NOTSTART = re.compile(r'^(not started|todo|backlog|new|-|)$', re.I)
BLOCKED  = re.compile(r'^(blocked|on hold|waiting)$', re.I)

def num(s):
    m = re.search(r'-?\d+(?:\.\d+)?', str(s).replace(',', ''))
    return float(m.group()) if m else None

header, idx, data = None, {}, []
for r in rows(path):
    if not any(c.strip() for c in r):
        continue
    if header is None:
        found = {}
        for i, c in enumerate(r):
            for key, pat in WANT.items():
                if key not in found and pat.match(c.strip()):
                    found[key] = i
        if 'feature' in found and 'estimate' in found:
            header, idx = r, found
        continue
    if all(set(c.strip()) <= set('-: ') for c in r if c.strip()):
        continue          # markdown table rule
    data.append(r)

if header is None:
    sys.exit("no feature list found. Expected a header row with a feature column and an "
             "estimate column; see this script's usage for the names it looks for.")

def cell(row, key):
    i = idx.get(key)
    return row[i].strip() if i is not None and i < len(row) else ""

items = []
for r in data:
    name = cell(r, 'feature')
    if not name:
        continue
    items.append({'name': name, 'est': num(cell(r, 'estimate')),
                  'spent': num(cell(r, 'spent')), 'status': cell(r, 'status')})

if not items:
    sys.exit("the header was found but no rows under it carried a feature name.")

est_total   = sum(i['est'] or 0 for i in items)
spent_total = sum(i['spent'] or 0 for i in items)
accepted    = [i for i in items if ACCEPTED.match(i['status'])]
blocked     = [i for i in items if BLOCKED.match(i['status'])]
est_done    = sum(i['est'] or 0 for i in accepted)
est_left    = est_total - est_done

print(f"\n=== {os.path.basename(path)} ===\n")
print(f"  features      {len(accepted)} accepted of {len(items)} agreed"
      + (f", {len(blocked)} blocked" if blocked else ""))
print(f"  days          {spent_total:g} spent of {est_total:g} estimated")

problems = []
for i in items:
    if i['est'] is None:                      problems.append((i['name'], "no estimate"))
    elif (i['spent'] or 0) > 0 and ACCEPTED.match(i['status']) is None and NOTSTART.match(i['status']):
        problems.append((i['name'], f"{i['spent']:g} days spent but status is '{i['status'] or 'blank'}'"))
    if ACCEPTED.match(i['status']) and (i['spent'] or 0) == 0:
        problems.append((i['name'], "accepted with no days recorded"))

# The rate is what accepted work actually cost against what it was estimated at. Dividing
# total spend by accepted estimate instead sweeps days spent on unfinished work into the
# rate and inflates it wildly - on a real list that read 264% where the truth was 143%,
# which is the difference between a steering report that informs and one that alarms.
spent_done = sum(i['spent'] or 0 for i in accepted)
spent_wip  = spent_total - spent_done

if est_done == 0:
    print("\n  No feature is accepted yet, so there is no observed rate to forecast from.")
    print("  Spend so far tells you nothing about the finish until something is accepted -")
    print("  which is the reason to get one thing all the way through early.")
else:
    observed = spent_done / est_done
    # Accepted work costs what it cost. Everything else is forecast at the observed rate, but
    # never below what it has already consumed - a forecast lower than the money already spent
    # is a number nobody can defend, and an item that has blown past its estimate does not get
    # cheaper by being unfinished.
    def item_forecast(i):
        return max((i['est'] or 0) * observed, i['spent'] or 0)
    forecast = spent_done + sum(item_forecast(i) for i in items if not ACCEPTED.match(i['status']))
    over = forecast - est_total
    print(f"\n  observed rate {observed:.2f}x  ({spent_done:g} days spent on work estimated at {est_done:g})")
    if spent_wip:
        print(f"  in progress   {spent_wip:g} days already spent on work not yet accepted")
    print(f"  remaining     {est_left:g} estimated days, {est_left * observed:.1f} at the observed rate")
    print(f"  forecast      {forecast:.1f} days against an estimate of {est_total:g}"
          f"  ({'+' if over >= 0 else ''}{over:.1f}, {forecast / est_total * 100:.0f}%)")
    # An unfinished item that has already outrun its forecast is worth naming on its own.
    burnt = [i for i in items if not ACCEPTED.match(i['status']) and i['est']
             and (i['spent'] or 0) > i['est'] * observed]
    if burnt:
        print(f"\n  already past their forecast before being accepted:")
        for i in burnt:
            print(f"    {i['name'][:44]:<46} {i['spent']:g} spent, {i['est'] * observed:.1f} forecast")
    if rate:
        try:
            per_week = float(rate)
            print(f"  at {per_week:g} days a week, {(forecast - spent_total) / per_week:.1f} weeks remain")
        except ValueError:
            print(f"  (--rate {rate} is not a number)")
    if observed > 1.15:
        print(f"\n  Forecasting the rest at 1.0 because the hard part is behind you is how a final")
        print(f"  overrun arrives as a surprise. If you believe the rate will improve, say why,")
        print(f"  and say what would show it - then check that next week.")

if problems:
    print(f"\n  tracking data that contradicts itself ({len(problems)}):")
    for n, why in problems[:15]:
        print(f"    {n[:48]:<50} {why}")
    if len(problems) > 15:
        print(f"    ... {len(problems) - 15} more")
    print("  A forecast from broken data is worse than none - these change the numbers above.")

print("\n  This is arithmetic. Whether the remaining work resembles the work already done,")
print("  whether 'accepted' means QA proved it, and everything in the risk register are")
print("  yours to weigh.\n")
sys.exit(1 if problems else 0)
PY
