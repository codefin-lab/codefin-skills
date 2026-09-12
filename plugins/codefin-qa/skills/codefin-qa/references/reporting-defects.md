# Writing a defect that does not bounce

QA usually writes the defect. The procedure for investigating and fixing one is in the
`codefin-dev` skill (`references/defects.md`) and the record template is there too - this page
is only the reporter's side, which is the half that decides whether the fix goes well.

A defect that bounces - "cannot reproduce", "works as designed", "need more information" - has
usually cost more in round trips than it would have taken to write properly the first time.

## Before raising

- **Reproduce it twice.** Once may be the environment, the data, or you.
- **Find the smallest way to reproduce it.** A report with nine steps where three suffice sends
  the developer looking in the wrong place.
- **Check it is not already raised**, including under a different symptom of the same cause.
- **Decide whether it contradicts the document.** If it does not, it may be a CR - raise it as a
  question to the BA rather than as a defect. Getting this wrong in either direction wastes a
  cycle, and it is the argument most likely to end in a reopened ticket.

## What the report must carry

| | |
| :-- | :-- |
| What you did | numbered, minimal, reproducible by someone who has not seen it |
| What you saw | exactly - the message, the value, the state |
| What you expected | **quoted from the acceptance criterion**, with its `US-<epic>.<n>` |
| Where | environment, build or version, the account and role used |
| When | time, so it can be found in the logs |
| Evidence | screenshot, trace, the response body, the log line |
| Scenario | the `TS-<n>` this came from, or "found exploring" |

**The expected result is the field that stops the argument.** "Expected: it should work" invites
a discussion about intent. "Expected: US-3.4 criterion 2 - a customer with no holdings sees the
empty state, not an error" ends it.

## Severity, said the same way every time

Severity is about impact on the business, not about how annoying it was to find.

| | |
| :-- | :-- |
| **P0** | money or data wrong, security exposure, or the system unusable, with no workaround |
| **P1** | a main flow blocked, or a documented requirement not met, workaround painful or none |
| **P2** | works with a workaround, or affects a secondary path |
| **P3** | cosmetic, or noticed only by us |

Agree severity with the BA where money, data or regulation is involved - QA judges impact on
the test, the BA judges impact on the customer, and on those three subjects the customer's view
is the one that counts.

## After it is fixed

- **Re-test the exact case**, on the environment where it was reported.
- **Check the neighbours**, because the fix may have moved the problem rather than removed it.
- **Confirm a regression test exists.** The `codefin-dev` procedure requires the reproduction to
  become permanent; QA is who notices when it did not.
- **Add it to the register** as a scenario if it is not there, so it is covered every round from
  now on.
- **If it comes back, say which step was skipped.** Reopen counts by missing step are the most
  useful quality data the team is not yet collecting.
