# Tools, per language

The only file in this skill that names specific tools. Everything else describes the shape the
gates take; this says what sits behind the four commands in each language Codefin writes.

These are starting points, not mandates. A repository that already made a different choice keeps
it (`references/detect.md`).

## Go

Typical for GraphQL microservices.

| | |
| :-- | :-- |
| unit | `go test -race ./...` - the race detector is not optional |
| coverage | `-coverprofile=coverage.txt -covermode=atomic`, then `go tool cover` |
| lint | `golangci-lint run`, plus `go vet` |
| format | `gofmt`, or `gofumpt` where the repo has chosen it |
| integration | the service against a real database and queue, brought up by compose |
| blast radius | `gopls` references; interface implementations matter as much as direct callers |

Table-driven tests are the idiom: a slice of named cases, one loop, `t.Run(tc.name, ...)`.
Substitute at the interface the code already defines - the repository or port - rather than
mocking every call.

Services generated from a GraphQL boilerplate also need the generated code regenerated before
tests when the schema changed, and the schema itself checked against the federated supergraph.
That schema check is a contract gate in the sense of `references/gates.md`: it is what catches a
field removed here breaking a query over there.

Note for these repositories: the boilerplate ships `test/` containing only a `.gitkeep`, so a
freshly generated service has no tests and no test job. The first defect fixed in one is the
moment to add both (`references/defects.md`, step 9).

## TypeScript and Node

Web front ends, and often the cross-service test suites.

| | |
| :-- | :-- |
| unit | `vitest` or `jest`, whichever the repo has |
| lint and format | whatever is configured - `oxlint` and `oxfmt` in some Codefin repos, ESLint and Prettier in others. Never add a second one. |
| integration | `@cucumber/cucumber` with feature files, as the platform integration suites do, with per-environment configuration selected by `ENV` |
| e2e | Playwright, with page objects rather than selectors scattered through specs |
| blast radius | the TypeScript language service's find-references; check whether the symbol is exported from the package's public entry point |

A workable shape for a cross-service suite: run it inside one container image so every machine
agrees, and read a `config-<env>.yaml` per environment, covering database assertions, chained
authenticated HTTP calls, and file transfer. Follow the shape a project already has rather than
starting a second one.

For Playwright, keep the trace and screenshot on failure - an e2e failure nobody can diagnose
gets marked flaky and ignored.

## Python

Batch, scheduling, orchestration, data work.

| | |
| :-- | :-- |
| unit | `pytest`, with `pytest.mark.parametrize` for table-driven cases |
| lint and format | `ruff` |
| types | `mypy` where the repo has adopted it |
| integration | `pytest` against real dependencies, marked so `make test` can exclude them |
| blast radius | grep is weak here - check what imports the module, and for Airflow, which DAGs reference the task or connection |

Mark integration cases (`@pytest.mark.integration`) so the unit target can exclude them by
marker. Without that the fast target stops being fast and people stop running it.

For Airflow, a DAG that imports cleanly is not a DAG that works: test the callables directly,
and keep DAG-level checks (imports, no cycles, required tags) as their own fast suite.

## Rust

Systems work, and search in particular.

| | |
| :-- | :-- |
| unit | `cargo test`, or `cargo nextest run` where it is set up |
| lint | `cargo clippy -- -D warnings` |
| format | `cargo fmt --check` |
| integration | `tests/` at crate root, plus the engine's own conformance suites |
| blast radius | `rust-analyzer` references; a change to a public item in a library crate reaches every dependent crate |

A conformance suite often needs its node started with a specific environment. Where a repository
documents how its suite must be launched, follow it exactly - started another way the numbers
move, and the run is worthless.

## Dart and Flutter

Mobile apps and embedded micro apps.

| | |
| :-- | :-- |
| unit and widget | `flutter test` |
| lint | `flutter analyze` |
| format | `dart format` |
| e2e | `integration_test` on a real device or simulator |
| blast radius | a shared widget or theme token reaches every screen that uses it - search the widget's constructor |

Widget tests sit between unit and integration: they are fast and hermetic, so run them in
`make test`. Real-device runs belong to `make test-e2e`.

## Terraform

Infrastructure.

| | |
| :-- | :-- |
| unit | `terraform validate`, `terraform fmt -check`, `tflint` |
| integration | `terraform plan` against a real backend, reviewed as part of the pull request |
| blast radius | a module change reaches every environment that sources it - check each `.tfvars` |

The plan output is the test. Never apply from a developer machine what has not been planned and
read in a pull request, and never apply before a change has been verified locally
(`SKILL.md`).
