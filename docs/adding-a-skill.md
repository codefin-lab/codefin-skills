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
- it is general good practice with nothing Codefin-specific in it — the model already knows it,
  and wrapping it adds noise without adding information

## The bar

### Written from evidence, not from principle

Survey what the company actually does before writing a line of guidance: read the repositories,
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
Codefin writes Go, Rust, TypeScript, Python, Dart, Kotlin, Swift and Terraform; a skill that
assumes one of them excludes most of the company, and dates the moment a stack changes.

`codefin-dev` does this with `references/stacks.md`, and checks it:

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
when you add a template, so the rule keeps applying to the new one. `codefin-dev`'s Go and Python test templates were run in real
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
   the same rule `codefin-dev` tells you to apply everywhere.
3. Test **both** install routes locally before pushing, because they package differently:

   ```bash
   claude plugin marketplace update codefin-skills
   claude plugin install <skill>@codefin-skills

   npx skills add ./codefin-skills --skill <skill> --copy
   ```

   Then look at what actually landed — under `~/.claude/plugins/cache/codefin-skills/` for the
   plugin, and `.claude/skills/<skill>/` for the other. A file missing from the package is
   invisible from the source tree, and an executable that lost its bit is worse than missing.
4. **Write the skill so it works without its commands.** `npx skills` installs skills but not
   slash commands, so a command must be a shortcut to a procedure that is written down in
   `references/`, never the only way to reach it.
5. Slash commands appear only in a **new** session; the list is read at startup.
