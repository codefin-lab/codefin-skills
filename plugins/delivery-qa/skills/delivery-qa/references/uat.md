# Taking the customer through UAT

UAT is not another round of testing. It is the customer satisfying themselves that what was
agreed was delivered - and it is the moment the whole chain gets checked in public. Everything
this skill and the BA skill do lands here.

*Your own product*: there is no UAT session, but the equivalent exists - releasing to a slice of
real users and watching what they actually do. The discipline below still applies to that:
nothing is seen first by users that the team has not already walked, and known defects are
stated before someone finds them.

## It is a rehearsal, not a discovery

**Nothing should be seen first at UAT.** Every scenario the customer will walk has been run and
passed by QA on the same build, on the same environment, with the same data. If UAT is where
defects are found, the round before it did not happen properly, and the customer learns that.

Before the session:

- the build is fixed and its version recorded; no deploys during UAT
- the walkthroughs have been run end to end by QA on that exact build
- data exists for every case the customer will try, including the awkward ones
- accounts exist for every role the customer will use, and someone has logged in with each
- known open defects are listed and shown to the customer **before** they find them

That last one matters more than it looks. A defect disclosed up front is a known limitation. The
same defect discovered by the customer is a surprise, and surprises cost trust at a rate nothing
else in the project matches.

## Walkthroughs

Organise by what the customer recognises - module, role, or a task they do - not by the
structure of the system. Each walkthrough is a sequence of steps in their vocabulary, with the
requirement behind each so a question can be answered from the document rather than from memory.

Split by role and have the right person walk their own part. An operations officer trying to
evaluate an approver's screen produces opinions, not acceptance.

`templates/uat-walkthrough.md` has the shape.

## Running the session

- **Let the customer drive.** Someone from the delivery team demonstrating produces a demo, not
  acceptance.
- **Record every finding as it happens**, in their words first. Reinterpreting later is how a
  finding turns into a dispute.
- **Classify on the spot, out loud**: is this a defect - the system contradicts the document - or
  a change - the document did not say this? Deciding it in the room, with the clause to hand, is
  far easier than deciding it by email a week later when positions have hardened.
- **Do not fix anything live.** It undermines the build under test and nobody can say afterwards
  what was actually accepted.
- **Do not argue about a CR in the session.** Log it, name it a CR, and take it to the BA
  process. The session is for finding things, not for negotiating them.

## Closing

At the end, send back the same day: what was walked, what passed, findings split into defects
and CRs with severities, what is being fixed and by when, and what is being held for a phase.

Acceptance is against the acceptance criteria, not against how somebody feels about the screen.
Where a criterion was met but the customer is unhappy, that is real and worth hearing - and it
is a CR, recorded as one. Both things are true at once, and saying both is what keeps the
relationship intact.
