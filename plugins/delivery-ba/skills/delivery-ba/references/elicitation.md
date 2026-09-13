# Getting the answer, not the opinion

Requirements gathering fails in a predictable way: everyone is agreeable in the room, the notes
read well, and six weeks later two people remember the same sentence differently. The cure is to
leave every session with **decisions written down**, not with understanding.

## Written rounds beat one long meeting

Send a numbered question set, get written answers, then meet only about the answers that
conflict or that nobody could answer. It looks slower and is not:

- a written answer can be quoted back in the document; a remembered one cannot
- numbered questions make the unanswered ones visible, instead of lost
- the customer can route each question to the person who actually knows
- a second round is cheap, and the second round is where the real constraints surface

Keep the numbering stable across rounds - question 14 stays question 14 - so an answer can be
cited later without ambiguity.

## Ask questions that force a decision

| Weak | Forces a decision |
| :-- | :-- |
| Do you need reporting? | Which three reports must exist at go-live, and who reads each one? |
| Should there be an approval step? | Who may approve, up to what amount, and what happens above it? |
| Is performance important? | How long may this take before a user complains, and how many run at once at peak? |
| Any integrations? | Which system is the source of truth for customer data, and how do we read from it? |

A question that can be answered "yes" tells you nothing. A question that names the thing to
choose, or asks for a number, produces a requirement.

## Watch for the soft answer

"Probably yes", "we'd like to", "ideally", "nice to have", "we'll see how it goes" - these are
not answers, and they are the raw material of scope disputes. Treat every one as an open item
and close it explicitly, in one of three ways:

1. **In scope**, with the detail that makes it buildable
2. **Out of scope** for this phase, written in the exclusions so nobody is surprised
3. **To be confirmed by a date**, with the consequence of missing that date stated

Never let a soft answer pass into the document as though it were settled. If a decision truly
cannot be made yet, that is an assumption - see below.

## Assumptions are a contract, not a disclaimer

Write each assumption with **what happens if it turns out to be false**. An assumption with no
stated consequence is decoration; one with a consequence is a risk everybody has agreed to.

> We assume the customer master is available over the existing API with no schema change. If a
> change is needed, integration work is added and the timeline moves by the elapsed time of the
> customer's change process.

## Three questions people forget, and regret

- **Who are the users, and what may each of them do?** Roles drive an access matrix, and an
  access matrix drives a large share of the test scenarios. Ask early; retrofitting roles is
  expensive.
- **What data exists on day one?** Migration, seeding and reference data are usually discovered
  late and always take longer than expected.
- **What already exists that this must live alongside?** A system of record that stays, a report
  that must keep working, a batch window that cannot move.

## Close every session the same way

Within a day, send back: decisions made, open items with owners and dates, and what you will
write into the document. Ask for correction rather than approval - people correct more readily
than they approve, and a correction is what you actually need.
