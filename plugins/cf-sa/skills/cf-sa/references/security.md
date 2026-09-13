# Security decisions

Not a security audit, and not a substitute for one. This is the handful of decisions that are
architectural - expensive to change later, and usually made by default if nobody makes them
deliberately.

## Decide these, and write them down

- **Who may do what.** The role and permission model, as a matrix of capability against role.
  It comes from the BA's analysis; the mechanism is yours. Enforce it on the server, and treat
  anything the UI hides as a convenience rather than a control.
- **How identity is established**, and how long it lasts. Where sessions or tokens live, what
  revokes them, and what happens on the second device.
- **What is sensitive**, named explicitly. Personal data, credentials, financial detail,
  anything a regulator names. What is encrypted at rest, what is masked in logs, what must never
  leave the country or the account.
- **Who can see production data**, and how access is granted, reviewed and removed. This is the
  control most often absent and most often asked about in an audit.
- **What is audited**, and whether the audit trail can be edited by the people it records.

## Server-side, always

Every rule enforced in the browser is enforced nowhere. The test QA runs is the one that matters:
a user without the role calls the endpoint directly and gets refused **and receives no data** -
a 403 that still returns the payload is a failure that manual testing misses.

Write that test's existence into the register (`cf-qa`, `references/designing-tests.md`,
the role matrix).

## Secrets

Never in the repository, never in a ticket, never in a screenshot. In the platform's secret
store, referenced by name, with a documented way to rotate one and a list of what to rotate when
somebody leaves.

**A secret that reached a repository is compromised even after the file is deleted** - the blob
stays in the history. Rotate it; deleting the file is not a fix.

## Say what you are not doing

A design that quietly omits a control leaves everyone assuming it is there. Say which threats
are in scope and which are not, and get the ones that are out of scope acknowledged rather than
unmentioned.

*Client work*: the customer often has standards of their own - their own review, their own
penetration test, their own hardening baseline. Ask for them before designing, not after: a
requirement discovered at their security review is a redesign, and it lands at the worst
possible point in the schedule.
