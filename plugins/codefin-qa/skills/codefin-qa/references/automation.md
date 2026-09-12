# Automation

At Codefin, QA writes the automation. That makes the suite QA's own product, with the same
standards applied to it as to the system under test.

## What to automate

Automate what is **stable, repeated and expensive to run by hand**:

- the regression set - anything that has to keep working every round
- a case that came from a defect, always, so it cannot come back quietly
- long or error-prone sequences a person gets wrong at 5pm
- anything needing exact data setup or precise checking

Leave manual:

- a scenario that runs once
- anything still changing shape weekly - automating a moving target costs more than it saves
- judgement about how something looks or reads
- exploratory work, which is a different activity (`references/exploratory.md`)

A case marked "automate later" that has sat for two rounds is really a manual case. Say so in the
register rather than carrying a plan nobody will action.

## Naming

Every test names its scenario and the requirement behind it, so a failure in a log explains
itself without anyone opening the register:

```
TS-900 (US-3.4) an account with no holdings shows the empty state
DEF-118 (US-3.4) a holding with no valuation date no longer aborts the summary
```

The file carries the scenario id too, so the register's "Automated" column can point at it and
`scripts/trace-gaps.sh` can match them.

## Structure

- **Page objects, not selectors scattered through specs.** A screen change should break one file.
- **Fixtures that a person can read.** Someone must be able to see what case a fixture
  represents without running it.
- **No test depends on another test having run.** Order-dependence is the most common cause of a
  suite that passes locally and fails in CI.
- **Each test leaves the world as it found it**, or the round cannot be repeated.
- **Keep the trace and the screenshot on failure.** A failure nobody can diagnose gets labelled
  flaky and ignored, and that habit is how real failures get through.

## Testability is a finding, not a complaint

When something cannot be automated because the product does not allow it - no stable identifier
on an element, no way to reach a state, no way to seed the data - that is **raised as an item
with an owner**, exactly like a defect, and tracked until it is resolved.

Keep the list as a maintained document, not as remarks in a chat: what is untestable, why,
what is needed, and which scenarios are blocked by it. It is a deliverable QA owes Dev, and it
is the most effective way to make the suite better over time. `templates/testability-gaps.md`
has the shape.

## Flaky tests

A test that fails intermittently is a defect against the suite. Quarantine it the day it is
noticed, raise it with an owner, and fix or delete it. Never leave a known-flaky test in a
blocking gate, and never make re-running a red build the normal way to get it green.

## The layers

Which layer a test belongs to, and how the layers run as gates, is in the `codefin-dev` skill
(`references/testing.md`). Most of what QA writes is the top two layers; the unit layer belongs
to whoever writes the code, and asking for it is reasonable.
