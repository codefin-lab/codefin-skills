# Worked examples

One project, followed through every role. The outputs below are real runs against the sample
material in this repository, not illustrations.

The project: **a statement service** for a bank's customers. They want to see and download their
statements, and compliance needs to retrieve any statement from the last seven years.

---

## PO — deciding what is worth doing, and in what order

**The situation.** The customer has listed nine things they want. Everything is marked
high priority. The date cannot move.

**What you say**

> Here is the list from the customer. They have marked everything as a Must and we have twelve
> weeks. Help me order it.

**What happens.** The skill does not reorder the list for you - it asks the question that costs
something:

> If only three of these land in the first release, which three? Whatever survives that question
> is a Must; usually it is a third of what was labelled one.

It then pushes on two things people skip. **What is deliberately out**, written down as
carefully as what is in - because that section is what everyone reads at delivery, and anything
not in it is arguable. And **what is cheaper now than later**: the data model, anything a
migration touches, anything that becomes a breaking change once real customers exist.

**What you get.** An ordered list, an exclusions section, and `templates/scope-decision.md`
filled in - one row per thing deferred, with the reason, so it is not re-argued every fortnight
by somebody who assumes nobody thought of it.

---

## BA — turning that into something anyone can check

**The situation.** You have written the BRD. It is a `.docx`, and the customer already has a
copy.

**What you say**

> Check docs/BRD.docx before I send it to the team.

**What happens.** The mechanical pass runs first, against the copy the customer actually holds
rather than the markdown draft:

```
$ check-requirements.sh docs/BRD.docx

  4 requirement identifier(s)

  no acceptance criteria found near:
    US-1.3

  no objective link (OBJ-<n>) near:
    US-1.3

  OBJ-3 is cited but never defined

  words that hide a decision - ask the question each one is concealing:
    22:Acceptance: The PDF must be generated quickly and look correct.
```

Then the part the script cannot do. "Quickly" is not deleted - it is turned back into the
question it was hiding: *how long is too long, with what data, on which environment?* The answer
becomes the criterion. `US-1.3` has no acceptance criteria at all, so it goes back before anyone
estimates it.

**What you get.** Requirements QA can derive scenarios from, and a note that the amendment goes
into the source the `.docx` was built from, not into a draft nobody issued.

---

## SA — deciding what it is built out of

**The situation.** `US-2.1` says any statement from the last seven years must come back within
five seconds.

**What you say**

> The BRD says statements are retained seven years and retrievable in five seconds. What are we
> actually building?

**What happens.** The skill treats that as a requirement, not a design, and insists on four
things before it counts as answered: **a mechanism, its cost, what happens when it does not
hold, and how QA would tell.**

| Requirement | Mechanism | Cost | When it does not hold | How QA tells |
| :-- | :-- | :-- | :-- | :-- |
| retained 7 years, retrieved in 5s | recent 13 months in the primary store; older archived monthly to cold storage with an index kept hot | storage rising with volume; a quarterly restore exercise | an archived statement takes minutes, not seconds - stated to the customer now, not discovered at UAT | a seven-year-old statement is retrieved on SIT and timed, quarterly |

That fourth column is where the design changed: the honest mechanism does **not** meet five
seconds for old statements, and saying so while the scope is being agreed is a conversation. Not
saying so is a failure at the compliance review.

**What you get.** An ADR recording what was traded and why, and a row the PM can price.

---

## Dev — building it, and fixing what comes back

**The situation.** A customer reports that their statement total is wrong when there is a refund.

**What you say**

> Fix this: the statement total is too high for accounts with a refund on them.

**What happens.** The procedure runs without being asked for, in order, and it does not start
with the code.

1. **The record first** - what the customer did, what they saw, what they expected, on which
   build, and which `US` it violates. No record, no fix.
2. **Defect or change request** - the code contradicts `US-1.1`, so it is a defect.
3. **Reproduced as a failing test** before anything is edited:
   ```
   --- FAIL: TestTotalWithRefund
       statement_test.go:64: total: got 700, want 300
   ```
4. **The cause in one sentence** - the total sums absolute values, so a refund adds instead of
   subtracting.
5. **The blast radius, before the edit**, not after:
   ```
   $ blast-radius.sh abs -C . -o my-org
   -- this repository --   2 matching lines
   -- sibling clones --    nothing
   ```
6. **Fixed at the cause**, once.
7. **The reproduction becomes permanent**, named `DEF-902 (US-1.1)`.
8. **The gates run by themselves** - and the fix is not reported as done until they have:
   ```
   lint  ok      test  ok (100% of statements)      build ok
   ```

**What you get.** A closing note the BA can send to the customer unedited: the cause, what
changed, what else was checked, the test that now guards it, and where it was verified.

---

## QA — proving it

**The situation.** Round 3 is about to start on build 1.4.2.

**What you say**

> Plan the next test round.

**What happens.** Entry criteria are checked and **held** - starting on a build that will not
survive the first hour wastes the round and produces defect counts nobody can compare. Then the
chain is checked before any testing begins:

```
$ trace-gaps.sh --register register.xlsx --requirements docs/BRD.docx --suite tests/

  scenarios citing no requirement (1)
    TS-905
  requirements with no scenario (1)
    US-1.3                      <- nobody is proving this
  scenarios in the register with no automation (3)
    TS-903  TS-904  TS-905
  automation citing a scenario the register does not hold (1)
    TS-950                      <- the register is the source; this is out of step
```

`US-1.3` having no scenario goes to the BA **now**, not at the end. Selection is by risk, and
what is **excluded** is written down - that list is the honest statement of what this round does
not tell anybody.

**What you get.** A round report with the numbers that matter: scenarios run, passed, blocked;
defects found and fixed; the running tally across rounds; and P0, P1 and P2 still open. The
falling rate across rounds is what says the loop can stop.

---

## PM — when, at what cost, and what gets cut

**The situation.** The steering meeting is on Thursday. The team feels behind but nobody has
said by how much.

**What you say**

> Prepare the steering report. The feature list is features.xlsx and the team runs five days a
> week.

**What happens.** The forecast is recomputed from what happened, and it is not flattered:

```
$ forecast.sh features.xlsx --rate 5

  features      2 accepted of 6 agreed
  days          37 spent of 49 estimated

  observed rate 1.43x  (20 days spent on work estimated at 14)
  in progress   17 days already spent on work not yet accepted
  remaining     35 estimated days, 50.0 at the observed rate
  forecast      70.0 days against an estimate of 49  (+21.0, 143%)
  at 5 days a week, 6.6 weeks remain

  tracking data that contradicts itself (1):
    Audit log     1 days spent but status is 'blank'
```

Then it refuses the comfortable move:

> Forecasting the rest at 1.0 because the hard part is behind you is how a final overrun arrives
> as a surprise. If you believe the rate will improve, say why, and say what would show it -
> then check that next week.

**What you get.** A report that leads with the forecast and the problems rather than with
achievements, quotes QA's actual round numbers instead of a sentence of prose, and asks for each
decision with the option you recommend. And the rule that matters most: **the steering report is
never where a slip is first heard.** By the time it appears there it should already be old news.

---

## What the chain bought

One identifier travelled the whole way. `US-1.1` was written by the BA, proved by `TS-901`,
violated by `DEF-902`, and guarded by a regression test that names both. When the total was
wrong, nobody had to reconstruct what the system was supposed to do - it was written down, and
the test that should have caught it could be found.

That is the whole point. Everything else is in service of it.
