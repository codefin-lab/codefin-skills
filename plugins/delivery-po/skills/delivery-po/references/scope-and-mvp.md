# In, out, and the smallest thing that proves it

## Out of scope is a section, not a footnote

Write the exclusions as deliberately as the inclusions. They are what everybody reads at
delivery, and anything not written there is arguable by a reasonable person.

Name the things people will assume are included even though nobody said so: other channels,
other roles, migrating old data, reports beyond the listed ones, languages, environments,
support after go-live, and anything the previous system did that this one will not.

*Client work*: this section is the one that keeps the relationship intact when a change request
appears. Said at the start it is a normal working arrangement; said for the first time in week
nine it sounds like a refusal, however true it is.

## The minimum is the smallest thing that settles a question

An MVP is not "the cheap version" and not "phase one". It is the smallest thing that would
**change what you do next** - by proving the value is there, or by proving it is not.

The test: if this shipped and nobody used it, would you know what to do? If the answer is no,
the thing being built is too big to learn from, or the goal behind it was never checkable.

What makes a minimum smaller, in order of how often it works:

1. **Fewer cases, not less quality.** One customer segment, one product type, one channel -
   done properly. Shipping everything half-built teaches you nothing except that half-built
   software is unpopular.
2. **Manual where automatic is expensive.** A person doing a step by hand for the first month
   is often a quarter of the cost and answers the same question.
3. **Later, not never.** Deferring is honest; pretending the deferred thing was never wanted is
   how a backlog stops being believed.

*Client work*: a minimum is harder here, because the scope is contracted and the customer paid
for all of it. The equivalent is **sequencing**: agreeing what lands first so the value arrives
before the last milestone, and so the risky part is discovered early rather than at UAT.

## When something is cut, say what was cut and why

A record of what was deferred and for what reason is worth more than it sounds. It stops the
same item being re-argued every cycle, it lets a decision be revisited when the reason changes,
and it is the honest answer when someone asks why the obvious feature is missing.

`templates/scope-decision.md` is one row per decision. It takes a minute and it settles months
of argument.
