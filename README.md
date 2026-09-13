# cf-skills

Skills for Claude Code, Codex, Antigravity, Cursor and around eighty other agents: one role
each, covering how software gets decided,
specified, designed, built, proved and managed - plus one that gets a repository ready for them.

They describe **one opinionated process**, written so that anyone can run it. The opinions are
real and load-bearing - they came from delivering software to customers, not from a textbook -
but nothing in them is tied to the company that wrote them. Take what is useful.

## What these are for

An agent that is good in general is still guessing about your team. It does not know that your
repositories disagree with each other on purpose, that a change request and a defect are
different things with different consequences, or that "the report loads quickly" is not a
requirement. Every session it guesses again, and differently.

These skills answer those questions once. Installed, they change what an agent does without
being asked: it reads a repository's conventions before writing in it, runs the tests before
reporting a fix, checks what else depends on the code it is about to change, and refuses to
call an acceptance criterion finished when nobody could check it.

## What the process assumes

Some assumptions are stated out loud in the skills rather than hidden, because your team may be
arranged differently:

- **QA writes the automation**, rather than specifying cases for developers to automate.
- **estimation happens twice**: the BA sizes roughly so the work can be priced and ordered, Dev
  estimates in detail once the shape is known, and the PM coordinates the two and owns the budget.
- **the BRD - some customers call the same document an FSD - is the agreement**, and everything
  downstream carries its requirement identifier.

Substitute your own arrangement where these differ. Nothing else depends on them: everything
about repositories, tests, defects and gates applies as written.

The checks in `scripts/` guard this repository, not yours. If you fork and one flags something of
your own - your real ticket keys, say - add the prefix to `.leakallow` rather than removing the
check.

## Two modes

Most of this is written for **client work**: a scope agreed in a document, changes priced as
change requests, a budget in days, a steering committee. That is the common case, and the rules
are sharp because of it.

For **a product of your own** the same shapes hold with different mechanics - a backlog instead
of an agreed scope, reprioritising instead of a change request, team capacity instead of a sold
budget, internal stakeholders instead of a committee. Where a rule differs, it says so on the
spot. Where it says nothing, it applies either way.

## The skills

One per role. Each owns a question, and - just as important - each says what it does **not**
own, because most project arguments are somebody answering a question that was not theirs. The
roles are defined once, in `cf-dev` under `references/workflow.md`.

| Role | Owns | Does not own |
| :-- | :-- | :-- |
| `cf-po` | goal and value, scope, priority, MVP, backlog order, accepting the outcome | technical design, the schedule |
| `cf-ba` | requirement analysis, rules, use cases, edge cases, functional and non-functional requirements, acceptance criteria | priority, architecture |
| `cf-sa` | architecture, component, API and data design, how an NFR is met, integration, security, trade-offs | business priority |
| `cf-dev` | implementation, unit tests, technical breakdown and the detailed estimate | product priority |
| `cf-qa` | test strategy and cases, traceability, verification, regression | product scope decisions |
| `cf-pm` | plan, milestones, dependencies, resources, coordinating estimates, risk, progress | product requirements, architecture |

One person often wears several hats. That is a staffing arrangement, not a merging of the jobs -
write down who is wearing which, because the failure mode is everyone assuming somebody else was.

`cf-setup` is the odd one out: it runs once at the start of a repository and then never
again.

The sections below follow the order work moves through them.

```
cf-ba        what we agreed to build
   │  US-3.4 and its acceptance criteria
   ▼
cf-qa        how it gets proved
   │  TS-900 citing US-3.4
   ▼
cf-dev       how it gets built and repaired
      code, tests and defects, each naming the promise it is about

cf-pm        when, at what cost, and what gets cut
      the arithmetic on all three, reported to whoever is paying
```

A failing test names the clause of the agreement that is now untrue. A customer's complaint can
be traced to the case that should have caught it. That is the whole point of the chain, and
everything else is in service of it.

---

### `cf-po` — is it worth doing, and in what order

