# Adding a skill here

For the mechanics of authoring a skill — frontmatter, progressive disclosure, bundled resources —
use the `write-a-skill` or `skill-creator` skills. This file is about what makes a skill belong
in *this* repository, and the bar it clears before it ships to the team.

## When something belongs here

A skill is worth writing when the company keeps re-explaining the same thing: to a new hire, to
a team on another project, or to an agent at the start of every session. That is the test. Not
"would this be nice to have", but "have we now said this more than twice".

It does **not** belong here if:

- it is the house style for a document or a deck — that is packaged separately
- it is true of one project only — that belongs in that repository's `CLAUDE.md`
- it is general good practice with nothing particular to this process in it — the model already
  knows it,
  and wrapping it adds noise without adding information

## The bar

### Written from evidence, not from principle

Survey what the team actually does before writing a line of guidance: read the repositories,
the delivered documents, the pipelines. Where practice is inconsistent, note it rather than
quietly picking a winner — the inconsistency is usually the most useful thing you found, and
choosing between them is the owner's call, not the author's.

Run `./scripts/check-no-leaks.sh --history` before pushing, and read the findings yourself
rather than looking for a tool that strips them: the checks catch shapes, not meaning.

**Keep the survey itself internal, and publish only what it taught.** The findings that make a
skill good — which repositories are weak, which client systems lack a gate — are exactly the
findings that must not ship. Write the guidance as a general standard that stands on its own,
and leave the evidence out.

A skill that says what the team already knows it should do, without knowing what the team
actually does, will be ignored and deserves to be.

### Principles separate from tools

Put the shape of the thing in the main files, and every tool name in one reference of its own.
A team may write Go, Rust, TypeScript, Python, Dart, Kotlin, Swift and Terraform; a skill that
assumes one of them excludes most of the company, and dates the moment a stack changes.

`cf-dev` does this with `references/stacks.md`, and checks it:

```bash
grep -ril '<a tool your company happens to use>' plugins/<skill>/skills/<skill>/SKILL.md \
  plugins/<skill>/skills/<skill>/references/*.md
```

Nothing should come back except the one stacks reference.

### Read the repository, then follow it

Company-wide does not mean uniform. Repositories genuinely differ, and the standing ruling is
that a skill **reads the repository it is in and follows what it already does**, falling back to
house defaults only where the repository is silent. Very little is fixed everywhere; be sure
anything you write as absolute really is.

### Anything runnable is actually run

Templates and scripts ship only after they have been executed against something real, and the
result goes in the commit message. `./scripts/check-templates.sh` enforces this for unit-test
templates by copying each one over a fixture in `tests/fixtures/` and running it; add a fixture
when you add a template, so the rule keeps applying to the new one. `cf-dev`'s Go and Python test templates were run in real
modules through the template's own Makefile target; its `blast-radius.sh` was run against the
live repositories, where it immediately found a vendored copy of a shared helper and a component
defined three times.

A template that has never run is a guess with syntax highlighting.

### Tested where the answers should differ

Run the skill against two projects whose conventions are opposites and check it gives two
different answers. If it gives the same answer to both, it is imposing rather than reading.

Pick two of your own: one with Conventional Commits, a full CI suite and commit hooks, and one
with prose commits and no workflows at all. Opposite rules about commit attribution make a good
third axis.

## Who reaches it: the invocation choice

A skill is reached one of two ways, and the choice spends one of two budgets.

**Context load** is what always-loaded material costs the agent: a skill's `description` sits in
context every turn of every session, spending tokens and attention whether or not the skill ever
fires. **Cognitive load** is what it costs the human: remembering the skill exists at all.

| | Reached by | Costs |
| :-- | :-- | :-- |
| **model-invoked** (default) | the agent, on its own, plus anyone typing its name | context load, every turn, forever |
| **user-invoked** (`disable-model-invocation: true`) | only a person typing its name | nothing in context; the human is the index |

Choose model-invoked only when the agent must reach it without being told - which is true of a
discipline that should apply whenever the work matches, and false of anything that runs once by
hand. `cf-setup` is user-invoked for exactly that reason: paying context load in every
future session for a skill used once is waste.

A user-invoked skill's description is written for the person reading a list, not for the model:
one line, no trigger vocabulary.

## The description is a pointer, so cut it hardest

A model-invoked skill's `description` is the only part of it that is always loaded. Everything
else is read on demand. That makes it the most expensive text in the skill and the most
important: its **wording**, not the quality of what it points at, decides whether the skill fires
when it should.

- **Lead with the trigger, not with identity.** "Business analysis here. Use when..." spends
  its first and most valuable words saying what the body already says. Start where the work is.
- **One trigger per case.** Synonyms for the same situation are one case written twice.
- **Only the cases that should actually fire it.** A description listing everything the skill
  touches fires it on everything.

## Steps need a completion criterion

Every step should say what condition ends it, in words the agent can check. Two things make that
work:

- **Can it tell done from not-done?** A vague bound invites finishing early, with attention
  already on the next step. "Understanding reached" is not a bound; "the cause written as one
  sentence" is.
- **How much does it demand?** "Every consumer in the table accounted for" produces thorough work
  where "check the consumers" produces a gesture at it. The exhaustiveness bar is what makes a
  procedure hold up when someone is tired and the release is Friday.

## Commands are shortcuts, never the only route

A command is a starting point. It may read the skill's references; it must **never invoke another
command**, or the paths through the work stop being traceable.

And every command must be a shortcut to a procedure that is written down in `references/`. This
has a mechanical reason as well as a design one: `npx skills` installs skills but not commands,
so a procedure reachable only through a command does not exist for those users.

## Shape

```
plugins/<skill>/
  .claude-plugin/plugin.json    name, version, description, repository
  commands/                     slash commands, one markdown file each
  skills/<skill>/
    SKILL.md                    short. The rules that do not vary, and a table pointing onward
    references/                 one file per subject, loaded only when needed
    scripts/                    executable, with -h usage
    templates/                  files to copy
```

Keep `SKILL.md` short enough to read in full every session, because it is. Everything that is
only sometimes relevant goes in `references/` and gets pointed at from the table.

## Shipping

1. Bump `version` in `plugin.json`.
2. Commit. Match this repository's log: Conventional Commits, and no AI attribution trailer —
   the same rule `cf-dev` tells you to apply everywhere.
3. Test **both** install routes locally before pushing, because they package differently:

   ```bash
   claude plugin marketplace update cf-skills
   claude plugin install <skill>@cf-skills

   npx skills add ./cf-skills --skill <skill> --copy
   ```

   Then look at what actually landed — under `~/.claude/plugins/cache/cf-skills/` for the
   plugin, and `.claude/skills/<skill>/` for the other. A file missing from the package is
   invisible from the source tree, and an executable that lost its bit is worse than missing.
4. **Write the skill so it works without its commands.** `npx skills` installs skills but not
   slash commands, so a command must be a shortcut to a procedure that is written down in
   `references/`, never the only way to reach it.
5. Slash commands appear only in a **new** session; the list is read at startup.

## Where these ideas came from

The invocation choice, the two loads, the description as a pointer, and completion criteria are
taken from Matt Pocock's [skills repository](https://github.com/mattpocock/skills) - see its
`writing-for-agents` skill and that skill's `SKILL-MECHANICS.md`. The explore-then-ask-only-the
-unsettled shape of `cf-setup` comes from the same place. Worth reading in full before
writing a skill here.
