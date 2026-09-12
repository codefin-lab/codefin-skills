# Structuring what was agreed

Codefin's document conventions already fix the tables and identifiers. This is about arriving at
content worth putting in them.

## The identifiers

| Id | What it numbers |
| :-- | :-- |
| `BR-<n>` | a business requirement - what the business needs, in its own language |
| `US-<epic>.<n>` | a user story under an epic, carrying acceptance criteria |
| `OBJ-<n>` | a business objective, with the measure that says it was met |
| `CR-<n>` | a change request against an agreed scope |

Every story links to an objective. A story that links to none is either missing its reason or
does not belong in this release - both worth knowing before it is built, not after.

Priority is MoSCoW, and it has to mean something: if everything is Must, nothing is. Force the
question by asking what the customer would ship without if the date could not move.

## Epics that hold together

An epic is a coherent area of the product, not a phase and not a team. "Customer onboarding" is
an epic; "Sprint 2" and "Backend" are not. The test: someone who knows the business should be
able to guess what is in an epic from its name, and a story should have exactly one obvious home.

Keep an epic map - epic, name, the system it touches, how many requirements, which release - so
the shape of the work is visible on one page. It is also the first thing a reviewer reads.

## Writing a story people can build from

State who, what and why:

> As an operations officer, I approve a withdrawal above my limit by escalating it, so that
> large withdrawals always get a second pair of eyes.

The "so that" is the part people skip, and it is the part that lets a developer or a QA make a
sensible call when the description turns out to be incomplete - which it will.

Below the story, the acceptance criteria. Above it, the link to the objective. Beside it, the
release. That is the whole unit: it should be readable on its own, because that is how it will
be read.

## Out of scope is a section, not a footnote

Write what is **not** included as deliberately as what is. The exclusions section is the one the
customer reads at delivery, and everything not written there is arguable. Name the things people
will assume are included: other channels, other roles, migration of old data, reports beyond the
listed ones, languages, environments, support after go-live.

## Every requirement needs a trail

Where a requirement came from - which question, which answer, which meeting - is worth a
reference. When somebody challenges it eighteen months later, that reference ends the discussion
in a minute instead of a week.

## Check the copy that counts

A BRD usually exists in more than one form: a draft in markdown, a `.docx` in review, a PDF that
went to the customer. **The one the customer holds is the one that matters**, and it is the one
to check - a fix made in the draft after the PDF was issued has not reached anybody.

`scripts/check-requirements.sh` reads all of those formats for exactly that reason. When it
cannot read a file it says so and fails, rather than reporting nothing found, because those two
outcomes look identical in a report and mean opposite things.

**Reading and amending are not the same file.** You read whichever copy is authoritative,
including a `.docx` or a PDF. You amend **the source it was built from**, and then re-issue -
never by editing the binary, and never by quietly editing a draft that is not what went out.

- If the document is built from markdown, amend the markdown and rebuild through whichever skill
  owns the document house style.
- If the `.docx` itself is the source, the amendment is a document edit, not an agent edit. Say
  what needs to change, in the words that should appear, and let it be made where the document
  lives.
- Either way the version and change-control entries move too, or the next reader cannot tell
  which copy they are holding.

An agent that edits a draft while the issued PDF stays wrong has made the problem worse: now two
copies disagree and both look current.