Fires when you are setting or challenging a goal, drawing the scope boundary, choosing a
minimum, ordering a backlog, or accepting a delivered outcome.

The whole role reduces to saying no well. Anyone can list what would be nice; the value is in
the order, and in what is left out.

| Reference | Covers |
| :-- | :-- |
| `value.md` | a goal is an outcome you could tell happened, not a list of features |
| `scope-and-mvp.md` | exclusions written as deliberately as inclusions; the smallest thing that settles a question |
| `priority.md` | MoSCoW where Must means the release is worthless without it; what to do when everything is urgent |
| `acceptance.md` | proved, accepted and shipped are three different judgements by three different people |

---

### `cf-ba` — what we agreed to build

Fires when you are eliciting requirements, writing or amending a BRD, writing acceptance
criteria, drawing the scope line, sizing a feature list, or judging whether a customer's
complaint is a defect or a change request.

Three rules it will not bend on: nothing goes in the document that you could not check; anything
not written in the scope section is out of scope; and the document is amended before the work
changes, never after.

| Reference | Covers |
| :-- | :-- |
| `acceptance-criteria.md` | the words that hide a decision, why a number needs an anchor, the unhappy paths |
| `elicitation.md` | written question rounds, questions that force a decision, closing soft answers |
| `requirements.md` | identifiers, epics that hold together, stories people can build from |
| `scope-and-change.md` | holding the line, defect versus CR, working a change request |
| `sizing.md` | feature lists, estimating without fooling yourself, why man-days stay internal |
| `modelling.md` | what deserves a diagram, and the access matrix everyone forgets |

Ships `/cf-ba:requirements`, `check-requirements.sh`, and templates for a requirement, a
question set and a change request.

---

### `cf-sa` — what it is built out of, and what was traded

Fires when you are choosing a shape, designing an API, schema or data model, working out how a
non-functional requirement will actually be met, integrating with a system you do not control,
or making a security decision.

Its output is mostly decisions and the reasons behind them. A diagram with no reasoning is a
picture; the reasoning is what lets the next person tell whether the decision still holds.

| Reference | Covers |
| :-- | :-- |
| `architecture.md` | decide late, record immediately; what warrants an ADR; naming what you traded |
| `interfaces.md` | anything published is a contract; design outward from the caller; versioning before the first consumer |
| `nfr.md` | a requirement becomes a mechanism, a cost, and a defined failure behaviour - or it is a hope |
| `integration.md` | make one real call before estimating; assume unavailable, slow and wrong |
| `security.md` | the handful of decisions that are architectural, and why a leaked secret needs rotating rather than deleting |

Ships `adr-template.md` and `nfr-table.md`.

---

### `cf-dev` — how it gets built and repaired

Fires when you are writing, reviewing or releasing code, investigating a defect, or deciding
commit messages, branch names, repository layout or review gates.

Its first rule is a habit rather than a convention: **read the repository before you write in
it, and follow what it already does.** House defaults apply only where a repository has no
answer of its own.

| Reference | Covers |
| :-- | :-- |
| `defects.md` | the twelve-step procedure, including the blast-radius step before the edit |
| `testing.md` | the three layers, what belongs in each, and naming that explains a failure |
| `gates.md` | where each layer attaches so it blocks, and why coverage starts at "must not fall" |
| `detect.md` | reading a repository's conventions before writing in it |
| `knowledge.md` | where project knowledge lives so it cannot go stale unnoticed |
| `workflow.md` | the handoffs between the BA, QA and Dev |
| `breakdown.md` | breaking work down until an estimate stops being a guess, and counting what is not typing |
| `conventions.md` | house defaults for a greenfield project |
| `stacks.md` | the only file that names specific tools |

Ships `/cf-dev:defect`, `blast-radius.sh`, and templates for tests in three languages, CI
workflows, an ADR, a defect record and the handoff checklists.

---

### `cf-qa` — whether it has been proved

Fires when you are designing scenarios from acceptance criteria, maintaining the register,
writing automation, planning or running a round, exploring, or taking a customer through UAT.

