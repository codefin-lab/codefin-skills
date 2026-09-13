---
description: Run a test round end to end - check entry criteria, select by risk, run, record, and report the numbers that say whether the loop can stop.
argument-hint: [round number, build, or the area to cover]
---

Run a test round. Read `references/rounds.md` in the `delivery-qa` skill and work to it.

Round: **$ARGUMENTS**

## Entry criteria first, and hold them

Check before anything else: is the build deployed and its version recorded, is what changed since
the last round known, is test data seeded, are the selected scenarios testable, are known-broken
areas listed?

**If they are not met, say so and say what is needed.** Starting anyway wastes the round and
produces defect counts nobody can compare. It is a decision someone should make knowingly, not
one you make by pressing on.

## Select by risk, and write down what you excluded

Always: what changed since the last round and everything near it, plus the regression set —
scenarios that came from defects, and the paths money or irreversible actions take.

To find out what a change actually touches, use the blast-radius procedure in the `delivery-dev`
skill rather than guessing. "A shared library changed" and "one screen changed" call for very
different rounds.

Record the excluded list. It is the honest statement of what this round does not tell anybody,
and it belongs at the top of the report.

## Check the chain before you start

```bash
bash <skill>/scripts/trace-gaps.sh --register <register> --requirements <brd> --suite <dir>
```

Requirements with no scenario go to the BA now, not at the end. Scenarios with no automation are
fine where that was deliberate and a gap where it was forgotten — decide which, and say so.

## While running

- Record a result for every selected scenario. **Blank is not a pass**, and a round with blanks
  is not finished.
- **Blocked is its own result**, and the count of blocked scenarios is one of the more useful
  numbers in the report.
- Raise each defect properly when you find it (`references/reporting-defects.md`), with the
  expected result quoted from its acceptance criterion. A batch written from memory on Friday is
  a batch that bounces.
- Report daily: run, passed, failed, blocked, and what is stopping you. Surprises at the end of a
  round are almost always things somebody knew on day two.

## Reporting

Fill `templates/round-report.md`. The numbers are not optional: selected, run, passed, failed,
blocked; defects found and fixed this round; the running tally across rounds; P0, P1 and P2 still
open; and the find rate against previous rounds, which is what says whether the loop can stop.

End with QA's recommendation — proved or not proved, and what would change it.

**Exit is a recommendation, not a decision.** Say whether it is proved; whether to ship belongs
to the business. Never imply something is proved because a date is close.
