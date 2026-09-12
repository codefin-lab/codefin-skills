# From acceptance criteria to scenarios and cases

The BA writes what must be true. QA works out what has to be exercised for anyone to believe it.
That step is the craft, and it is the one that gets compressed when a date is close - which is
why the defects found in UAT are so often in the cases nobody designed.

## Scenario or case

A **scenario** (`TS-<n>`) is a coherent thing a user or system does, traceable to a requirement:
"approve a withdrawal above the officer limit". A **case** is one run through it with particular
inputs and an expected result. One scenario usually holds several cases, and the cases are where
the thinking shows.

Derive scenarios from acceptance criteria first, and only then expand each into cases. Going
straight from a criterion to a single case is how coverage ends up meaning "the happy path ran".

## Getting the cases out of a criterion

Five techniques cover most of it. Use them deliberately rather than writing cases until you feel
finished.

**Equivalence classes.** Split each input into groups that should behave alike, and test one from
each rather than ten from one. An amount field is not one input; it is negative, zero, within
limit, above limit, and above any limit.

**Boundaries.** Defects cluster at edges. For a limit of 100,000: 99,999, 100,000, 100,001. For
dates: yesterday, today, tomorrow, the end of the period, the day after. For lists: none, one,
the page size, one past the page size.

**Decision tables.** When an outcome depends on several conditions together, put the conditions
down the side and the combinations across the top. This is the technique that exposes the case
nobody thought of, because it forces the combination rather than waiting for someone to imagine
it.

**State transitions.** Draw the states a thing can be in and the events that move it. Then test
the moves that should be impossible - approving something already approved, cancelling something
already settled, resuming what finished. Illegal transitions are where the interesting failures
live.

**The role matrix.** Capability down the side, role across the top. Every cell is a case: the
permitted ones must work, and the forbidden ones must be refused *and leave no data behind*. A
403 that still returns the payload is a failure most manual testing misses.

## The unhappy paths, again

The BA is asked to consider empty, invalid, not permitted, conflict, unavailable and partial.
QA's job is to notice which of those the criteria quietly left out, and to say so rather than
inventing an answer.

**Partial failure is the one most often missing.** What does the user see when it half worked,
and what state is the data left in? If the criteria do not say, that is a question for the BA,
not a guess for QA.

## How many cases is enough

Enough that you could say, out loud and specifically, why an untested combination is not worth
testing. "We covered the boundaries and each role; the remaining combinations differ only in a
field that nothing branches on" is an answer. "We ran out of time" is a risk to report, not a
coverage decision - and reporting it is the job.

Risk decides depth: money moving, anything irreversible, anything a regulator reads, and
anything a customer sees first get more cases. A settings page does not.

## Write the case so someone else can run it

Preconditions including the data it needs, the steps, and **one expected result stated
precisely enough to disagree with**. "Works correctly" is not a result. "The balance shows
1,250.00 and the audit log carries one entry with the source reference" is.

If a case cannot be written that precisely, the criterion behind it was not testable - send it
back (`codefin-ba`, `references/acceptance-criteria.md`).
