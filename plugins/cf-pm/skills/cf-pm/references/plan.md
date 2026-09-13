# The plan

A plan exists to answer two questions the customer will ask every fortnight: **when will it be
done, and is that still true?** Everything else in it is supporting material.

## Build it from the sized feature list

The BA's feature list already carries the work and its estimate. The plan is that list arranged
in time, not a new document invented alongside it. Where the two disagree, one of them is wrong,
and letting them drift apart means nobody can tell which.

Each item keeps the estimate it was sized at. When you disagree with an estimate, say so to the
BA and change it there - silently padding it in the plan hides the disagreement and destroys the
only baseline you had.

## Milestones are things you can show

A milestone is a point where somebody outside the team can see something and say whether it is
right. "Sprint 3 complete" and "backend done" are not milestones; they are dates with labels.
"A customer can view and download a statement on SIT" is one.

This matters for more than tidiness: a milestone nobody can inspect cannot slip visibly, so it
slips invisibly, and the first visible slip is the last one.

Three to six milestones for a project of a few months. More than that and each one stops meaning
anything.

## Sequence by risk, not by comfort

Do the frightening thing early. The integration nobody has tested, the dependency on the
customer's other vendor, the requirement whose acceptance criteria took three rounds to settle -
these decide whether the date holds, and every week they are deferred is a week the project
learns nothing about its real risk.

Filling the early weeks with work that is easy to estimate produces a project that looks ahead
of schedule until the moment it is catastrophically behind.

## Dependencies you do not control

List them separately and name the owner outside the team: the customer's test data, an access
provisioned by their IT, a third party's sandbox, a sign-off from someone who is on leave.

Each one gets a date by which it is needed and **what happens if it is late**. This is the same
discipline as an assumption in the BRD, and for the same reason: a dependency with no stated
consequence is a surprise waiting to be somebody's fault.

## Replanning is normal; hiding it is not

Replan when an estimate proves wrong, a CR lands, or a dependency slips - not on a schedule.

Keep the original baseline. A plan that has quietly moved three times looks fine and tells you
nothing; a plan showing the baseline, the current forecast and the reason for each change is the
whole story on one page, and it is what makes the next estimate credible.

`references/cost.md` covers the arithmetic; this page is only about the shape.
