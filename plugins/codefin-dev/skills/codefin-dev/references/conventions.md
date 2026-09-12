# House defaults

For a greenfield project, or when `references/detect.md` finds the repository has no answer.
An existing repository's own convention always wins over anything here.

## Commits

Conventional Commits, everywhere, no exceptions. This is the one rule that does not vary.

```
<type>(<scope>)<!>: <subject>
```

- **type**: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `chore`
- **scope**: the component, when the repository has more than one. Omit it in a single-component
  repository rather than inventing one.
- **`!`**: the change breaks something for a consumer. It also takes a major version bump, and
  the body lists who has to change.
- **subject**: plain sentence case, no trailing period, present tense. Say what changed and why
  it matters, not which files moved.

```
feat(audit): classify workflow verbs against the published action catalogue (ABC-123)
fix: a clause that matches nothing can be seeked, so explaining a query does not panic
refactor(batchload)!: drop bufferDepth - the knob measured no gain
```

The body carries the ticket key and the reasoning. Attribution trailers are per repository -
check the log (`references/detect.md`).

## Branches

```
<type>/<TICKET>-<short-slug>
```

Same types as commits, so `feat/ABC-123-outbound-digest`, `fix/logging-standard-stream-sync`,
`chore/config-staging-defaults`, `release/audit-no-authn`. Drop the ticket segment where the
work has no ticket.

A branch opened by an agent is prefixed so a reviewer knows to read it a little harder.

Trunk-based or a long-lived `develop` is the project's choice. What is not optional: work
arrives through a pull request, and the gates in `references/gates.md` run before it merges.

## Naming repositories and services

In a platform made of several services, the shape is `<product>-<domain>-service`, with
supporting repositories named the same way - `<product>-common` for shared code,
`<product>-web`, `<product>-platform-iac` for infrastructure, `<product>-integration-test`.

Pick domains that are bounded contexts - customer, portfolio, identity, messaging, reporting -
not layers. A repository named for a layer collects everything and belongs to nobody.

## The task runner is the interface

Every repository can be driven without reading its source. Whichever runner it uses, it offers
at minimum:

```
help              list every target
test              unit tests
test-integration  integration, taking ENV=
test-e2e          end to end, taking ENV=
test-all          all three, stopping at the first failure
build             produce the artifact
fmt / lint        format and lint
```

Targets are self-documenting - in a Makefile, a `##` comment after the target, so `make help`
prints the list. What a developer runs and what CI runs is the same target, always. The moment
CI needs its own invocation, the two drift, and "it passes locally" starts happening.

## Repository furniture

A new repository starts with:

| File | For |
| :-- | :-- |
| `README.md` | what this is, how to run it, how to test it |
| `CLAUDE.md` or `AGENTS.md` | what an agent needs to know that is not obvious |
| `CONTEXT.md` | the domain's vocabulary |
| `docs/adr/` | decisions, from the first one |
| `.env.example` | every variable, with safe examples and no secrets |
| the CI workflow | the pull request gate, from the first commit |

Starting with the gate is much easier than adding it to a repository that has grown without one.

## Language

Code, comments, commits, documentation in the repository: English. Conversation with the team and
customer-facing documents follow the customer, and technical terms stay in English inside Thai
text. Customer-facing wording belongs to the document house style, not here.
