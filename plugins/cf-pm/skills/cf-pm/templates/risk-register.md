# Risk register - <project>

Reviewed every <cadence>. An entry whose numbers never move is not being read.

| # | Risk | Likelihood | Impact | Consequence (days) | Owner | Mitigation | Contingency | Closes when | Status |
| :-- | :-- | :-- | :-- | --: | :-- | :-- | :-- | :-- | :-- |
| 1 | The customer's API cannot filter by date, so we build it ourselves | Medium | High | 8 | <name> | a real call against their sandbox this week | build our own filter, 8 days, from the contingency | the first successful filtered call | open |
| 2 | Test data for UAT is not ready | High | High | 10 | <name, customer side> | weekly check, named owner on their side | UAT slips a week, agreed at steering | data loaded on SIT | open |

**Every entry needs**: a risk that says what might happen rather than naming a topic, a
consequence in days so it can be weighed, a person as owner, and a date or event that closes it.

**Register these before anything exotic** — they are the ones that land: a dependency on the
customer, a requirement whose acceptance criteria are still vague at the point work starts, an
integration nobody has connected to yet, one person who knows something nobody else does, an
environment that does not exist yet, a stakeholder who has not been in the room but will have
opinions at UAT.

## Landed

Entries are never deleted. A risk that happened stays as the record of what was foreseen and
what was decided.

| # | Risk | What happened | What it cost | What we did |
| :-- | :-- | :-- | --: | :-- |
