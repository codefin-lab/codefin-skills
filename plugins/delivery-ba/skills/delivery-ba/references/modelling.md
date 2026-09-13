# What to draw, and when not to

A diagram earns its place when it shows something a paragraph cannot: a shape, an order, a
relationship, a boundary. Drawn out of habit, it is decoration that has to be maintained.

| Question the reader has | Draw |
| :-- | :-- |
| how does this work today, and what changes | as-is and to-be process, side by side |
| who does what, and where does it wait | swimlane across the roles involved |
| what talks to what, and across which boundary | context or integration diagram |
| in what order, and what is synchronous | sequence diagram |
| what may each role do | an access matrix - a table, not a picture |
| what are the things, and how do they relate | entity or data model |
| what states can this be in, and what moves it | state diagram |

**The access matrix is the one people skip and then miss.** Capability down the side, role
across the top, and a mark in each cell. It is quick, it exposes gaps the prose hid, and QA
turns it straight into scenarios. If the product has roles at all, it needs this table.

## Rules

- **Model the thing that is hard, not the thing that is easy to draw.** If a step is obvious in
  a sentence, leave it as a sentence.
- **One question per diagram.** A picture answering three questions answers none of them well.
- **As-is only where it is changing.** Documenting a process nobody will touch is effort spent
  on something that will be stale and unread.
- **Name things the way the customer names them.** A diagram using our vocabulary rather than
  theirs will be nodded at and not read.
- **Every diagram is maintained or deleted.** A to-be diagram that no longer matches the agreed
  to-be is worse than none, because people trust it.

The drawing itself is not this skill's business - use whichever diagram skill the project has,
in the house style. This page is only about deciding what deserves to be drawn.
