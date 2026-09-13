# APIs, schemas and data

## Anything published is a contract

The moment something else depends on a shape you expose - an API, a database schema another
service reads, a shared library's public surface, an event on a queue, a file format - changing
it is somebody else's incident.

This is not a reason to freeze. It is a reason to know **who depends on it before you change
it**, which is a procedure and a tool in `delivery-dev`, `references/defects.md` (the blast
radius step). Use it at design time, not only when fixing something.

## Design the interface before the implementation

An interface designed outward from the implementation leaks it: the caller ends up knowing
which table the data is in and what the internal states are called. An interface designed from
the caller's need survives the implementation being replaced, which it will be.

Ask what the caller is trying to achieve, not what they will fetch. The difference shows up as
one call instead of four, and as fields named in the domain's words rather than the database's.

## Names come from the domain

Use the words the business uses - the ones in the BA's `CONTEXT.md`. When the code, the API and
the conversation use three names for the same thing, every discussion pays a translation tax and
some of the translations will be wrong.

Where the domain's word is genuinely ambiguous, fix the word with the BA rather than inventing a
private one.

## Versioning, before the first consumer

Decide how a breaking change will be handled **before there is anyone to break**. Afterwards the
options are all bad.

The choices worth making explicit: whether additive changes are allowed without a version bump
(usually yes, and then adding a required field is not additive), how long an old version is
supported, and how a consumer is told. Write it in an ADR; it is exactly the kind of decision
someone reasonable would guess differently about.

## Data outlives everything

Code is rewritten, data is migrated - and migration is where the real cost of a data model
shows up. Spend disproportionate care here.

The questions that come back later: what is the identity of this thing and can it change; what
happens to a record when it is deleted; do we need history, or only the current state; what is
the retention period and who decided it; when two systems both hold this, which one is right.

That last one settles more arguments than any other architectural decision. Write down the
system of record for each significant entity, and where a copy exists, write down that it is a
copy.
