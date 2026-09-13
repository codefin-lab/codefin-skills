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

`templates/adr-template.md` has the shape.

## Where an ADR lives

Keep it where a pull request will pass over it, so it cannot go stale unnoticed. For a decision
inside one codebase that means `docs/adr/` in that repository, numbered in sequence.

Architecture decisions frequently are not inside one codebase, which is this role's particular
problem:

- **A decision spanning several repositories** goes in the one that owns the thing being decided
  - the service that publishes the interface, the repository that holds the shared library - and
  the others link to it. Copying it into each guarantees the copies diverge, and then nobody can
  tell which is current.
- **A decision that precedes any repository** - the platform shape, the integration approach -
  goes wherever the project's documents live for now, **with a note of where it will move**, and
  it moves when the repository exists. An ADR nobody can find is an ADR nobody wrote.
- **A decision about someone else's system** is not an ADR, it is an agreement. Record what was
  agreed and with whom, in a document both sides have seen
  (`references/integration.md`).

Number them per home, not globally. Two repositories both having an `ADR-0003` is fine and
expected; what is not fine is one number meaning two things in the same place.

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
