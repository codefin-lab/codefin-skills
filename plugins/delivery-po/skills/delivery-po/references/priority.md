# Order

Prioritising is deciding what **loses**. A list where nothing loses has not been prioritised; it
has been collected.

## MoSCoW that means something

Must, Should, Could, Won't is only useful under one condition: **Must means the release is
worthless without it.** Not important, not promised, not requested loudly - worthless.

Force the question this way: *if the date could not move, what would you ship without?* Whatever
survives that question is a Must. Usually it is a third of what was labelled Must, and finding
that out in planning is far cheaper than finding it out in the last week.

Won't is a real answer and belongs on the list. Absent, it gets re-proposed every cycle by
somebody who assumes nobody thought of it.

## Order by value against cost, not by either alone

The cheap thing nobody wants is not a good first item, and the enormously valuable thing that
takes six months is not either. Ask the BA and the PM for a rough size - rough is enough - and
order by what it buys against what it costs.

Two things jump the queue regardless:

- **Anything that stops you learning.** A dependency, a decision, an integration nobody has
  tried. Not valuable in itself, but everything behind it is guesswork until it is done.
- **Anything that is cheaper now than later.** Data model choices, anything migration touches,
  anything that becomes a breaking change once real users exist.

## When everything is urgent

It never is. When told everything is urgent, ask the question that costs something: *if only
three of these land this quarter, which three?* People who will not rank in the abstract rank
easily when the constraint is real.

If the answer is still everything, the decision has been made by whoever picks up work first,
and the outcome is worse than any order you would have chosen. Say that out loud.

## Reordering is normal; pretending you did not is not

Priorities change because the world does. Reorder, and **say what moved and why** - a backlog
that quietly reshuffles is one nobody plans around, and then everyone builds their own private
version of the plan.

*Client work*: the order is largely fixed by the agreed scope, and changing it is a
conversation, sometimes a change request. What you still control is **sequence within the
scope** - which is most of the value of prioritising anyway, since it decides when risk gets
discovered and when the customer first sees something real.
