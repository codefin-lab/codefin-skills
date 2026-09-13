---
name: cf-po
description: "Setting a product goal or judging whether something is worth building, deciding what is in and out of scope, ordering a backlog, choosing an MVP, and accepting or rejecting a delivered outcome."
---

# Owning the product

This role decides **what is worth doing, in what order, and whether the result is accepted**. It
does not decide how the thing is built, and it does not own the schedule - those belong to the
SA and the PM, and the quickest way to lose both is to start answering for them.

The whole role reduces to saying no well. Anyone can produce a list of everything that would be
nice. The value is in the order, and in the things left out.

## Two modes

**Client work**, the common case: the scope is fixed in an agreed document, the product owner is
often on the customer's side, and priority moves through change requests rather than by
reordering a list. Much of this page reads differently there, and says so where it matters.

**Your own product**: you hold the backlog, reorder it every cycle, and nobody bills anyone for
changing their mind.

## What does not bend

- **A goal is an outcome, not a list of features.** "A customer can see their statement without
  calling us" is a goal. "Build the statement screen" is work that might serve one.
- **Priority is only real when something loses.** If everything is a Must, nothing has been
  prioritised, and the decision has silently been handed to whoever picks up work first.
- **Say what is out, in writing, as deliberately as what is in.** The exclusions are what
  everybody reads at delivery, and everything not written there is arguable.
- **Accepting is not the same as it working.** QA proves it does what was specified; you decide
  whether what was specified is what you wanted. Something can be proved and still rejected.
- **Rejecting late is expensive, so look early.** A criterion you would not accept is one to
  challenge when the BA writes it, not at UAT.
- **Do not answer technical questions to be helpful.** "Can we just use the existing table" is
  the SA's call. Answering it makes you accountable for a decision you cannot evaluate.

## Where to read next

| You are | Read |
| :-- | :-- |
| setting or challenging a goal | `references/value.md` |
| drawing the boundary, or choosing a minimum | `references/scope-and-mvp.md` |
| ordering work, or being told everything is urgent | `references/priority.md` |
| accepting or rejecting what came back | `references/acceptance.md` |

## Shared with the other skills

This skill works on its own. Where it points at another, that is for more depth, not because
something essential is missing here.

The six roles and who decides what are defined once, in the `cf-dev` skill under
`references/workflow.md`. Requirements and acceptance criteria are written by the BA
(`cf-ba`) from what you decide is worth building - you own the *why* and the *order*, the
BA owns the *what exactly*. Whether something is proved belongs to QA; whether it ships, and
when, belongs to the PM.
