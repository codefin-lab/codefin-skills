# The register

Manual test cases usually live in spreadsheets, one per module, versioned by round. Where they
do, that is the system of record, and this page is about keeping it honest rather than replacing
it.

## One direction only

**The register is the source. Automation is derived from it.**

When a scenario changes, it changes in the register first, and the automation follows. Edit both
independently and they diverge silently - and a suite that disagrees with the register is worse
than no suite, because people believe it.

Where a script generates feature files from the register, never hand-edit what it generated.
Anything you would want to hand-edit is a change the register should carry.

## Columns that earn their place

| Column | Why |
| :-- | :-- |
| `TS-<n>` | the scenario id, stable forever |
| Requirement | the `US-<epic>.<n>` it proves - the link that makes a failure meaningful |
| Module | how the register is split, and how a round is assigned |
| Title | readable on its own, in the customer's vocabulary |
| Precondition | including the data it needs |
| Steps | numbered |
| Expected result | precise enough to disagree with |
| Type | functional, negative, permission, boundary, non-functional |
| Priority | drives regression selection later |
| Automated | the file that automates it, or blank |
| Round result | one column per round: pass, fail, blocked, not run |
| Defect | the id raised when it failed |

Two of these are the ones people leave blank and later need most: **Requirement**, without which
nothing can be traced, and **Automated**, without which nobody can tell what the suite actually
covers.

## Identifiers are permanent

A `TS-<n>` is never reused and never renumbered, even when the scenario is dropped. Mark it
withdrawn and leave it. Renumbering breaks every defect, commit and test file that cited it, and
those citations are the whole point.

New scenarios take the next number. Do not arrange numbers to look tidy by module.

## Versioning a round

Keep one register per round rather than overwriting results - the comparison between rounds is
what shows whether things are getting better, and it is the first thing anyone asks. Name rounds
so they sort, and keep the previous round readable.

Each round records, per scenario: run or not, result, and the defect if it failed. A blank is not
a pass, and a round with blanks is not finished.

## Coverage, honestly

Coverage is not the number of cases. It is:

- which acceptance criteria have at least one scenario - anything missing is a gap the BA should
  see
- which scenarios ran this round
- which are automated, and which are deliberately manual

`scripts/trace-gaps.sh` computes the first and third from the register and the suite. The second
is yours to keep accurate during the round.

It reads the register as a spreadsheet, `.docx`, PDF, csv or markdown, so it works against
whichever copy is current rather than requiring the register to be converted first. A file it
cannot read is an error rather than an empty result - "no scenarios found" and "could not open
it" look the same in a report and mean opposite things.

A coverage report that counts cases without reference to requirements measures effort, not
coverage, and it will be quoted at you later.
