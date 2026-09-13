# Acceptance criteria that can be proved

This is the highest-leverage page in the skill. Everything downstream is derived from acceptance
criteria: QA turns each one into a scenario, developers build to it, and a customer complaint is
judged against it. A criterion nobody can check produces an argument at delivery instead of a
result, and that argument is where reopened tickets come from.

## The test

A criterion is testable when you can state **what is set up, what happens, and what is then
true**, with nothing left to opinion. Write it so that two people who dislike each other would
still agree on the outcome.

| Not testable | Testable |
| :-- | :-- |
| the report loads quickly | a 12-month report for an account with 500 holdings renders within 3 seconds on SIT |
| invalid input is handled gracefully | a settlement date in the future leaves the form filled, marks the field, and shows "Settlement date cannot be in the future" |
| the customer sees their portfolio | a customer with no holdings sees the empty state, not an error |
| the system is secure | a user without the Approver role who opens the approval URL directly gets 403 and no data in the response |
| data is synchronised | a holding changed in the source appears in the portfolio within one batch cycle, and the audit log records the change with its source id |

## Words to challenge on sight

quickly, properly, correctly, gracefully, appropriately, as needed, user-friendly, seamless,
efficient, robust, intuitive, relevant, optimal, if necessary, where applicable.

Each one hides a decision that somebody will make differently later - usually a developer at
11pm, and then a customer at UAT. When you catch one, do not delete it: ask the question it was
concealing. "Quickly" becomes "how long is too long?", and the answer is the criterion.

## Numbers need an anchor

A threshold with no conditions attached is not testable either, because it can be met or missed
depending on circumstances nobody wrote down. "Within 3 seconds" needs to say: with what data,
on which environment, measured from what to what, and at which percentile if load matters.

`scripts/check-requirements.sh` flags the vague words; only a person catches an unanchored
number.

## Cover the unhappy paths, because they are most of the work

A requirement described only by its success case will be estimated as if the success case were
all of it, and then it will overrun. For each story ask:

- **empty** - nothing there yet, first use, no results
- **invalid** - wrong type, out of range, malformed, too long
- **not permitted** - the right action by the wrong role
- **conflict** - two people doing it at once, or it has already been done
- **unavailable** - the dependency is down, slow, or returns an error
- **partial** - it half worked; what does the user see, and what is the state afterwards

You do not need a criterion for every box. You need to have asked, and to have written the
answer where the answer is not obvious. An explicit "out of scope for this release" is a good
answer; silence is not.

## Non-functional criteria are criteria

Performance, volume, availability, retention, auditability and access control are requirements
like any other, and they follow the same rule. "The system must be highly available" is a wish.
"Planned maintenance excepted, the service is available 99.5% per calendar month, measured at
the API gateway" is a criterion - and it is a criterion somebody has to price, which is the
other reason to write it down.

## Shape

Keep criteria in the requirement's own table, one per row, so each can be cited by number when a
test or a defect refers to it. Write them as statements of fact about the finished system, not
as instructions to the developer: "a customer with no holdings sees the empty state", not
"implement an empty state".

`templates/requirement.md` has the layout.
