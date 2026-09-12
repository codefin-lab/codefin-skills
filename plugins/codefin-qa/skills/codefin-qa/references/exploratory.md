# Testing without a script

Scripted cases prove what was thought of. Most of what goes wrong was not thought of, which is
why a couple of focused unscripted hours per round usually finds defects the whole register
missed.

This is not "clicking around". It is time-boxed, aimed, and it leaves a record.

## A charter

Before starting, write one sentence of intent:

> Explore **withdrawal approval** with **an officer at their limit boundary** to discover
> **what happens when approval and cancellation race each other**.

Target, resources, and what you hope to learn. A charter that says "explore the system" produces
nothing you can act on.

Good charters aim at the seams:

- boundaries between features, where two things that work alone meet
- anything with timing in it - concurrent users, retries, sessions expiring mid-action
- the back button, the refresh, the second tab, the direct URL
- what happens after an error: is the data consistent, can the user recover
- roles and permissions, especially a role doing something *almost* allowed
- data that is large, empty, old, duplicated, or has unusual characters in it

## Time-box it

60 to 90 minutes. Long enough to get somewhere, short enough to stay sharp and to stop and
write up. Two charters a day is a reasonable pace.

## Take notes as you go

Not a formal script - a running log of what you did, what you saw, what surprised you, and
questions raised. A surprise that is not written down is lost within the hour, and surprises are
the product of this activity.

`templates/exploratory-charter.md` has the shape.

## Afterwards, convert

This is the step that makes exploratory testing compound rather than repeat:

- **A defect found becomes a defect report**, properly written.
- **The path that found it becomes a scenario in the register**, so it is covered from now on
  without anyone having to rediscover it.
- **A question raised goes to the BA** - often what you found is not a defect but a case the
  acceptance criteria never covered, which is a CR or a gap, and finding it now is cheap.
- **A charter that found nothing is still worth recording.** It says that area was looked at,
  which is information the next round can use.

Exploratory findings that never become scenarios mean the same defect can return and nobody
notices. Convert, every time.
