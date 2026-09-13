# Making a non-functional requirement real

The BA writes what must be true: available, fast, retained, auditable, secure. **That is a
requirement, not a solution.** Turning it into a mechanism, at a cost somebody agreed to, with a
defined behaviour when it fails, is this role's work - and it is where most of a system's real
expense is decided.

## Every one becomes a mechanism, a cost, and a failure behaviour

| Requirement | Not an answer | An answer |
| :-- | :-- | :-- |
| highly available | "redundant infrastructure" | two instances across zones behind a health-checked balancer; a zone loss costs one in-flight request; about 40% more infrastructure |
| fast | "we will optimise" | the queue page renders in under 3 seconds at 500 items on SIT, from an index on (account, status); above 5,000 items it paginates |
| retained 7 years | "we keep the data" | monthly archive to cold storage, restore tested quarterly, cost about X a year and rising with volume |
| auditable | "we log everything" | every state change writes actor, before, after and source reference to an append-only table; the log is readable by compliance without a developer |

The pattern in each: **what mechanism, what it costs, and what happens when it does not hold.**
An NFR without the third part has not been designed, only hoped for.

## If it cannot be tested, it is not a requirement

Every non-functional requirement needs a way to tell whether it is met - by QA, not by you.
"Highly available" cannot be tested. "Survives the loss of one zone with no error returned to a
client that retries once" can, and belongs in the test register (`delivery-qa`).

Where the answer is that nobody will test it, say so explicitly and accept the requirement as
unverified. That is sometimes the right call. Leaving it unstated is not - it produces a system
everyone believes is resilient because nobody checked.

## Cost is part of the answer

An NFR met at any cost is not met responsibly. Bring the cost back to the PO and the PM, because
"available" and "available at four times the infrastructure bill" are different decisions and
only one of them is yours to make.

*Client work*: an NFR whose cost was never quoted is one the customer expects for free. Price it
while the scope is being agreed, not after the architecture assumes it.

## The ones that get forgotten

Ask about these; they rarely appear unprompted and they all change the design:

- **Volume, now and in three years** - the difference between a table and a partitioned store
- **Backup, and a tested restore** - an untested backup is a belief
- **Time zones and business calendars** - which decide what "end of day" means
- **What happens when a dependency is down** - fail, queue, degrade, or serve stale
- **Who may see what** - which is an architecture question, not only a UI one
- **How it is operated** - logs, health, and how someone knows it is broken before a customer does

`templates/nfr-table.md` turns a set of these into a set of mechanisms with owners.
