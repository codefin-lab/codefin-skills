---
description: Walk a defect through Codefin's procedure - record it, decide defect or CR, reproduce, trace the blast radius, fix, leave a regression test, run the gates, close with evidence.
argument-hint: [the report, a ticket key, or a path to it]
---

Drive the defect procedure end to end. Read `references/defects.md` in the `codefin-dev` skill
and follow it; this command is how it gets run, not a second copy of it.

The report, if one was given: **$ARGUMENTS**

Work the steps below in order, out loud, one at a time. Do not batch them, and do not skip
ahead to the fix because the cause looks obvious - the two things that get Codefin defects
reopened are a fix that missed somewhere it was needed and a bug with nothing stopping it
coming back, and steps 5 and 8 are the ones that address them.

## Open the record first

Start a record from the skill's `templates/defect-record.md`, at `docs/defects/DEF-<id>.md` in
the repository if it keeps them there, otherwise ask where it should live. Fill what the report
already gives you, then **ask for what is missing** - the environment, the build, the exact
steps, what was expected. If you cannot name the `US-<epic>.<n>` it violates, say so and ask;
that field is what makes the next step decidable.

Do not begin investigating until the record exists.

## Then, in order

1. **Defect or CR.** The code contradicting the document is a defect; the document being wrong,
   silent or absent is a change request. State which, in the record, with the reason. A CR stops
   here - say so, and amend the BRD first, through whichever skill owns the document
   house style.
2. **Reproduce**, as a failing test, on the environment in the record. If it will not reproduce,
   go back and ask rather than guessing.
3. **Find the cause**, and write it as one sentence. If you cannot, keep going - you have not
   found it.
4. **Trace the blast radius before editing anything.** Run the script:

   ```bash
   bash <skill>/scripts/blast-radius.sh <symbol> -C <repo> -o <org>
   ```

   Run it for each thing you are about to change - a function, a column, a topic, a schema
   field, a component. Add `-o` for the GitHub org whenever the thing is shared. Also ask the
   language server for references, because grep cannot see an indirect call through an
   interface.

   Read the results for **copies as well as uses**: a vendored or pasted duplicate will not
   receive your fix. Write the findings into the record **even when nothing is affected**.
5. **Look sideways** for the same mistake written elsewhere.
6. **Fix the cause**, not the symptom. If this decides how something works rather than restoring
   agreed behaviour, write an ADR from `templates/adr-template.md`.
7. **Make the reproduction permanent**, at the layer where the cause lives, named for the defect
   and the `US` it violates.
8. **Run the gates yourself. Do not wait to be asked.** Unit, then integration, then e2e,
   stopping at the first red layer. Scope comes from step 4: anything that crossed a repository
   boundary, a shared module, a contract, a data shape or a message between systems makes
   integration mandatory; anything on a path the user walks makes e2e mandatory.

   If the repository has no such commands, create them from the skill's `templates/` as part of
   this fix.

   Report real numbers - layers run, cases, passed, skipped and why. Never say the fix works
   without a run; if a layer could not run, say which and what stopped it.
9. **Verify on the environment the customer reported**, not just locally.
10. **Close with evidence** in the record: the cause, what changed, what else was affected, the
    test that now guards it, where it was verified. Write the closing note so the BA can send it
    to the customer unedited.

## While you work

- Follow this repository's own conventions - commits, branches, attribution - per
  `references/detect.md`. Do not impose the house defaults over what the repository does.
- Commit as Conventional Commits, `fix(<scope>): ...`, referencing the ticket.
- If the fix turns out to need a decision that is not yours - the document is ambiguous, the
  blast radius is larger than the ticket - stop and ask rather than deciding on someone's behalf.
- If this defect was reopened from an earlier fix, record which step was skipped last time.
  That is the measurement nobody is collecting yet.
