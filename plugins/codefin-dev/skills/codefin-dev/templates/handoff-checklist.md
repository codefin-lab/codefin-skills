# Handoff checklists

Three short lists. Each should be readable in under a minute - if one grows past that, it has
stopped being a handoff and become a process.

## PO to Dev and QA - ready to start

- [ ] requirement identifier `US-<epic>.<n>` and its acceptance criteria
- [ ] **every criterion is testable** - no "quickly", "properly", "gracefully", "as appropriate"
- [ ] what is explicitly not in scope
- [ ] the environment it will be verified on
- [ ] any decision already made about how, and why (link the ADR)

An untestable criterion comes back now, not at QA.

## Dev to QA - ready to test

- [ ] environment, and the commit or build
- [ ] which acceptance criteria this touches
- [ ] test results: layers run, cases, passed
- [ ] what else it affects, from the blast radius check
- [ ] what is knowingly not covered yet

## QA to PO - ready to deliver

- [ ] every acceptance criterion has a result against it
- [ ] open defects listed with severity
- [ ] tests added to the permanent suite, by name
