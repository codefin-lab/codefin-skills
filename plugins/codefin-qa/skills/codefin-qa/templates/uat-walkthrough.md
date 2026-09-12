# UAT walkthrough - <module or role>

| | |
| :-- | :-- |
| Customer participants | <name and role — the right person walks their own part> |
| Codefin | |
| Build | <fixed for the session; no deploys during UAT> |
| Environment | |
| Date | |

## Before the session

- [ ] every step below run end to end by QA on this exact build
- [ ] data exists for every case, including the awkward ones
- [ ] an account exists for each role, and someone has logged in with each
- [ ] known open defects listed below and shown to the customer **before** they find them

## Known limitations, disclosed up front

| Defect | What the customer will see | When it is fixed |
| :-- | :-- | :-- |

## Walkthrough

Steps in the customer's vocabulary, each carrying the requirement behind it so a question can be
answered from the document rather than from memory.

| # | Step | Expected | Requirement | Result | Note |
| :-- | :-- | :-- | :-- | :-- | :-- |
| 1 | | | `US-<epic>.<n>` | | |

## Findings

Recorded in the customer's words first. Classified out loud in the room, with the clause to hand.

| # | What the customer said | Defect or CR | Clause | Severity | Owner |
| :-- | :-- | :-- | :-- | :-- | :-- |

> Defect: the system contradicts the document. CR: the document did not say this.
> Do not negotiate a CR in the session — log it and take it to the BA process.

## Closing note, sent the same day

- what was walked, and what passed
- findings split into defects and CRs, with severity
- what is being fixed, and by when
- what is held for a later phase

Where a criterion was met but the customer is unhappy, say both: it was met, and the concern is
real and recorded as a CR.
