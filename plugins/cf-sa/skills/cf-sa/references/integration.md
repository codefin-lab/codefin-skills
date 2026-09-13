# Connecting to something you do not control

Integration is where estimates go wrong, because the unknown lives on the other side of a
boundary and nobody can see it from here.

## Make one real call before estimating

Until a real request has reached the real system - not a document about it, not a sandbox that
mocks it - the estimate is fiction and so is the plan resting on it.

Do this in the first days. It is the single highest-value thing to sequence early, because it
turns the largest unknown into either a fact or a risk with a number attached.

What the first call usually teaches, none of it in the documentation: the authentication is not
what was described, an "optional" field is required, the response shape differs from the spec,
the sandbox is down more than it is up, and the rate limit is lower than anyone said.

## Assume it will be unavailable, slow, and wrong

Design for all three from the start; retrofitting them is far more expensive than building them.

- **Unavailable**: what does the user see, and what state is left behind? Decide between failing,
  queueing, degrading and serving something stale. This is a product decision as much as a
  technical one - ask the PO rather than choosing quietly.
- **Slow**: a timeout that is shorter than the caller's patience, and a retry that cannot make
  things worse. Which means the operation is idempotent, or the retry is not safe.
- **Wrong**: data that violates its own contract arrives eventually. Decide whether to reject it
  loudly or accept it and flag it, and make sure somebody sees what was flagged.

## Own the boundary

Wrap the other system behind an interface of your own. Not ceremony - it is what lets you test
without them, swap them out, and keep their vocabulary from spreading through your code.

The test: how many files know the other system's field names? If the answer is more than the
adapter, their next change is your whole-codebase change.

## Write down what was agreed with them

Which endpoints, which fields, what the identifiers mean, who is the system of record, how
errors are signalled, what the rate limits are, and who to call when it breaks. In a document
both sides have seen.

*Client work*: this often means the customer's other vendor, who has no contract with you and no
reason to prioritise your questions. Route those through the customer, register the dependency
with a date and a consequence (`cf-pm`, `references/risk.md`), and expect it to be the
thing that slips.
