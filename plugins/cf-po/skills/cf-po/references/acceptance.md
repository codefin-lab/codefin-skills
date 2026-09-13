# Accepting, and rejecting

Three different judgements get confused, constantly:

| | Who | Question |
| :-- | :-- | :-- |
| proved | QA | does it do what the acceptance criteria say |
| accepted | **you** | is what the criteria say what we actually wanted |
| shipped | PM | do we release it now, at this cost, with these known defects |

Something can be **proved and rejected**: it does exactly what was written, and what was written
was wrong. That is not a failure of QA or of Dev - it is a requirement that should have been
challenged earlier, and the lesson belongs upstream.

## Accept against the criteria, not against your mood

Read the acceptance criteria first, then look at the thing. Reversing that order produces
opinions about colour and wording, and misses the case that was never covered.

If it meets every criterion and you still do not want it, **say exactly that**: it meets the
criteria and here is what is wrong. That sentence is honest, it protects the people who built
what was asked for, and it turns the problem into a new requirement rather than an argument
about whether they did their job.

*Client work*: that new requirement is a change request. A criterion met but disliked is not a
defect, and treating it as one costs money nobody agreed to spend and trust that is harder to
recover.

## Look early, not at the end

The cheapest rejection happens before anyone builds anything: at the point the BA writes an
acceptance criterion you would not accept. Read them then. It costs a sentence.

The next cheapest is at the first demonstrable milestone. The most expensive is at UAT with the
customer in the room, which is also the one that damages confidence most.

## When you reject

Say which criterion, what you expected, and what you want instead. "It does not feel right" sends
a team guessing, and they will guess at the wrong thing and spend a week on it.

Then decide the consequence with the PM: does it block the release, is it a defect, is it a
change, does it wait. Rejecting without saying what happens next leaves the work in limbo, where
it quietly stays until somebody ships it anyway.