QA decides one question, and it is not whether the system is good: **has the claim been proved?**

| Reference | Covers |
| :-- | :-- |
| `designing-tests.md` | equivalence classes, boundaries, decision tables, illegal state transitions, the role matrix |
| `test-register.md` | the register is the source and automation is derived from it, columns that earn their place |
| `automation.md` | what to automate and what not, naming, structure, testability as a finding |
| `rounds.md` | entry criteria, selecting by risk, the numbers a round reports, exit criteria |
| `exploratory.md` | charters, time-boxes, and converting findings so they compound |
| `uat.md` | UAT as a rehearsal, not a discovery |
| `reporting-defects.md` | writing a defect that does not bounce |

Ships `/cf-qa:round`, `trace-gaps.sh`, and templates for a round report, an exploratory
charter, a UAT walkthrough and a testability-gap list.

---

### `cf-pm` — when, at what cost, and what gets cut

Fires when you are planning or replanning, tracking spend against the estimate, forecasting a
finish, keeping the risk register live, preparing a steering report, or deciding whether to ship.

It owns none of the content: not what the system should do, and not whether it works. The job is
arithmetic on other people's output, done honestly and early — the forecast recalculated from
what happened rather than from what was planned, and bad news travelling the week it becomes
likely rather than at the deadline.

| Reference | Covers |
| :-- | :-- |
| `plan.md` | milestones you can show, sequencing by risk, dependencies you do not control, replanning without hiding it |
| `cost.md` | the two numbers that only mean something together, what eats a budget, forecasting at the rate observed |
| `risk.md` | entries with a consequence in days and an owner who is a person, and what actually goes wrong on client projects |
| `steering.md` | where each number comes from, saying the bad thing first, asking for decisions rather than narrating |

Ships `/cf-pm:steering`, `forecast.sh`, and templates for a steering report and a risk
register.

---

### `cf-setup` — getting a repository ready

Run once per repository, by hand. It creates the furniture that is missing — `CONTEXT.md`, a
first ADR, `.env.example`, the four test targets and a pull request gate — and records the few
things a repository cannot tell you itself.

**It never asks what the files already answer.** It explores first, shows what it found, and
skips every question exploration settled. Only three things are genuinely unknowable from a
repository: where the agreement lives, what the environments are and how you see a change
running, and where work is tracked. Those go into `CLAUDE.md`, not a profile file, so they are
edited alongside the code and cannot go stale unnoticed.

Deliberately **user-invoked**: it is never reached by the model on its own, so it costs nothing
in context for the rest of the project's life. Ask for it by name.

## The scripts

A pattern turned up while writing these: each role has one tedious job it reliably skips, and
skipping it is what later goes wrong. So each skill ships a script for exactly that job.

| Script | Answers | Reads |
| :-- | :-- | :-- |
| `check-requirements.sh` | which requirements could not actually be proved | md, docx, pdf, xlsx, csv |
| `trace-gaps.sh` | where the chain from requirement to proof is broken | md, docx, pdf, xlsx, csv |
| `blast-radius.sh` | what else depends on the code about to change | a repo, sibling clones, a GitHub org |
| `forecast.sh` | what this will have cost at the rate it is actually going | md, docx, pdf, xlsx, csv |

Each says plainly what it cannot see, so it is not mistaken for the review itself. None of them
rewrites anything.

```bash
# before handing a BRD to Dev and QA
check-requirements.sh docs/BRD.docx

# before a round, and before claiming coverage
trace-gaps.sh --register register.xlsx --requirements docs/BRD.pdf --suite tests/

# before editing anything shared
blast-radius.sh PaginationOptions -C /path/to/repo -o my-org

# before writing a steering report
forecast.sh features.xlsx --rate 5
```

## Using them

Once installed, the skills load themselves when the work matches. You do not invoke them by
name - you describe the task.

