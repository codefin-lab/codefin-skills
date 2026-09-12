# Holding the line

A scope line only works if it is drawn before anyone needs it. Drawn afterwards, in the middle
of an argument, it reads as an excuse - and the customer is right to hear it that way.

## The line

> Anything not written in the scope section is out of scope, and changing it is a change request.

Said once at the start, in the document the customer signs, this is a normal working
arrangement. Said for the first time in week nine, it sounds like a refusal.

## Defect or change request

The same line settles what a customer's complaint is, which is worth deciding **in writing,
early**, because arguing about it after a fix has been attempted is a large share of why work
gets reopened.

| | |
| :-- | :-- |
| **Defect** | the code contradicts the document. Ours to fix, at our cost. |
| **CR** | the document is wrong, silent, or never covered this case. Quoted, agreed, then built. |

Two things make this survivable as a relationship rather than a fight:

- **Decide it quickly and say so plainly**, with the clause quoted. A slow answer looks evasive
  even when it is right.
- **Do not win every one.** Where the document was ambiguous, say it was ambiguous. A CR argued
  from a clause that genuinely could be read two ways costs more in trust than it recovers in
  fees, and the fix is to write the next clause better.

A customer report that turns out to be a CR still gets logged, assessed and answered. "That's a
CR" is the beginning of a response, not the whole of it.

## Working a change request

1. **Understand it as a need, not as the solution offered.** Customers usually ask for a
   mechanism; the requirement is the outcome behind it. The cheaper answer is often available
   once you know what they are actually trying to achieve.
2. **Assess the impact before quoting.** What else does this touch - other requirements, work
   already built, work in flight, the test suite, migration, documents already issued? The
   engineering side of this question has a procedure and a tool in the `codefin-dev` skill; ask
   for it rather than estimating blind.
3. **Amend the document first.** New or changed requirement, new acceptance criteria, new
   identifier, and the exclusions updated if the boundary moved. Only then does the work change.
4. **Quote it** - see `references/sizing.md` - including the effect on the timeline, which is
   what the customer actually cares about and what is most often left out.
5. **Get it agreed in writing** before it is built. A CR built on a verbal yes is unbilled work
   that also broke the scope line for every future CR.

## When scope creeps without a CR

It rarely arrives as a request. It arrives as "while you're in there", as a screenshot in a
chat, as a small extra field. The habit that works is boring and reliable: **every change to
what the system does becomes a written item, even the ones you agree to do for free.** Doing it
for free is a decision the BA can make; doing it invisibly is how a project ends up thirty
undocumented changes past its scope with no record of where the time went.

## Phasing is the kind answer

When something genuinely needed did not make the scope, the useful reply is rarely no. It is
which phase, at what cost, and what it displaces if it comes forward. That keeps the line intact
and still moves the customer's problem toward a solution.
