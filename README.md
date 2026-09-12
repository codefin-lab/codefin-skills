# codefin-skills

Skills for Claude Code and other agents, from Codefin.

This is where working knowledge gets packaged so that every team, and every agent, works the
same way — instead of each person, and each session, rediscovering how things are done.

The skills are written as **general standards**, not as a record of any one project, so they are
useful outside the company that wrote them. That is why this is public: take what is useful.

It is built to hold several. `codefin-dev` is the first, and covers the way software gets built
here. Codefin's document and brand house style is a separate, private package.

## Skills

| Skill | What it is |
| :-- | :-- |
| `codefin-dev` | How Codefin builds software: the three test layers run as gates without being asked, the defect procedure that keeps a fix closed, where project knowledge lives, and the PO/QA/Dev handoffs. Ships `/codefin-dev:defect` and `blast-radius.sh`. |

Candidates, not yet built: delivery and packaging (hardened images, Helm, SBOM, CIS), and
whatever else turns out to be re-explained often enough to be worth writing down.

## Install

Two routes. They read the same files, so a skill is written once.

### As a plugin — the full thing

```bash
claude plugin marketplace add codefin-lab/codefin-skills
claude plugin install codefin-dev@codefin-skills
```

Claude Code only. Brings the skill **and** the slash commands it ships, and updates with
`claude plugin marketplace update codefin-skills`.

### With `npx skills` — the skill on its own

```bash
npx skills add codefin-lab/codefin-skills --skill codefin-dev
```

Works for other agents too, and installs into the project at `.claude/skills/<name>/` (add `-g`
for the user directory), recording what it took in `skills-lock.json`. Private repositories work
through whatever Git or `gh` authentication is already set up.

References, scripts and templates all come along, and scripts stay executable — verified.
**Slash commands do not**, because they are a plugin mechanism: installed this way,
`/codefin-dev:defect` does not exist, and the procedure is followed from
`references/defects.md` instead. Same steps, one fewer shortcut.

### Working on the skills

Point either route at a checkout:

```bash
claude plugin marketplace add ./codefin-skills
npx skills add ./codefin-skills --skill codefin-dev --copy
```

## Adding a skill

[docs/adding-a-skill.md](docs/adding-a-skill.md) — the shape a skill here takes, and the bar it
has to clear before it ships.

Briefly: a skill belongs here when it is knowledge the company keeps re-explaining. It earns its
place by being **grounded in what the company actually does**, rather than in what good practice
says in general; by **stating the standard without publishing the evidence**, since the findings
that make a skill good are usually the ones that must not ship; and by **carrying its principles
separately from its tools**, so it survives the next language or vendor.

## Layout

```
.claude-plugin/marketplace.json    the marketplace
docs/
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

## License

MIT — see [LICENSE](LICENSE). Take what is useful.
