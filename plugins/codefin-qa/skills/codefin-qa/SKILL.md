---
name: codefin-qa
description: "Quality assurance at Codefin. Use when designing test scenarios or cases from acceptance criteria, maintaining the test register, writing or reviewing test automation, planning or running a SIT round, choosing what to regression test, running exploratory sessions, taking a customer through UAT, or deciding whether something has been proved."
---

# Quality assurance at Codefin

QA decides one question, and it is not whether the system is good.

> **Has the claim been proved?**

What the system *should* do belongs to the BA, and how it is built belongs to Dev. QA owns
whether the evidence is good enough to say it works - and at Codefin, QA writes the automation
that produces most of that evidence.

## The two identifiers

The BA numbers what was agreed. QA numbers how it gets proved. Both travel together, so a red
run names the promise that is now untrue and a customer's complaint can be traced to the case
that should have caught it.

```
US-<epic>.<n>   the requirement and its acceptance criteria, from the BRD
  └─ TS-<n>     the scenario QA derives to prove it
      └─ cases  manual in the register, automated in the suite, both named for the TS
```

A requirement with no scenario has nobody proving it. A scenario citing no requirement is
testing something nobody asked for. `scripts/trace-gaps.sh` finds both, plus scenarios written
but never automated.

## What does not bend

- **An acceptance criterion that cannot be tested goes back to the BA before work starts**, not
  at the end of the round. Catching it late is how a release slips over a sentence.
- **Every case names its scenario, and every scenario names its requirement.** A test whose name
  explains nothing produces a failure that explains nothing.
- **The register is the source; automation is derived from it.** Edit both independently and they
  diverge silently, which is worse than having only one.
- **What cannot be tested is a finding, not a complaint.** Missing test identifiers, no way to
  reach a state, no test data - these are raised as items with owners, the same as any defect.
  See `references/automation.md`.
- **A round reports numbers**: found, fixed, the running tally across rounds, and how many P0,
  P1 and P2 remain open. A falling rate is what says the loop can stop; a list of descriptions
  says nothing.
- **A flaky test is a defect against the suite.** Quarantine it the day it is noticed. Teaching
  the team to re-run until green is how a real failure gets through.

## Where to read next

| You are | Read |
| :-- | :-- |
| turning acceptance criteria into scenarios and cases | `references/designing-tests.md` |
| maintaining the register, or numbering scenarios | `references/test-register.md` |
| writing or reviewing automation | `references/automation.md` |
| planning or running a round, or choosing regression | `references/rounds.md` |
| testing without a script | `references/exploratory.md` |
| taking the customer through UAT | `references/uat.md` |
| reporting a defect so it does not bounce | `references/reporting-defects.md` |

## Shared with the other skills

The three test layers, what belongs in each, and how they run as gates are in the `codefin-dev`
skill (`references/testing.md`, `references/gates.md`); this skill does not restate them. The
defect procedure and its record are there too - `references/reporting-defects.md` here covers
only the reporter's side. What makes an acceptance criterion testable is in the `codefin-ba`
skill, which is what you cite when sending one back.
