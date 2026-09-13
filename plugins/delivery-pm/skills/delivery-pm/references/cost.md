# The money

Cost control on a fixed-scope project is one question asked continuously: **at the rate we are
actually going, what will this have cost when it is finished?**

Not how much has been spent. That is bookkeeping, and it is always reassuring.

## The only two numbers that matter together

- **Days spent** against days estimated
- **Features accepted** against features agreed

Either alone is misleading, and both are routinely reported alone. Half the budget with a third
of the features accepted is not "on track, slightly over" - it is a forecast of finishing at one
and a half times the estimate, and that is the sentence to say out loud in week five rather than
week fifteen.

`scripts/forecast.sh` does this arithmetic from the feature list so nobody has to redo it weekly
and nobody gets to round it kindly.

## Accepted, not "done"

Count a feature when QA has proved it and the BA has accepted it against the acceptance
criteria. Not when the developer says it works, not when it is merged, not when it is "done
except for testing".

Work counted at "done except for testing" is why projects sit at 90% for a third of their
duration. The remaining work is real, it is usually the unhappy paths, and it was never
estimated as generously as the happy path was.

## What eats a budget, in order

1. **Work nobody estimated** - migration, environments, test data, UAT support, fixing what
   testing finds. If the estimate covered only building the features, the estimate was for a
   third of the project.
2. **Scope absorbed without a CR** - each one small, all of them invisible, together the
   difference between profit and loss.
3. **Rework from a requirement that was never testable** - which is why the BA's acceptance
   criteria discipline is a cost control, not a documentation preference.
4. **Waiting** - for an environment, a decision, a dependency. It is the cheapest to prevent and
   the least often recorded, because nobody bills it to anything.

Track the first two explicitly. They will not appear on their own.

## Change requests are both directions

A CR is revenue and it is schedule. The second half gets forgotten, and then the project is
inexplicably late while the invoices look healthy.

Keep a CR log: raised, priced, agreed, delivered, with the days and the schedule effect of each.
The steering report shows the original budget, the CRs agreed, and the revised total - because a
customer who agreed to eight CRs and remembers the original number will feel misled by a figure
they themselves approved.

## Forecasting honestly

At any point: **days remaining = work remaining, estimated at the rate actually observed** -
not at the rate hoped for.

If the team has been running at 1.4 times its estimates, the remaining work will take 1.4 times
its estimate. Forecasting the rest at 1.0 because "the hard part is behind us" is the single
most common way a project's final overrun arrives as a surprise.

Where you genuinely believe the rate will improve, say why, and say what would show it is
happening. Then check that in the next report.
