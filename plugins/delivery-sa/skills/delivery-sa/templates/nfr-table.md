# Non-functional requirements - <system>

The BA states what must be true. This table says **how**, at what cost, and what happens when it
does not hold. A row without the last two columns is a hope, not a design.

| # | Requirement (from the BA) | Mechanism | Cost | When it does not hold | How QA tells | Owner |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- |
| 1 | available during business hours | two instances across zones behind a health-checked balancer | about 40% more infrastructure | one in-flight request lost; a retry succeeds | kill one zone on SIT, a retrying client sees no error | |
| 2 | the queue is usable at volume | index on (account, status); pagination above 5,000 | one index, one migration | over 5,000 the page is paginated, not slow | 500 items on SIT render under 3 seconds | |
| 3 | statements retained 7 years | monthly archive to cold storage, restore tested quarterly | storage rising with volume; a quarterly exercise | restore takes hours, not minutes - stated to the customer | a restore is performed each quarter and timed | |

**Anything with no row in the "how QA tells" column is unverified**, and should be stated as
unverified rather than left to be assumed. That is sometimes the right decision; leaving it
unsaid never is.

**Cost belongs to the PO and the PM**, not to this table alone. "Available" and "available at
four times the infrastructure bill" are different decisions, and only one of them is the
architect's to take.
