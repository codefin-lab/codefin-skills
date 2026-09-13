## US-<epic>.<n> - <the story, in one line>

**As a** <role> **I** <do something> **so that** <the reason it matters>.

| | |
| :-- | :-- |
| Objective | `OBJ-<n>` |
| Priority | Must / Should / Could / Won't |
| Release | <phase> |
| Source | <question number, answer, or meeting> |

### Acceptance criteria

Each row is citable by number, states a fact about the finished system, and leaves nothing to
opinion. Not "implement X" - "X is true".

| # | Given | When | Then |
| :-- | :-- | :-- | :-- |
| 1 | an account with no holdings | the portfolio page opens | the empty state is shown, and no error |
| 2 | 500 pending items on SIT | the queue opens | the first page renders within 3 seconds |
| 3 | a user without the Approver role | the approval URL is opened directly | the response is 403 and carries no data |

### Considered and excluded

The unhappy paths that were asked about and deliberately left out, so nobody has to wonder
whether they were forgotten:

- <case> - out of scope this phase, because <reason>
