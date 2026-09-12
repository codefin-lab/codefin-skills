---
name: codefin-ba
description: "Business analysis at Codefin. Use when eliciting requirements from a customer, writing or amending a BRD or FSD, writing acceptance criteria, deciding what is in and out of scope, sizing a feature list, assessing or pricing a change request, or judging whether a customer request is a defect or a CR."
---

# Business analysis at Codefin

The BRD is what the customer signed up to. Some clients call the same document an FSD; the name
changes nothing. Everything downstream hangs off it - QA derives scenarios from its acceptance
criteria, developers build against it, and a customer complaint is judged against it. So the
quality of the analysis sets the ceiling on everything after it.

At Codefin the BA is also the product owner. One person holds both what was agreed and what it
is worth, which removes a seam and puts all the more weight on getting the document right.

## What this skill is not

It does not decide how the document **looks**. Layout, templates, cover, version control tables
and house wording belong to whichever skill owns the document house style. This one is about
what goes in it and how you arrive at that.

## Three rules that do not bend

**Nothing goes in the document that you could not check.** If you cannot say how anyone would
tell whether it happened, it is a wish, not a requirement. `references/acceptance-criteria.md`
is the test.

**Anything not written in the scope section is out of scope, and a change to it is a CR.**
This is not bureaucracy; it is the only thing that makes "we agreed to this" mean anything. It
is also the line that decides whether a customer's complaint is a defect or a change request:

> the code contradicting the document is a **defect**.
> the document being wrong, silent, or never covering the case is a **CR**.

**The document is amended before the work changes, never after.** A document updated afterwards
is a document never updated, and once it is stale nobody trusts it and everyone is back to their
own understanding of what was promised.

## Two numbers, and where they go

The BA numbers what was agreed. QA numbers how it gets proved. Each carries the other, so a
failure anywhere can be traced back to a promise.

```
BR-<n>              a business requirement
US-<epic>.<n>       a user story under an epic, with acceptance criteria and an OBJ link
  └─ TS-<n>         the scenario QA derives to prove it
```

A requirement with no scenario has nobody proving it. A scenario citing no requirement is
testing something nobody asked for. Both are findings, and `scripts/check-requirements.sh`
reports the first of them.

## Where to read next

| You are | Read |
| :-- | :-- |
| about to meet or question the customer | `references/elicitation.md` |
| writing acceptance criteria | `references/acceptance-criteria.md` |
| structuring requirements, epics and identifiers | `references/requirements.md` |
| drawing the scope line, or handling a change request | `references/scope-and-change.md` |
| building a feature list or sizing the work | `references/sizing.md` |
| deciding what to model, and how | `references/modelling.md` |

`templates/` holds forms to fill rather than retype. `scripts/check-requirements.sh` reads a
requirements document and reports what is missing before a reviewer has to find it.

## Handing over

What the BA owes Dev and QA before work starts, and what comes back, is one short checklist in
the `codefin-dev` skill (`references/workflow.md`). Read it from the BA's side: an acceptance
criterion that cannot be tested is sent back at that point, and sending it back costs a sentence
now against a reopened ticket later.
