# The steering report

A steering committee needs three things and has no use for the rest: **where the project stands
against what was agreed, what decisions are needed from them, and what is going wrong early
enough to act on.**

*Your own product*: the audience is internal and there is no contract to report against, but the
three things do not change - where it stands against what was planned, what needs deciding, and
what is going wrong. Drop the scope and budget sections; keep the forecast and the decisions.

Everything else - activity summaries, what the team did last fortnight, screenshots - makes the
report longer and its signal weaker.

## The numbers come from somewhere

Every figure in the report is produced by somebody else's work, and none of it should be
recalculated by hand into something more comfortable.

| Section | Source |
| :-- | :-- |
| Features accepted against agreed | the BA's feature list, counted as accepted only when QA proved it and the BA accepted it |
| Days spent against estimated, and the forecast | `scripts/forecast.sh` over the same list |
| Quality | the last test round's numbers: found, fixed, running tally, P0/P1/P2 open |
| Scope | the CR log: agreed, priced, and the effect on date and budget |
| Risk | the top few from the register, with owners and consequences |
| Decisions needed | one line each, with the option you recommend |

A report whose quality section is a sentence of prose instead of the round's actual counts is a
report that has stopped being evidence.

## Say the bad thing first

Put the forecast and the problems at the top. A report that opens with achievements and reaches
the slip on page four reads as concealment, whether or not it was - and once a steering
committee has that impression, every later report is read for what it is hiding.

The forecast line is one sentence: **at the current rate, this finishes on <date>, against a
plan of <date>, and here is what would change it.**

## Ask for decisions, do not narrate

A steering committee exists to decide things. Each item it needs to decide gets: what the
decision is, the options, what each costs in time and money, and **which one you recommend**.

Arriving with a problem and no recommendation moves your job onto their desk, and they will
notice. Arriving with three options and no recommendation is the same thing with more paperwork.

## Cadence, and the note in between

The formal report goes to its fixed cadence. Anything that changes the date or the budget does
not wait for it - it goes the day it becomes likely, in a short note.

**The steering report is never where a slip is first heard.** By the time it appears there it
should already be old news, and the report is the record rather than the announcement. That one
habit is most of what separates a project that is trusted from one that is merely watched.

`templates/steering-report.md` has the shape.
