---
description: Prepare a steering report - recompute the forecast from what happened, gather the numbers from the people who produced them, and ask for the decisions that are needed.
argument-hint: [project, period, or path to the feature list]
---

Prepare the steering report. Read `references/steering.md` and `references/cost.md` in the
`cf-pm` skill and work to them.

Subject: **$ARGUMENTS**

## Recompute before you write anything

```bash
bash <skill>/scripts/forecast.sh <feature list> --rate <days per week>
```

Use the number it gives you, including when it is uncomfortable. **Do not forecast the remaining
work at the original rate because the hard part is believed to be behind you** — that belief is
how a final overrun arrives as a surprise, and it is checkable: if you claim the rate will
improve, say what would show it, and check that claim in the next report.

If the script reports tracking data that contradicts itself, fix the data before reporting from
it. A forecast from broken numbers is worse than no forecast.

## Gather rather than compose

Every figure comes from somebody else's work, and none of it is recalculated by hand into
something kinder:

- **features accepted** — the BA's list, counted only where QA proved it and the BA accepted it
- **quality** — the last round's actual counts, including the running tally and what is still
  open by severity. Not a sentence of prose.
- **scope** — the CR log, with the effect of each on date and budget
- **risk** — the top few from the register, with owners and consequences in days

Where a number is not available, say it is not available. Do not estimate it into the table.

## Lead with the forecast and the problems

Put them first. A report that opens with achievements and reaches the slip on page four reads as
concealment whether or not it was — and after that, every later report gets read for what it is
hiding.

## Ask for decisions, with a recommendation

Each decision the committee must make gets the options, what each costs in time and money, and
**which one you recommend**. Arriving with a problem and no recommendation moves the work onto
their desk.

## Before sending

- [ ] nothing here is news — anything affecting date or budget was sent when it became likely
- [ ] the forecast is the script's number, not a rounded one
- [ ] every quality figure traces to a round
- [ ] every decision has a recommendation
- [ ] the revised budget shows the original and the CRs agreed, so no approved number surprises
      the person who approved it

Fill `templates/steering-report.md`. If the report has become long, it has probably started
narrating activity — cut that first.
