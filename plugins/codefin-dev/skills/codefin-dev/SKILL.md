---
name: codefin-dev
description: "How Codefin builds software. Use when writing, reviewing, testing, scaffolding or releasing code in any Codefin or client repository, when investigating or fixing a defect, when deciding commit messages, branch names, repository layout or review gates, and when working out what belongs to the BA, QA or Dev."
---

# Building software at Codefin

Codefin runs many codebases in many languages, and they are deliberately not alike. So this
skill holds two kinds of thing: a few rules that hold everywhere, and a habit for everything
else.

> **Read the repository before you write in it. Follow what it already does. Fall back to the
> house defaults in `references/conventions.md` only when the repository has no answer.**

A change that is locally consistent and house-inconsistent is better than the reverse. If a
repository's convention looks wrong, say so in one sentence and keep following it until whoever
owns that repository decides. `references/detect.md` is the procedure; run it once per repository per session.

## One document, one identifier, all the way down

The BRD is what Codefin and the customer agreed to - some clients call the same document an
FSD, and the name changes nothing. It is the only artifact the BA, QA and Dev all hold, so
everything else hangs off it and carries its identifier.

```
BRD          US-3.4 and its Acceptance Criteria    the agreement, written by the BA
  └─ TS-900  the scenario QA derives to prove it
      ├─ test cases at every layer   named for TS-900, traceable back to US-3.4
      ├─ branch and commits          carry the ticket key
      └─ a defect                    cites the US it violates, rather than retelling the story
          └─ its regression test     named for the defect, pointing back at the same US
```

Two identifiers, not one: the BA numbers what was agreed, QA numbers how it gets proved, and
each carries the other. A test that names only its own scenario cannot be traced to a promise;
a requirement with no scenario has nobody proving it.

Two rules make this hold.

**Change the document before the code.** Scope moved, the spec was wrong, a new case appeared:
edit the BRD first, then write code to match. A document updated afterwards is a document
never updated. Make that edit through whichever skill owns your document house style.

**A defect is a defect only when the code contradicts the document.** If the document is wrong,
silent or never covered the case, it is a change request, not a defect. Arguing about scope
after the fact is a large share of why work gets reopened, and this line settles it before the
argument starts. It is the existing Codefin rule: anything not written in the scope is a CR.

## What does not vary

- **Conventional Commits**, with a scope when the repository has more than one component:
  `feat(audit): ...`, `fix: ...`, `refactor(batchload)!: ...`. Plain sentence case, no trailing
  period, and the subject says what changed and why it matters.
- **Every defect leaves a test behind.** The reproduction you wrote to prove the bug becomes a
  permanent regression test. This is how a fix stays fixed, and how suites that start at zero
  grow out of work the team is already doing.
- **Run the tests yourself; nobody should have to ask.** A fix or a change is not reported as
  done until the layers its blast radius demands have run and the numbers are on the table.
  If a layer could not run, say which and why. Never claim a fix works without a run.
- **Find out what depends on a thing before you change it**, not after. `references/defects.md`
  has the procedure. Skipping it is the main reason a fix turns out to be incomplete.
- **Shell commands handed to a person use full absolute paths.** People paste them straight into
  a terminal whose working directory is not the repository root, so a relative path fails: write
  `cd /path/to/repo/deployments/gcp/vm`, never `cd deployments/gcp/vm`.
- **Verify locally before anything leaves the machine.** A change is checked on localhost and
  approved before it is built, pushed to a registry, or applied with Terraform.
- **No mocks or simulated execution in a demo.** Every path runs for real against a real target.
- **Never invent a component, variant or pattern the project already has.** Find the existing
  one and use it.
- **Review rounds are counted.** Every round reports defects found and fixed, the running tally
  across rounds, and how many P0, P1 and P2 remain open. Descriptions alone do not tell anyone
  whether the loop can stop.
- **Commit attribution is per repository.** Some Codefin repositories forbid an AI trailer
  outright. Match `git log`; never add a trailer the repository has not been using.

## Where to read next

| You are | Read |
| :-- | :-- |
| fixing a defect, or investigating one | `references/defects.md` |
| writing tests, or deciding which layer one belongs in | `references/testing.md` |
| wiring tests into CI so they actually block | `references/gates.md` |
| starting in an unfamiliar repository | `references/detect.md` |
| deciding where a piece of project knowledge should live | `references/knowledge.md` |
| handing work to or from the BA or QA, or planning a release | `references/workflow.md` |
| opening a greenfield project, or a repository is silent on a point | `references/conventions.md` |
| needing the tools for a specific language | `references/stacks.md` |

`scripts/blast-radius.sh` does the searching step 5 asks for, and `templates/` holds files to
copy rather than retype. Where this skill was installed as a plugin, `/codefin-dev:defect` walks
a defect from report to closing note; installed as a skill alone that command does not exist,
so follow `references/defects.md` directly - it is the same procedure.

## Documents

Anything client-facing that comes out of the work - a BRD, an FSD, a technical or API
specification, a proposal, minutes - is written through whichever skill owns the document house
style, not by hand. That one covers the paper; this one covers the code. At Codefin they are a
matched pair, and the house style is packaged separately because it carries brand assets.
