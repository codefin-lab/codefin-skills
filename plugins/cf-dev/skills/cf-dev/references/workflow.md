# From the agreement to the release, and who hands what to whom

People on a project disagreeing is rarely disagreement. It is several people working from
different understandings of the same sentence. The cure is that everyone works from the document
the customer also holds, and that the document is edited before the code, never after.

**This page is the one place the roles are defined.** Every other skill points here rather than
restating it, so there is one answer to who owns what.

## Two modes

Most of this process is written for **client work**: a scope agreed in a document, changes
priced as change requests, a budget in days, a steering committee. That is the common case and
the sharp rules exist because of it.

For **a product of your own**, the same shapes hold with different mechanics: the backlog
replaces the agreed scope, reprioritising replaces the change request, team capacity replaces
the sold budget, and internal stakeholders replace the steering committee. Where a rule differs,
it says so on the spot. Where it says nothing, it applies either way.

## The document comes first

The BRD is the agreement - an FSD where the client uses that name. When anything changes - scope moves, the spec was wrong, a case
nobody thought of turns up - **the document is edited first**, in the house style, and the
code follows. A document updated after the fact is a document that never gets updated, and once
it is stale nobody trusts it, and then everyone is back to three understandings.

This also gives the line that decides what a customer report is:

> **defect**: the code contradicts the document.
> **CR**: the document is wrong, silent, or never covered the case.

## Turning the document into work

The conversion is mechanical, which is the point - there is nothing left to interpret.

1. Each requirement already has an identifier (`US-<epic>.<n>`) and acceptance criteria.
2. **Each acceptance criterion becomes at least one test scenario**, `TS-<n>`, derived by QA and
   citing the `US` it proves. Each scenario becomes test cases at the layer the criterion lives
   at (`references/testing.md`). An AC about a calculation is a
   unit test; one about data surviving a round trip is integration; one about a journey is e2e.
3. Branches and commits carry the ticket key.
4. An AC with no test is unfinished work, and it is visible without anyone auditing anything.

## Acceptance criteria that can be tested

The single most common cause of a late argument is an AC that could never have been checked.
Catch it when the BA writes it, not when QA reaches it.

An AC is testable when you can say what is set up, what happens, and what is then true, with no
word left to opinion.

| Not testable | Testable |
| :-- | :-- |
| the report loads quickly | a 12-month report for an account with 500 holdings renders within 3 seconds on SIT |
| invalid input is handled gracefully | submitting a future settlement date leaves the form filled, marks the field, and shows "Settlement date cannot be in the future" |
| the customer sees their portfolio | a customer with no holdings sees the empty state, not an error |

Words to challenge on sight: quickly, properly, gracefully, correctly, as appropriate,
user-friendly. Each hides a decision somebody will make differently later.

**Send an untestable AC back to the BA before work starts.** It costs a sentence then, and a
reopened ticket later.

## The three handoffs

Short lists, meant to be read in under a minute.

### BA to Dev and QA - ready to start

- the requirement identifier and its acceptance criteria, all testable
- what is explicitly **not** in scope
- which environment it will be verified on
- any decision already taken about how, and why (a link to an ADR if there is one)

### Dev to QA - ready to test

- the environment it is on, and the commit or build
- which acceptance criteria this touches
- **the test results**: which layers ran, how many cases, what passed
- **what else it affects**, from the blast radius work in `references/defects.md`
- what is knowingly not covered yet

### QA to BA - ready to deliver

- every acceptance criterion, with a result against it
- defects still open, with severity
- which tests were added to the permanent suite

## The six roles

What each owns, and - just as important - what each does not. The second column is the one that
prevents the arguments, because most of them are somebody answering a question that was not
theirs.

| Role | Owns | Does not own |
| :-- | :-- | :-- |
| **PO** | product goal and value, scope, priority, MVP, backlog order, accepting or rejecting the outcome | technical design, the project schedule |
| **BA** | requirement analysis, business rules, use cases, workflow, edge cases, functional and non-functional requirements, acceptance criteria | priority, architecture |
| **SA** | architecture, component, API and data design, how a non-functional requirement is met, integration, security, technical trade-offs | business priority |
| **Dev** | implementation, unit tests, technical breakdown and the detailed estimate | product priority |
| **QA** | test strategy and cases, traceability, verification, regression | product scope decisions |
| **PM** | delivery plan, milestones, dependencies, resources, coordinating estimates, risks and issues, progress | product requirements, architecture |

One person often holds several of these - a BA who is also the product owner, a lead who is also
the architect. **That is a staffing question, not a change to who owns what.** Write down who is
wearing which hat, because the failure mode is everyone assuming somebody else was.

*Client work*: the product owner is frequently on the customer's side. Name who plays the role
on our side and what they may decide without asking, or every priority question becomes a
week-long email thread.

## Who decides what

Most stand-offs dissolve once this is said out loud.

| Question | Whose call |
| :-- | :-- |
| is it worth doing, in what order, what is the MVP, do we accept this | PO |
| what exactly is needed, what are the rules, what are the acceptance criteria | BA |
| what shape do we build it in, what do we trade against what | SA |
| how is it written, how does it break down, how long does it take | Dev |
| has it been proven, and is the evidence good enough | QA |
| when, at what cost, what gets cut, do we ship | PM |

Three decisions get confused constantly and are not the same:

- **QA decides it is proved.** Evidence, not opinion about whether the behaviour is desirable.
- **The PO decides it is accepted.** Against the acceptance criteria - something can be proved
  to work and still not be what was wanted.
- **The PM decides it ships.** Sometimes against QA's recommendation, which is legitimate and
  is recorded (`cf-pm`).

The BA does not decide how a thing is implemented. Dev does not decide that an acceptance
criterion is unimportant. The SA does not decide what is worth building. When the answer is
genuinely contested, it goes back to the document, and the document is amended or it is not.

## Through a release

- work is derived from the document, and each AC has its tests
- the pull request gate runs unit and build (`references/gates.md`)
- deploy to staging, then integration against what was deployed
- e2e before release
- what was decided along the way lands in `docs/adr/` (`references/knowledge.md`)
- anything the customer receives - the release note, the closing note on a defect - is written
  in the document house style and in customer-facing language
