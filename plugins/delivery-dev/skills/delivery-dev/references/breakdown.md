# Breaking work down, and estimating it properly

The BA sized the work roughly, before anything was designed, so the price could be set and the
PO could order it (`delivery-ba`, `references/sizing.md`). **This is the second estimate**: made
after the shape is known, by the people who will write it.

The PM coordinates the two and owns the budget either implies (`delivery-pm`).

## Break it down until each piece is a day or two

Not because small pieces are virtuous, but because an estimate stops being a guess at about that
size. "Build the statement screen" is unestimatable; "render the line list from the existing
endpoint", "handle the empty period", "add the totals row" are not.

Breaking down is also how the work nobody remembered gets found. Each piece asks: what does this
need that does not exist yet?

## Count everything, not just the typing

The estimate that only covers writing the happy path is the most common cause of an overrun, and
it is always about a third of the real number. For each piece, count:

- the unhappy paths - empty, invalid, not permitted, conflicting, unavailable, partial
- the tests, at whatever layer they belong to (`references/testing.md`)
- the migration, seed or fixture the thing needs to be exercised at all
- reviewing, and fixing what review and testing find
- anything shared that has to change, and everything that depends on it
  (`references/defects.md`, the blast radius step)

That last one is why breaking down happens **after** the architecture is understood. A piece
that turns out to touch a shared module is not the same size as one that does not.

## Say what you are not sure about

A piece you cannot estimate is information, not failure. Say which piece, why, and what would
resolve it - usually an hour of investigation, which is itself an estimate.

Where a range is wide, give the range and name the unknown. Quoting the midpoint and saying
nothing converts a known risk into an invisible one, and the PM cannot manage what they cannot
see.

## When it disagrees with the rough estimate

It often will, and the detailed one is better informed. Say so at the time, with what the rough
estimate missed - the integration that turned out to be three calls, the shared component that
has to change.

**Defending the first figure because it was quoted is how a project commits to something nobody
believes.** Raise it while there is time to act: to cut scope, to reprioritise, or to tell the
customer. The worst version is a team privately knowing the number is wrong and working weekends
to protect it.
