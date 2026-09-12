# From the agreement to the release, and who hands what to whom

The BA, QA and Dev disagreeing is rarely disagreement. It is three people working from three
different understandings of the same sentence. At Codefin the BA is also the product owner, so
one person holds both what was agreed and what it is worth - which removes a seam, and puts all
the more weight on the document being right. The cure is that everyone works from the document
the customer also holds, and that the document is edited before the code, never after.

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

## Who decides what

Most stand-offs dissolve once this is said out loud.

| Question | Whose call |
| :-- | :-- |
| is this what the customer agreed to, and is it worth doing | BA |
| has it been proven, and is the evidence good enough | QA |
| how it is built or repaired | Dev |

QA does not decide whether a behaviour is desirable; they decide whether the claim is proven.
The BA does not decide how a thing is implemented. Dev does not decide that an AC is
unimportant.
When the answer is genuinely contested, it goes back to the document, and the document is
amended or it is not.

## Through a release

- work is derived from the document, and each AC has its tests
- the pull request gate runs unit and build (`references/gates.md`)
- deploy to staging, then integration against what was deployed
- e2e before release
- what was decided along the way lands in `docs/adr/` (`references/knowledge.md`)
- anything the customer receives - the release note, the closing note on a defect - is written
  in the document house style and in customer-facing language
