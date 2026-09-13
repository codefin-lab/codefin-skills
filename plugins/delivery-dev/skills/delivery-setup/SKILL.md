---
name: delivery-setup
description: "Set a repository up for the delivery skills: create the furniture it is missing, install the test gate, and record the few things the repository cannot tell you itself. Run once, by hand."
disable-model-invocation: true   # Claude Code
allow_implicit_invocation: false  # Codex, and agents that follow its spec
---

# Setting a repository up

Run once, before the other skills do much work here. Everything else in these skills reads the
repository and follows what it finds; this is the one that **puts things there** when they are
missing.

It is a conversation, not a script. Explore, show what you found, ask only about what exploration
did not settle, show a draft, then write.

> **Never ask about something the repository already answers.** A repository whose log is full of
> Conventional Commits does not get asked about commit style. Every question you ask that the
> code could have told you spends the user's patience on nothing, and teaches them that this
> step is a form to get past.

## 1. Explore

Run the seven steps in `delivery-dev`'s `references/detect.md` - instructions for agents, the task
runner, lint and hooks, what CI gates, commit and branch style, attribution, and layout. Do not
restate them here; run them.

Then look for what setup specifically cares about:

```bash
ls /path/to/repo/{CLAUDE.md,AGENTS.md,CONTEXT.md,ARCHITECTURE.md,.env.example,.gitignore} 2>/dev/null
ls -d /path/to/repo/docs/adr 2>/dev/null
ls /path/to/repo/.github/workflows 2>/dev/null

# Anything secret already committed. Check before you add a gate, not after.
git -C /path/to/repo ls-files | grep -iE '(^|/)\.env$|\.pem$|\.p12$|credentials|secrets?\.(ya?ml|json)$'
```

**A tracked `.env` or key file is the first thing to report, ahead of anything missing.** It is
already in the history, so removing the file does not remove the secret: say so, say the
credential has to be rotated, and leave rewriting history to the user. Do not quietly delete it
and move on.

## 2. Present what you found

Two short lists: **what is already here**, and **what is missing**. Nothing else. The user should
be able to see in five seconds whether this repository needs much or little.

Say which of the things below you can create without asking, and which need an answer.

## 3. Ask, one section at a time

**Lead each section with the recommended answer**, so it can be accepted in a word. Explain only
where the choice genuinely branches. **Skip any section exploration already settled**, and say
you are skipping it and why.

Only three things are genuinely unknowable from the repository. Ask about those; nothing else.

**A. Where the agreement lives.** Recommended: in this repository under `docs/`.

Client work usually keeps the BRD or FSD somewhere else - a shared drive, a document system, the
customer's own space. Ask where, and for the current version. Without it, nobody can judge
whether a complaint is a defect or a change request, which is the first question the defect
procedure asks.

**B. Environments, and how you see a change running.** Recommended: whatever the CI workflows and
compose files already imply - show what you inferred and ask only for the gaps.

Which environments exist, how a change reaches each, and how you tell it worked. This is what
makes "verify on the environment the customer reported" an instruction rather than a slogan, and
what decides where `make test-integration ENV=` points.

**C. Where work is tracked.** Skip entirely if the git log already shows a ticket key - you know
the answer. Otherwise ask which board, and what a ticket key looks like, since branches and
commits carry it.

## 4. Confirm

Show a draft of every file you would create or edit, and let the user change it before anything
is written. A user who has read the draft owns the result; one who is handed a finished commit
does not.

## 5. Write

Create only what is missing. Never overwrite a file that exists - if something is there but
wrong, say so and leave it.

| Create | From | Why |
| :-- | :-- | :-- |
| `CLAUDE.md` or `AGENTS.md` | the answers to section 3 | `detect.md` reads it first, so the next session does not ask again |
| `CONTEXT.md` | a stub with the domain's vocabulary | the words the team and the customer use |
| `docs/adr/0001-*.md` | `delivery-dev` `templates/adr-template.md` | records that this project adopted these standards, and why |
| `.env.example` | the variables the code reads | every one, with safe examples and no secrets |
| `.gitignore` | the language's build output, plus `coverage.*` | the test targets below write coverage files on their first run |
| the test and build targets | `delivery-dev` `templates/makefile-test.mk` | `lint`, `build`, `test`, `test-integration`, `test-e2e`, `test-all` |
| the pull request gate | `delivery-dev` `templates/workflow-pr.yml` | far easier now than after the repository has grown without one |

Install the Makefile block and the workflow **together**: the workflow calls `lint`, `test` and
`build`, and a gate that fails on its first run for a missing target teaches the team to ignore
it.

Put the answers from section 3 in `CLAUDE.md` as plain prose under a heading - where the
agreement lives, the environments and how to reach them, where work is tracked. **Not a separate
profile file**: knowledge that can go stale has to live where a pull request will catch it, and a
file nobody edits alongside the code is a file that quietly stops being true.

Offer it all as **one pull request** for review. Do not scatter files into the working tree and
leave.

## Afterwards

Say what was created, what was skipped and why, and what still has no answer. Anything left open
is a question for later, not a gap to fill with a plausible guess.

Then run `lint`, `build` and `test` once. A repository that has just been given a gate should be
watched going green, or the gate is a claim rather than a fact.

**A green `make test` on a repository with no tests proves nothing.** It exits zero because there
was nothing to run, which is the same empty-suite problem these skills warn about elsewhere -
except this time we installed it. So before calling setup done, either:

- **write one real test** against something the code already does, from
  `delivery-dev` `templates/unit-test.*`, and watch it pass and then fail when you break the code
  under it; or
- **say plainly that the gate is currently vacuous**, with the count of test files, so nobody
  reads the green tick as evidence.

The first is better and usually takes ten minutes. A gate whose first green run is honest is the
difference between a habit and a decoration.
