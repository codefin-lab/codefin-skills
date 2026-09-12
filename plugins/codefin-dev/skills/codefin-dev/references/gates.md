# Making the tests block

A test that runs when someone remembers is not a gate. This file is about where each layer
attaches so that it stops bad work on its own.

A pipeline that carries a change from push to deploy with no test job in between is common, and
fixing it is not a project: it is a few jobs added carefully to a pipeline that already works.

## Where each layer attaches

| Point | What runs | Blocks what |
| :-- | :-- | :-- |
| before commit, locally | format, static check, lint | the commit |
| pull request | `make test`, a build, and a check of any contract the repo publishes | the merge |
| after deploy to staging | `make test-integration ENV=<env>` against what was just deployed | the release, and it tells you fast |
| before release | `make test-e2e ENV=<env>` | the release |

The local hooks matter more than they look: they keep CI for things only CI can catch. If the
repository has a hook directory already, add to it rather than inventing a parallel mechanism.

## Adding a gate to a pipeline that already works

The mistake is to replace a working deploy pipeline with a better one. Add instead:

1. Add a test job that runs the same `make test` a developer runs. No special invocation in CI -
   if CI needs different arguments, the target is wrong, and it will drift.
2. Make the existing deploy job wait on it. It becomes a dependency, not a rewrite.
3. If the pipeline already detects which components changed, reuse that to decide what to test.
   Do not build a second mechanism for the same question.
4. Run on the runners the project already has.

Integration tests attach after the deploy job, against the environment just deployed, and their
failure is what tells you the deployment is bad. If the integration suite lives in its own
repository, the deploy pipeline triggers it and waits for the result, rather than someone
running it by hand later and finding out on Friday.

## Coverage

**Start by forbidding a decrease against the base branch. Do not set a target number yet.**

Most Codefin services start from zero or near it. A rule saying 80% on a service at 4% does not
raise quality, it gets the check disabled within a week, and then nothing is measured at all.
"Not lower than the branch you came from" is enforceable from day one, is never unfair to the
person who happens to touch a neglected file, and ratchets upward on its own because every
defect adds a test.

Set a floor later, per repository, once the number has climbed on its own and the team can say
what it should be.

## Contract checks

Where a repository publishes something others consume - a schema, an API description, a shared
library's public surface - the pull request checks that the thing still composes and that
consumers still fit. This is the cheap half of the blast radius work in `references/defects.md`:
it lets the machine catch the class of break that unit tests are blind to, every time, instead
of relying on the author to have looked.

## Flaky tests

A test that fails intermittently is worse than no test: it teaches the team to re-run the build
until it is green, and that habit is what lets a real failure through. Quarantine it the day it
is noticed, raise it as its own defect record, and fix or delete it. Never leave a known-flaky
test in a blocking gate, and never make re-running a red build the normal way to get it green.

## Reporting

Whether a gate ran in CI or you ran it yourself, the report says what ran and what it found -
which layers, how many cases, how many passed, what was skipped and why.

For a round of fixes, the report also carries the defects found and fixed, the running tally
across rounds, and how many P0, P1 and P2 remain open.
