# The risk register

Most risk registers are written once to satisfy a document template and never opened again. That
register is worse than none: it consumes the effort of writing and provides none of the benefit,
while letting everyone believe risk is managed.

A live register has three properties. Every entry has **an owner who is a person**, **a
consequence stated in days or money**, and **a date by which it stops being a risk** - either
because it happened, or because it can no longer happen.

## Writing an entry that is worth reading

| Field | The test |
| :-- | :-- |
| Risk | states what might happen, not a topic. "Integration" is a topic; "the customer's API does not support filtering by date, so we build it ourselves" is a risk |
| Likelihood, impact | your honest guess; the point is the ranking, not the arithmetic |
| Consequence | in days or money, because "high impact" cannot be compared with anything |
| Owner | a person. A risk owned by "the team" is owned by nobody |
| Mitigation | what reduces the chance, being done now, by that owner |
| Contingency | what happens if it lands anyway, decided before it lands |
| Closes when | the date or event that resolves it |

An entry failing the consequence test is the usual one: without days attached, a risk cannot be
weighed against the cost of preventing it, and everything looks equally worth worrying about.

## What actually goes wrong on client projects

Register these before looking for anything exotic, because these are the ones that land:

- **A dependency on the customer** - test data, an access, a decision, a sign-off from one
  person who is also busy. The most common cause of slippage, and the one least often written
  down because it feels impolite.
- **A requirement whose acceptance criteria are still vague** at the point work starts. It will
  be rewritten during UAT, and the rework was not estimated.
- **An integration nobody has connected to yet.** Until a real call has been made to a real
  endpoint, the estimate is fiction.
- **One person who knows something nobody else does**, in a project with a fixed date.
- **An environment that does not exist yet** for a phase that needs it.
- **A customer stakeholder who has not been in the room** but will have opinions at UAT.

## Keeping it alive

Review it in the same meeting every week, and make the review short by being ruthless: close
what can no longer happen, raise what has become likely, and change the numbers that have moved.

**A register whose entries never change is not being read.** If nothing moved in a month, either
the project is remarkably calm or the register is decoration - and the second is far more likely.

When a risk lands, the entry does not get deleted. It becomes the record of what was foreseen
and what was decided, which is what makes the next project's register credible and the
conversation with the customer a reference rather than an argument.
