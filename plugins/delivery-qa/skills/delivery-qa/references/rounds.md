# Running a round

A round is a bounded attempt to prove a build, with a beginning, an end and a number at the end.
Testing that runs continuously without rounds cannot answer the only question management
actually asks: is it getting better, and can we stop?

## Before it starts

Agree entry criteria and hold them. Starting a round on a build that will not survive the first
hour wastes the round and, worse, produces defect counts nobody can compare.

- the build is deployed to the test environment, and its version is recorded
- what changed since the last round is known
- test data is seeded and the environment is usable
- the scenarios for this round are selected, and QA agrees they are testable
- known-broken areas are listed, so time is not spent rediscovering them

If entry criteria are not met, say so and say what is needed. Starting anyway is a decision
someone should make knowingly.

## Choosing what to run

A full pass every round is rarely affordable and rarely necessary. Select by risk:

- **always**: anything touched since the last round, and everything near it
- **always**: the regression set - scenarios that came from defects, and the paths money or
  irreversible actions take
- **usually**: high-priority scenarios in modules that changed
- **sometimes**: everything else, on a rotation so nothing goes untested for too many rounds

What the change actually touches is a question the `delivery-dev` skill has a procedure and a
tool for. Ask rather than guessing - "we changed the shared library" and "we changed one screen"
call for very different rounds.

Write down what you chose **and what you excluded**. The excluded list is the honest statement of
what this round does not tell anybody.

## During

- Record a result for every selected scenario. Blank is not a pass, and a round with blanks is
  not finished.
- Raise defects as you find them, properly the first time
  (`references/reporting-defects.md`) - a batch written from memory on Friday is a batch that
  bounces.
- **Blocked is its own result.** A scenario that could not run because something upstream was
  broken is not a failure and not a pass, and the count of blocked scenarios is one of the more
  useful numbers in the report.
- Report daily during an active round: run, passed, failed, blocked, and what is stopping you.
  Surprises at the end of a round are almost always things somebody knew on day two.

## The numbers

Every round report carries:

| | |
| :-- | :-- |
| Scenarios | selected, run, passed, failed, blocked |
| Defects | found this round, fixed this round |
| Running tally | found and fixed across all rounds |
| Still open | P0, P1, P2 |
| Coverage | which acceptance criteria have a scenario, and which of those ran |

The tally is what tells anyone whether the loop can stop. A falling find-rate across rounds
means the system is converging; a flat one means it is not, whatever the pass rate says.

## Exit criteria

Agree them before the round, not after the results are in. Typically: no P0 open, P1s either
fixed or accepted in writing with a named owner, every selected scenario has a result, and the
regression set passed.

**Exit is a recommendation, not a decision.** QA says whether it is proved; the PO decides
whether it is accepted, and the PM decides whether to ship. Both are legitimate - what is not legitimate is QA implying it is proved
because a date is close, or a ship decision going unrecorded. Where one is taken against QA's
recommendation, what is being accepted is written down (`delivery-pm`).

`templates/round-report.md` has the shape.
