---
description: Work a requirements document to the point where it can be built and proved - check what is mechanical, then ask about what is not.
argument-hint: [path to the BRD or FSD, or the area to work on]
---

Take a requirements document from wherever it is to the point where Dev can build from it and QA
can prove it. Read `references/acceptance-criteria.md` and `references/requirements.md` in the
`codefin-ba` skill and work to those.

Target: **$ARGUMENTS**

## Start with the mechanical pass

```bash
bash <skill>/scripts/check-requirements.sh <path to the document>
```

It finds requirements with no acceptance criteria, criteria carrying words that hide a decision,
requirements with no objective link, duplicate identifiers, and objectives cited but never
defined. Report what it found plainly, then fix what can be fixed without the customer.

**It clears noise; it does not do the analysis.** What it cannot see is the whole of the next
part.

## Then the part that needs judgement

Go requirement by requirement. For each one, in this order:

1. **Is the story readable on its own?** Who, what, and *so that* - the reason is the part people
   skip and the part that lets Dev and QA make a sensible call when the description turns out to
   be incomplete.
2. **Is every acceptance criterion checkable?** State what is set up, what happens, and what is
   then true, with nothing left to opinion. A number needs its anchor: with what data, on which
   environment, measured from what to what.
3. **Were the unhappy paths asked about?** Empty, invalid, not permitted, conflict, unavailable,
   partial. You do not need a criterion for each - you need to have asked, and an explicit "out
   of scope this phase" is a good answer where silence is not.
4. **Is it linked to an objective?** A story with no reason to exist is either missing its reason
   or does not belong in this release.
5. **Would QA get a scenario out of this?** If you cannot imagine the `TS-<n>` that would prove
   it, it is not finished.

## Ask rather than invent

Where the document is silent, **do not fill the gap with a plausible answer** - that is how an
assumption becomes a commitment nobody agreed to. Collect the gaps as numbered questions using
`templates/question-set.md`, and say which ones block the work and which can run in parallel.

Where a decision has been made but not recorded, record it with its source.

## Watch the scope line

If the work turns out to need something outside what was agreed, that is a CR, not a quiet
addition - `references/scope-and-change.md`, and `templates/change-request.md`. Say so at the
moment you notice, not at delivery.

## Finish by saying where it stands

- what was fixed
- what is still open, as numbered questions with owners
- which requirements are ready for Dev and QA, and which are not, and why

Never report a document as ready while questions that change the build are still open.