| You say | What happens |
| :-- | :-- |
| "everything on this list is a Must" | the question that costs something: if only three land this quarter, which three |
| "this acceptance criterion says the report loads quickly" | it is sent back as untestable, with the question it was hiding |
| "the requirement says highly available" | that is a requirement, not a design - it becomes a mechanism, a cost, and a defined failure behaviour |
| "add a field to the shared customer model" | what depends on it is traced before the edit, and the integration layer becomes required |
| "fix this bug: the portfolio page errors for accounts with no holdings" | the defect procedure runs - record, reproduce, cause, blast radius, fix, regression test, gates, evidence |
| "plan the next SIT round" | entry criteria checked, selection by risk, exclusions written down, report with the tally |
| "how are we doing against the plan" | the forecast is recomputed from what happened, and it will not be flattered |
| "the customer says the export is wrong" | it is classified as a defect or a CR against the document before anyone starts fixing |

`cf-setup` is the exception: it never fires on its own, because a repository is set up
deliberately or not at all. Ask for it by name the first time you bring these skills to a project.

The slash commands are for when you want the whole procedure driven end to end:

```
/cf-ba:requirements  docs/BRD.docx
/cf-qa:round         round 3, build 1.4.2
/cf-dev:defect       customer reports the balance rounds down on the statement
/cf-pm:steering      march report, features.xlsx
```

**[docs/examples.md](docs/examples.md) walks one project through every role** - the same
statement service from the product owner's first ordering decision to the steering report,
with the real output of each script at the point it is used. Start there if you would rather see
it than read about it.

### A worked pass through the chain

0. **Once per repository**, `cf-setup` creates what is missing and asks only about what the
   files could not have told it.
1. **The PO** decides it is worth doing and where it sits in the order, and writes down what is
   deliberately out.
2. **The BA** turns that into `US-3.4` with acceptance criteria and a rough size, runs
   `check-requirements.sh` over the copy the customer actually holds, and sends back anything
   nobody could check.
3. **The SA** decides the shape, and turns "retained seven years" into a mechanism with a cost
   and a stated failure behaviour. What closes off an option leaves an ADR.
4. **Dev** breaks it down, estimates it properly, says so if that disagrees with the rough
   number, and builds it. The tests run as gates without anyone asking.
5. **QA** derives `TS-900` from the same criteria, expands it into cases at the boundaries and
   across the roles, and records what cannot be tested yet as items with owners.
6. **The PM** recomputes the forecast from what happened, and reports the slip the week it
   becomes likely rather than at the deadline.
7. **A defect arrives.** It is judged against the document first - defect or CR - then
   reproduced, traced, fixed once at the cause, and left with a regression test named for it.
8. **UAT** is a rehearsal: every walkthrough already passed on this build, and open defects are
   disclosed before the customer finds them. QA says it is proved, the PO says it is accepted,
   the PM says it ships - three decisions, three people.

Nothing in that loop requires the other skills to be installed - each works alone - but they are
built to fit.

## Install

Two routes. They read the same files, so a skill is written once.

### As a plugin — the full thing

```bash
claude plugin marketplace add codefin-lab/codefin-skills
claude plugin install cf-ba@cf-skills
claude plugin install cf-dev@cf-skills
claude plugin install cf-qa@cf-skills
claude plugin install cf-pm@cf-skills
claude plugin install cf-po@cf-skills
claude plugin install cf-sa@cf-skills
```

Claude Code only. Brings the skills **and** the slash commands, and updates with
`claude plugin marketplace update cf-skills`.

### With `npx skills` — the skills on their own, any agent

```bash
npx skills add codefin-lab/codefin-skills --skill '*'
```

It detects the agent you are running and installs where that agent reads, recording what it took
in `skills-lock.json`. Name one explicitly with `-a`, and add `-g` to install for the user rather
than the project:

```bash
npx skills add codefin-lab/codefin-skills --skill '*' -a codex
npx skills add codefin-lab/codefin-skills --skill '*' -a antigravity-cli
```

