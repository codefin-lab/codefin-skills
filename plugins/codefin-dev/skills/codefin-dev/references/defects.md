# Investigating and repairing a defect

Customers reopen Codefin defects often enough to have cost real confidence. The two causes named
by the team are that a fix does not cover everywhere it needed to, and that nothing stops the
bug coming back. Both are addressed below, at steps 5 and 8.

Work the steps in order. Each one leaves evidence behind, because at reopen time the difference
between "we checked and found nothing" and "we never checked" is the whole argument.

## 1. Turn the report into one record, whatever door it came through

Defects arrive through the customer's Jira, email, LINE, a meeting, a phone call. The first act
is always to write one record in one shape:

- what the customer did, step by step
- what they saw
- what they expected to see
- the environment and the version or build it happened on
- **which `US-<epic>.<n>` it violates**, quoted from the BRD or FSD

`templates/defect-record.md` is the form. **No record, no fix.** If a field cannot be filled,
that is the first thing to go and ask about, and it is cheaper to ask now than after a wrong fix
has shipped.

## 2. Decide whether this is a defect or a change request

> It is a **defect** only when the code contradicts the document.
> If the document is wrong, silent, or never covered this case, it is a **CR**.

A CR stops here and goes to the document first, through the document house style, and comes back as
work once the document says what the system should do. Making this call at the start, in
writing, prevents the argument that otherwise surfaces at delivery and reopens the ticket.

## 3. Reproduce it before you touch anything

Write the failing case as a test, on the environment the customer reported. Not a manual click
through, a test - because in step 8 this exact test becomes the guard.

If it will not reproduce, go back to step 1 and ask. Do not guess and fix. A fix for a bug you
never saw is how a ticket gets closed twice.

## 4. Find the cause, not the place

The line that throws is rarely the line that is wrong. Follow it back until you can write the
cause as **one plain sentence**. If you cannot write that sentence, you have not found it yet,
and any fix at this point is a guess dressed up as a patch.

## 5. Work out the blast radius before you change anything

This is the step that answers "the fix did not cover everything", and it is the one most often
skipped. The failure is technical rather than careless: a change is made, something elsewhere
depends on it, and nobody knows until the customer finds out.

So before editing, ask what depends on the thing you are about to change.

| What you are changing | Who feels it |
| :-- | :-- |
| a shared library or module | every project that imports it, including ones in other repositories |
| a contract with the outside (API schema, protocol, public interface) | every caller, including callers you do not own |
| a data shape (table, column, file format, migration) | everything that reads or writes it - reports and batch jobs especially |
| a message or event between systems | every consumer |
| a design-system component or token | every screen that uses it |
| an internal function or interface | all callers, and every other implementation of the same interface |

How to actually look - `scripts/blast-radius.sh` does the tedious half:

```bash
bash <skill>/scripts/blast-radius.sh <symbol> -C /path/to/repo -o <github-org>
```

It searches this repository, sibling clones on the machine, and - with `-o` - a GitHub org,
grouping hits per repository. Run it for each thing you are about to change. Then:

- **Use the language server's find-references, not only a grep for the name.** Grep misses indirect
  calls and interface implementations, and drowns you in unrelated matches.
- **When the thing is shared, search across repositories, not just this one.** A name that only
  appears twice here may appear thirty times across the org.
- Ask whether the change is breaking. If it is, it takes `!` in the commit type and a major
  version bump, and every dependent has to be listed.
- Check the tests that already exist for the thing you are touching; they encode expectations
  someone had.

**Read the results for copies, not just uses.** A vendored or pasted duplicate of the thing you
are fixing will not receive the fix, and is a common source of a defect that comes back. The
script flags this because it is common: a helper that lives in a shared library also sitting
copied inside one consumer, or a UI component defined separately in each app that uses it.

**Write the result into the record even when nothing is affected.** "Checked the four consumers,
none pass this field" is evidence. Silence is not.

Two things follow from this step. It decides how wide the fix has to be - and it decides which
test layers must run in step 9, because **unit tests catch none of the failures in that table.**
What catches them is contract checking and integration tests.

## 6. Look sideways for the same mistake

Step 5 looks forward, at who depends on what you are changing. This step looks sideways: is the
same cause written somewhere else? A misread specification or a copy-pasted helper usually is.
Fix the ones you find, or list them as their own records if they are out of scope for this fix -
but do not leave them unrecorded.

## 7. Fix the cause, with one owner

One person owns the fix. Two people repairing the same defect in different places is how
inconsistent, half-applied fixes reach the customer.

Fix the cause you wrote in step 4, not the symptom. If the repair changes how the system
behaves - rather than restoring behaviour that was already agreed - **leave an ADR behind**
(`templates/adr-template.md`). Without it, the next person meets the same question and decides
differently, which is where "everyone fixes it their own way" begins.

## 8. Make the reproduction permanent

The failing test from step 3 joins the suite for good. Put it at the layer where the cause
lives, not the layer where the symptom showed:

- the cause is in one unit of logic, with no I/O: **unit**
- the cause is in how two real things meet - a database, a queue, a service, a file share:
  **integration**
- the cause is in a path the user walks: **e2e**

Name it for the defect and the `US` it violates, so a future failure explains itself.

## 9. Run the layers as a gate, without being asked

When this skill is active, the fix is not reported as finished until the tests have run and the
numbers are visible. Nobody should have to ask for this.

- Order is unit, then integration, then e2e. Stop at the first red layer.
- **Scope comes from step 5.** A change nothing depends on can stop at unit. Touch a shared
  module, an external contract, a data shape or a message between systems and **integration is
  required**. Touch a path the user walks and **e2e is required**.
- **If the repository has no such commands, create them from `templates/` as part of this fix.**
  Most Codefin repositories do not have them yet. This is how the gates arrive - out of work the
  team is already doing, rather than out of a separate initiative that never gets scheduled.
- Report real numbers: which layers ran, how many cases, how many passed, which layers were
  skipped and why. **Never report a fix as done with no run.** If a layer could not run, say so
  plainly and say what stopped it.

`references/testing.md` says how to write each layer; `references/gates.md` says how to make CI
enforce the same thing.

## 10. Verify where the customer was

Verify on the environment in the record from step 1. Passing locally is not the claim being
made when the ticket is closed.

## 11. Close with evidence

The closing note says:

- the cause, in the sentence from step 4
- what changed
- what else was affected, from step 5
- which test now guards it, by name
- where it was verified

Written this way, the note is something the PO can send to the customer unedited, which is
itself part of rebuilding confidence.

## 12. If it is reopened, record which step was skipped

A reopen is information. Note which of these steps was skipped or done thinly - it is almost
always one of 3, 5 or 8. Counting reopens by the step that was missed is the only way to tell
whether this procedure is working or needs changing, and it is data the team does not have yet.

## Reporting a round of fixes

When several defects are worked together, the round report states the number found, the number
fixed, the running tally across rounds, and how many P0, P1 and P2 remain open. A falling rate
across rounds is what says the loop can stop; a list of descriptions says nothing.
