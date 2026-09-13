# Choosing a shape, and recording why

## Decide late, record immediately

The two instincts pull apart and both are right. Deciding early feels responsible and produces
an architecture built around a guess at the requirements. Deciding late feels risky and is
usually cheaper - as long as the decision is written down the moment it is made, rather than
discovered later by reading the code.

The decisions worth taking early are the ones that are **expensive to reverse**: the data model,
anything a migration touches, anything published that others will depend on, and the boundary
between things that might be deployed separately. Everything else can wait for evidence.

## What gets an ADR

Not every choice. An ADR is warranted when:

- reversing it later would be expensive
- a competent person could reasonably have chosen otherwise
- it constrains what other people may do afterwards
- it was made against the obvious option, for a reason that will not be obvious later

The test in practice: **would somebody new ask "why on earth is it like this?"** If yes, answer
them now, in a page, rather than in a meeting every six months.

`templates/adr-template.md` has the shape. Keep them in the repository - `docs/adr/` - so a pull
request can catch one going stale, which is the reasoning in `delivery-dev`,
`references/knowledge.md`.

## Name the trade

Every architectural decision costs something. A decision recorded with only its benefits has not
been recorded, it has been advertised - and it will be reversed by the next person, who sees
only the costs and assumes nobody considered them.

Write the cost in the same voice as the benefit: this gets us X, at the price of Y, and Y is
acceptable because Z. If you cannot name Y, you have not finished thinking about it.

## Prefer the boring thing

Every novel component is a cost paid by everyone who operates and maintains it, usually after
the person who chose it has moved on. The budget for novelty is small; spend it on the part of
the problem that is genuinely new, and use dull, well-understood tools for everything else.

Signals you are spending it badly: the technology is more interesting than the problem, the
justification is about future scale nobody has forecast, or the main benefit is that the team
would like to learn it. That last one is a real benefit - it is just not one to pay for with a
customer's project.

## Fit the shape to the team

An architecture that needs more operational attention than the team has is not a good
architecture, however elegant. Count the people who will run it at three in the morning, and the
ones who will still be here in two years.

*Client work*: add the ones who will run it **after handover**, who may not be your team at all.
A design that only its authors can operate is a design that fails quietly six months after you
leave, and it fails with your name on it.