| Agent | Project | User |
| :-- | :-- | :-- |
| Codex | `.agents/skills/` | `~/.codex/skills/` |
| Antigravity CLI | `.agents/skills/` | `~/.gemini/antigravity-cli/skills/` |
| Cursor | `.agents/skills/` | `~/.cursor/skills/` |
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |

Around eighty agents are supported; those four are the ones verified here. Each skill carries an
`agents/openai.yaml`, which Codex and agents following its spec use for the display name.

References, scripts and templates all come along, and scripts stay executable.
**Slash commands do not**, because they are a Claude Code plugin mechanism: installed this way
the commands do not exist, and each procedure is followed from its reference file instead. Same
steps, one fewer shortcut - no command is ever the only route to a procedure.

`cf-setup` stays user-invoked on every agent: it carries both Claude Code's
`disable-model-invocation` and Codex's `allow_implicit_invocation: false`, so nothing fires it on
its own. A repository is set up deliberately or not at all.

### Working on the skills

Point either route at a checkout:

```bash
claude plugin marketplace add ./cf-skills
npx skills add ./cf-skills --skill cf-dev --copy
```

### Optional dependencies

Everything works without these; the scripts say so when one is missing.

| For | Install |
| :-- | :-- |
| reading `.xlsx` | `pip install openpyxl` |
| reading `.pdf` | `brew install poppler`, or `pip install pypdf` |
| searching a GitHub org for a blast radius | the `gh` CLI, authenticated |

## Adding a skill

[docs/adding-a-skill.md](docs/adding-a-skill.md) — the shape a skill here takes, and the bar it
clears before it ships.

Briefly: a skill belongs here when it is knowledge the company keeps re-explaining. It earns its
place by being **grounded in what the company actually does**, rather than in what good practice
says in general; by **stating the standard without publishing the evidence**, since the findings
that make a skill good are usually the ones that must not ship; and by **carrying its principles
separately from its tools**, so it survives the next language or vendor.

## Layout

```
.claude-plugin/marketplace.json    the marketplace
.github/workflows/pr.yml           this repository's own gate
scripts/                           check-no-leaks, check-structure, check-templates
tests/fixtures/                    minimal projects the templates are run against
docs/
  examples.md                      one project walked through every role
  adding-a-skill.md                how to add the next skill
plugins/<skill>/
  .claude-plugin/plugin.json
  commands/                        slash commands the skill ships
  skills/<skill>/
    SKILL.md                       short — the rules that do not vary, and where to read next
    references/                    loaded on demand
    scripts/                       tools the skill runs
    templates/                     files to copy rather than retype
```

## Checks

This repository runs the gate it argues for. Everything CI runs, you can run:

```bash
./scripts/check-no-leaks.sh              # public repo, internal origins - this matters most
./scripts/check-no-leaks.sh --history    # every blob on every ref, not just the working tree
./scripts/check-structure.sh             # json parses, skill names match their directories
./scripts/check-templates.sh             # the unit-test templates are executed, not just read
./scripts/install-hooks.sh               # optional: run the history check before every push
```

The leak check works in two layers, because a list of confidential names cannot itself be
published: structural patterns live in the script, and the names come from a `LEAK_DENYLIST`
repository secret, or a gitignored `.leakpatterns` file locally. What is known-safe goes the
other way, in `$LEAK_ALLOW` or a gitignored `.leakallow` — that is where a fork puts its own
ticket prefixes. A denylist hit is reported by
file, never by quoting the line. Every rule is tested by planting a fake leak and confirming the
gate fails, with a control that ordinary prose does not trip it.

`--history` exists because **deleting a leaked file does not unpublish it** — the blob stays
readable to anyone who clones. It is the check worth running before a push, which is what
`install-hooks.sh` wires up.

**There is no sanitiser, on purpose.** What leaks is rarely a name a script could substitute; it
is a sentence describing something internal, and only a person reading it will catch that. A
tool that rewrote text automatically would hide that work rather than do it. These scripts
verify and refuse; the judgement stays with the author.

## License

MIT — see [LICENSE](LICENSE). Take what is useful.
