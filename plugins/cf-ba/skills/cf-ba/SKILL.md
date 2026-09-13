---
name: cf-ba
description: "Eliciting requirements, writing or amending a BRD or FSD, writing acceptance criteria, drawing the scope line, sizing a feature list, or judging whether a customer request is a defect or a change request."
---

# Business analysis

The BRD is what the customer signed up to. Some clients call the same document an FSD; the name
changes nothing. Everything downstream hangs off it - QA derives scenarios from its acceptance
criteria, developers build against it, and a customer complaint is judged against it. So the
quality of the analysis sets the ceiling on everything after it.

The BA owns **what exactly is needed** - the rules, the cases, the criteria. Not whether it is
worth building or in what order, which belong to the PO (`cf-po`), and not what it is
built out of, which belongs to the SA (`cf-sa`). One person often wears more than one of
these hats; that is a staffing arrangement, not a merging of the jobs. The roles are defined
once, in the `cf-dev` skill under `references/workflow.md`.

## Two modes

**Client work**, the common case: the BRD is a contract, changes to it are priced as change
requests, and it is the document a dispute is settled against. Most of this skill is written for
that.

**Your own product**: the same analysis, recorded as backlog items rather than as a contract.
Nothing is priced and nobody argues about scope in writing - but a requirement still needs its
rules, its edge cases and its criteria, or QA has nothing to test against.

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
| building a feature list or sizing the work roughly | `references/sizing.md` |
| deciding what to model, and how | `references/modelling.md` |

`templates/` holds forms to fill rather than retype. `scripts/check-requirements.sh` reads a
requirements document - markdown, `.docx`, PDF, spreadsheet, whichever form it reached you in -
and reports what is missing before a reviewer has to find it. Point it at the copy the customer
actually holds, not only at the draft.

## Handing over

What the BA owes Dev and QA before work starts, and what comes back, is one short checklist in
the `cf-dev` skill (`references/workflow.md`). Read it from the BA's side: an acceptance
criterion that cannot be tested is sent back at that point, and sending it back costs a sentence
now against a reopened ticket later.
