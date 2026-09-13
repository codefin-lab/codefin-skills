---
name: delivery-pm
description: "Planning a project or replanning it, tracking cost against the estimate, forecasting a completion date, keeping the risk register live, preparing a steering report, deciding what to cut, and deciding whether to ship."
---

# Running the project

This role owns **when, at what cost, and what gets cut**. It does not own what the system should
do, or whether it works - those belong to the BA and to QA, and the fastest way to lose a
project is for the person watching the budget to start answering those questions too.

Most of this skill is written for **client work**: a scope sold in days, changes priced as
change requests, a steering committee. For **a product of your own** the shapes hold with
different mechanics - team capacity instead of a sold budget, reprioritising instead of a change
request, internal stakeholders instead of a committee. Where a rule differs it says so; where it
says nothing it applies either way.

The job is mostly **arithmetic on other people's output**, done honestly and early:

```
BA's sized feature list   ──►  the plan, and the budget it implies
Dev's progress            ──►  what has actually been spent, and on what
QA's round numbers        ──►  whether "done" is done
CRs the BA has priced     ──►  the revised forecast
                          ──►  the steering report, and the decisions it asks for
```

## What does not bend

- **The forecast is recalculated from what happened, not from what was planned.** A plan that
  still shows the original date after three weeks of slippage is not a plan, it is a wish, and
  everyone on the project knows it before the customer does.
- **Bad news travels immediately.** A slip reported the week it becomes likely is a
  conversation. The same slip reported at the deadline is a failure of management, and it is
  remembered as one long after the technical reason is forgotten.
- **Never report a percentage you cannot decompose.** "70% complete" is a number nobody can
  check. Features accepted out of features agreed, and days spent out of days estimated, are
  numbers anybody can.
- **Effort spent is not progress.** Half the budget consumed and a third of the features
  accepted is a forecast, not a status update - and the forecast is the thing to report.
- **Scope only changes through a CR.** Absorbing "small" changes quietly is how a project
  arrives overspent with no record of where the time went. Doing one for free is a decision to
  make in the open; doing it invisibly is not.
- **The ship decision is yours, and it is recorded.** QA says whether it is proved. Shipping
  anyway is legitimate and sometimes right - but it is written down, with who decided, what is
  accepted, and what the plan is for the rest.

## Where to read next

| You are | Read |
| :-- | :-- |
| building or rebuilding the plan | `references/plan.md` |
| tracking spend, or forecasting the finish | `references/cost.md` |
| keeping the risk register worth reading | `references/risk.md` |
| preparing a steering report or a status note | `references/steering.md` |

`scripts/forecast.sh` does the arithmetic this role redoes by hand every week: spend against
estimate, what that implies for what is left, and where the tracking data contradicts itself.

## Shared with the other skills

Estimation itself belongs to the BA - what a feature costs is a judgement about the work, and it
is in the `delivery-ba` skill under `references/sizing.md`. This role owns the budget that
estimate implies, and the re-estimate when reality disagrees.

Change requests are priced by the BA and tracked here. Test rounds are run by QA and reported
here. The defect counting rule lives in `delivery-dev`; a steering report quotes it rather than
inventing its own.
