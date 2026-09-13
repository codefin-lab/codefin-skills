# Reading a repository before you write in it

Run this once per repository per session. It costs a minute, and it is the difference between a
change that merges and a change that gets rewritten in review.

Work from strongest evidence to weakest, and stop as soon as a question is answered.

## 1. Instructions written for you

```bash
ls /path/to/repo/{CLAUDE.md,AGENTS.md,CONTRIBUTING.md,CONTEXT.md,ARCHITECTURE.md,CODEOWNERS} 2>/dev/null
```

`CLAUDE.md` and `AGENTS.md` outrank everything else, including this skill's defaults.
`CONTRIBUTING.md` binds you the same way it binds the team. `CODEOWNERS` tells you who will
review this, which tells you who the pull request is written for.

## 2. Find the tests first

Before anything else about the code, find out what proof exists.

```bash
ls /path/to/repo            # Makefile? package.json? justfile?
make help 2>/dev/null || true
git -C /path/to/repo grep -lE '_test\.|\.test\.|\.spec\.|test_' -- . | head -20
ls /path/to/repo/.github/workflows 2>/dev/null
```

Three separate questions, and the answers are often not what the repository implies:

- **What commands exist?** Is there a `test` target, and are there `test-integration` and
  `test-e2e`?
- **Are there tests behind them?** A `test/` directory holding only a `.gitkeep` is common here.
  Count real test files rather than trusting the target's existence.
- **Does CI run them?** Read the workflow triggers. A repository whose only workflow deploys on
  push has no gate at all, and review is the only thing standing between a change and staging.

Whatever is missing, you now know what `references/gates.md` has to add, and you know not to
claim a suite passed when there is no suite.

## 3. How the repository is driven

The task interface is whichever of these exists, and you use it rather than calling the tool
underneath:

| File | Interface |
| :-- | :-- |
| `Makefile` | `make help` lists targets; well-kept ones document each with `##` |
| `package.json` | the `scripts` block |
| `justfile`, `Taskfile.yml` | the recipes |
| `go.mod`, `Cargo.toml`, `pyproject.toml`, `pubspec.yaml` | the language toolchain |
| `mise.toml`, `.node-version`, `.tool-versions` | the toolchain versions to match |
| `docker-compose*.yml` | how the stack comes up locally |

Never run the bare tool when a target exists: the target usually sets environment the bare
command does not, and that is exactly how "it passes for me" happens.

## 4. Format, lint, and whether they are enforced

```bash
ls /path/to/repo/{.editorconfig,.prettierrc*,.golangci.yml,rustfmt.toml,ruff.toml,.oxlintrc.json} 2>/dev/null
ls /path/to/repo/.husky /path/to/repo/.pre-commit-config.yaml 2>/dev/null
```

A hook directory means a gate runs on commit whether you remember it or not. Match the
configuration exactly. Do not introduce a formatter the repository has not chosen.

## 5. Commit and branch style, from the log

```bash
git -C /path/to/repo log --format='%s' -30
git -C /path/to/repo branch -a --format='%(refname:short)' | head -20
```

- Subjects like `feat:` or `fix(scope):` mean Conventional Commits. Reuse the type and scope
  vocabulary already in use rather than inventing new ones.
- Plain descriptive sentences mean the repository writes prose. Match the register and length;
  some repositories write a paragraph, some write six words.
- Branch names show the pattern, and whether a ticket key belongs in them.
- A `develop` branch alongside `main` means your branch targets `develop`.

## 6. Attribution

```bash
git -C /path/to/repo log --format='%b' -20 | grep -i 'co-authored-by' | sort -u
```

If recent commits carry no trailer, this repository does not want one - some forbid AI
attribution outright. Match the log; never add a trailer the repository
has not been using.

## 7. Layout, before you add a file

Find where a sibling of the thing you are adding already lives, and put yours beside it. Do not
reason from the boilerplate the project was generated from: repositories drift from their
template, and many already have. The sibling in *this* repository decides.

## When the repository cannot tell you

Three things are not in the files, because they live outside them. Do not guess at these, and do
not open a session by asking all of them either - **ask at the moment the work needs one**, and
write the answer into `CLAUDE.md` so nobody asks again.

| Not in the repository | Ask when | Needed for |
| :-- | :-- | :-- |
| where the BRD or FSD actually lives, and which version is current | before judging a customer report, or checking requirements | deciding defect against change request at all |
| which environments exist, how a change reaches each, how you see it worked | before closing a defect, or pointing an integration run | "verify where the customer was" being an instruction rather than a slogan |
| which board work is tracked on | only if the log shows no ticket key | branch and commit references |

A question asked when it matters gets a real answer. The same question asked in a setup form gets
whatever is quickest to type, and then everybody believes it for a year.

A repository that has never been set up may simply be missing its furniture as well - the
`delivery-setup` skill creates it, once, by hand.

## When the repository contradicts itself

A README describing one structure while the code ships another, a documented gate no workflow
runs: **the running code decides what you write**, and the contradiction is worth one sentence to
whoever owns the repository. Write it down where the next person will meet it.
