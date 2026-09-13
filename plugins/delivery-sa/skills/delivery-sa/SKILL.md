---
name: delivery-sa
description: "Choosing the shape a system is built in, designing components, APIs and data, working out how a non-functional requirement will actually be met, integrating with another system, security decisions, and recording a technical trade-off."
---

# Solution architecture

This role decides **what the thing is built out of, and what is traded against what**. It does
not decide what is worth building or in what order - that is the PO's - and it does not decide
what the system must do, which is the BA's.

Its output is mostly **decisions and the reasons behind them**. A diagram with no reasoning is a
picture; the reasoning is what lets the next person tell whether the decision still holds.

This skill reads the same whether the work is for a customer or for a product of your own.
Architecture does not care who is paying.

## What does not bend

- **Decide as late as you responsibly can, and write it down when you do.** An architecture
  fixed before the requirements are understood is a guess that everything else then has to work
  around.
- **Every decision that closes off an option leaves an ADR.** Not every choice - the ones that
  would be expensive to reverse, and the ones where a reasonable person would have chosen
  differently.
- **Name what you traded.** A decision presented with only its benefits has not been explained,
  and it will be reversed by the next person who only sees its costs.
- **A non-functional requirement is not met by intending to meet it.** "Highly available" is the
  BA's requirement; which mechanism, at what cost, with what failure behaviour, is yours, and it
  is testable or it is not real.
- **Anything you publish is a contract.** A schema, an API, a shared library's surface, an event
  - the moment something else depends on it, changing it is somebody else's incident.
  `delivery-dev` has the procedure for finding out who.
- **Build the risky part first.** Until a real call has been made to a real endpoint, an
  integration estimate is fiction, and so is the plan that rests on it.
- **Prefer the boring thing.** Novelty is a cost paid by everyone who maintains it, usually
  after the person who chose it has moved on. Spend it where the problem is genuinely new.

## Where to read next

| You are | Read |
| :-- | :-- |
| choosing a shape, or recording why | `references/architecture.md` |
| designing an API, a schema or a data model | `references/interfaces.md` |
| turning a non-functional requirement into something real | `references/nfr.md` |
| connecting to a system you do not control | `references/integration.md` |
| making a security decision | `references/security.md` |

`templates/adr-template.md` is the record. `templates/nfr-table.md` turns a set of requirements
into a set of mechanisms with owners.

## Shared with the other skills

The six roles and who decides what are defined once, in the `delivery-dev` skill under
`references/workflow.md`. Requirements including non-functional ones come from the BA
(`delivery-ba`) - they say what must be true, you say how. Where knowledge lives, and the rule
that ADRs sit in the repository so a pull request can catch them going stale, is in
`delivery-dev` under `references/knowledge.md`.
