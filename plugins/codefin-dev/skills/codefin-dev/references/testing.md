# The three layers, and how they fit together

Codefin already has all three layers somewhere. What it does not have is a way for them to
connect, or a guarantee that any of them ran. This file is about the shape; `references/stacks.md`
has the tools per language.

## The same four commands everywhere

Whatever the language, a Codefin repository answers to these four:

| Command | What it means |
| :-- | :-- |
| `make test` | unit only. Fast. Touches no network, no real database, no clock it does not control. |
| `make test-integration` | needs real things running. Takes `ENV=` |
| `make test-e2e` | drives the system the way a user does. Takes `ENV=` |
| `make test-all` | all three in order, stopping at the first red layer |

The point is not `make`. A repository driven by `npm scripts` or `just` keeps the same four
names and the same meanings - only the runner changes. The point is that anyone, and any agent,
can walk into any Codefin repository and know how to run the tests without reading anything
first. Inside, each target calls whatever the language actually uses.

`make test` in particular must stay fast and offline. The moment it needs a database, people
stop running it, and a gate nobody runs is not a gate.

## Which layer does a test belong to

Decide by what the test needs in order to fail honestly, not by what it is testing.

**Unit** - one piece of logic, everything at its edges substituted. Use a fake at the boundary
the code already defines (the repository interface, the port, the client), not a mock of every
call. A unit test that needs five mocks is telling you the unit has too many collaborators.
Deterministic: no sleeping, no real clock, no network, no shared state between cases.

**Integration** - the point where your code meets a real thing: a database with a real schema
and real migrations, a queue, a file share, an HTTP dependency, another service. One real thing
at a time where you can manage it. This is the layer that catches the failures in the blast
radius table in `references/defects.md`, which is why it is required whenever a change touches
a shared module, a contract, a data shape or a message between systems.

**E2E** - a path a user actually walks, through the interface they actually use, against a
deployed environment. Expensive and slow, so it covers journeys that matter rather than every
branch. E2E is not the place to send a case that could not be made to work at a lower layer;
that just moves a flaky test somewhere more expensive.

The common failure is integration tests quietly doing unit work: a suite that boots a whole
stack to assert a formatting rule. It is slow, it fails for unrelated reasons, and people learn
to ignore it. Push each case down to the cheapest layer that can still fail honestly.

## Naming, so a failure explains itself

Every test case carries the identifier it came from:

Name each case for whichever identifier it actually descends from, and cite the requirement:

- a case QA derived from a scenario starts with that `TS-<n>` and names the `US-<epic>.<n>` it
  proves
- a case a developer wrote straight from an acceptance criterion starts with the `US` - no
  scenario invented for the sake of the format
- a regression test starts with the defect it came from and names the `US` that was violated

```
TS-900 (US-3.4) a portfolio with no holdings shows the empty state, not an error
US-3.4 holdings are totalled across currencies at the given rate
DEF-118 (US-3.4) a holding with a null valuation date no longer aborts the page
```

The first is QA's, the second is a developer's unit test of the same requirement, and the third
came from a customer. All three name the promise they are about.

This is what makes the chain in `SKILL.md` real rather than aspirational. When a run goes red,
the failure names the clause of the agreement that is now untrue, and anyone - the BA included -
can read it.

It also means coverage can be discussed in the language of the agreement: which acceptance
criteria have a test, and which do not.

## Test data

- Fixtures live with the tests and are readable: a person should be able to see what case a
  fixture represents without running it.
- Seed data is separate from real data, and re-seeding is one command.
- A test leaves the world as it found it. A suite that only passes on a fresh database, or only
  passes once, is a suite that will be switched off.
- Never point a test at production, and never copy customer data into a fixture.

## Growing a suite that starts at zero

A service can easily reach production with no tests at all, and a plan to "go and write tests"
competes with delivery and loses. So the suite grows from work that is already happening:

- **every defect leaves its regression test behind** (`references/defects.md`, step 8)
- **every new acceptance criterion arrives with at least one test** (`references/workflow.md`)

That is enough. It means coverage grows exactly where the system has actually proven fragile,
which is better targeting than any coverage sweep would have produced.

For the coverage number itself, see `references/gates.md`: start by forbidding a decrease, not
by setting a target.
