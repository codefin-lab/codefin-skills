# Feature lists and rough sizing

An estimate is a forecast under stated assumptions, not a promise. Write it so that when it
turns out to be wrong, anyone can see which assumption failed.

**This is the rough number, and rough is the point.** It exists to price the work and to let the
PO order it, and it is made before anyone has designed anything. The detailed estimate comes
from Dev once the work is broken down (`cf-dev`, `references/breakdown.md`), and the PM
coordinates the two and owns the budget (`cf-pm`).

When the detailed estimate disagrees with the rough one, the detailed one is better informed -
say so, change the number, and say what the rough estimate missed. Defending the first figure
because it was quoted is how a project commits to something nobody believes.

## The feature list

One row per feature, and for each one: what it includes, what it explicitly excludes, the
component it belongs to, the effort, and whether it is in scope, optional, or out. The list is
the bridge between the requirements and the price, and it is also where most misunderstandings
about scope get caught - because a customer reads a feature list more carefully than a narrative.

Mark each row with where it came from: the question, the answer, or the requirement id. Rows
with no origin are usually someone's assumption, and they are worth challenging before they are
priced.

## Man-days are internal

**The customer-facing document shows price by component. It does not show man-days.**

The working document that carries the man-day figures is internal and is not sent. This is not
about hiding anything: a day rate multiplied out invites a negotiation about the number of days
rather than the value of the outcome, and the day count is an estimate while the price is a
commitment. Keep them in separate documents so the wrong one cannot be sent by accident.

Every price states that it excludes VAT.

## Estimating without fooling yourself

- **Size the unhappy paths.** The success case is usually a third of the work. A feature
  estimated from its happy path alone is the single most common cause of an overrun.
- **Count the work that is not coding**: analysis, test design and execution, fixing what testing
  finds, environments, migration, UAT support, documents, deployment, handover.
- **Estimate a range, then decide what you are quoting.** If a feature is 5 to 15 days, the
  spread is telling you something is unknown - name the unknown. Quoting the midpoint without
  saying why the range was wide converts a known risk into an invisible one.
- **Do not estimate what you have not defined.** A feature with no acceptance criteria cannot be
  sized honestly; either define it or price it as a to-be-confirmed item with a stated basis.
- **Compare against something you actually did.** A feature list with no reference to a
  comparable delivered feature is arithmetic, not estimation.

## Say what the estimate assumes

Attach the assumptions to the number, not to the back of the document: which environments exist,
who provides test data, the customer's review turnaround, how many rounds of UAT are included,
which integrations are ready. Each of these has ended a project's schedule at some point, and
each is outside our control - which is exactly why it belongs next to the figure it affects.

## Where this hands over

| | Who |
| :-- | :-- |
| rough size, for pricing and ordering | BA - here |
| technical breakdown and the detailed estimate | Dev (`cf-dev`, `references/breakdown.md`) |
| coordinating the two, and the budget either implies | PM (`cf-pm`) |
| deciding what is worth its cost | PO (`cf-po`) |

Disagreement about an estimate is settled openly, not silently padded in the plan - padding
hides the disagreement and destroys the only baseline anyone had.

## Re-estimating is not failure

When scope changes or an assumption fails, re-estimate and say so at the time. An estimate
quietly held while everyone knows it is wrong helps nobody, and it destroys the credibility of
the next one.
