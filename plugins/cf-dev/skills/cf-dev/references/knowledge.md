# Where a project's knowledge lives

One rule decides it:

> **Knowledge that can go stale without anyone noticing has to live where a pull request will
> catch it.**

Anything in a wiki decays quietly, because nothing forces a reader to notice it is wrong.
Anything in the repository is reviewed whenever the code beside it changes. So the split is not
about neatness, it is about which facts are allowed to rot.

| Knowledge | Where |
| :-- | :-- |
| what was agreed with the customer, and the acceptance criteria | the BRD or FSD, versioned |
| **why it was built this way** | `docs/adr/` in the repository |
| the domain's vocabulary, and how the system is put together | `CONTEXT.md`, `ARCHITECTURE.md` in the repository, changed in the same pull request as the code |
| instructions for agents working here | `CLAUDE.md` or `AGENTS.md` in the repository |
| runbooks, environments, who to contact, how the team works | the team wiki |

## Decision records earn their keep

Of everything on that list, ADRs pay back fastest, because the missing "why" is a direct cause
of the same defect being repaired three different ways.

When a decision is not written down, the next person to meet the question does not find the
answer - they decide again, reasonably, and differently. Repeat that across a team and the
codebase holds several incompatible answers to one question, which is exactly the complaint that
everybody fixes things their own way.

So: **when a change decides how something works, rather than restoring behaviour already agreed,
it leaves an ADR.** That includes a defect fix that changes an approach
(`references/defects.md`, step 7).

An ADR is short - a page. What the decision was, what was going on that forced it, what else was
considered, what it costs. The template and the guidance on which decisions warrant one live
with the architect (`cf-sa`, `references/architecture.md`).
Where a repository already keeps `docs/adr/`, match the format it uses rather than introducing
a second one.

## The two things that are not a team knowledge base

**MEMANTO** is memory for agents across sessions. It is not reviewable, not citable, and a team
member cannot be pointed at it. Useful for continuity, useless as the place a project's
knowledge lives.

**An Obsidian vault** is personal. Notes there belong to the person who wrote them.

Both are fine for what they are. The failure is a project fact that exists *only* in one of
them: the team cannot reach it, and it disappears when the session or the person does. If
something durable turns up in either, move it into the repository or the wiki, and leave the
note pointing at it.

## Keeping it honest

- Change `CONTEXT.md` and `ARCHITECTURE.md` in the same pull request as the code they describe.
  A separate documentation pass later is a pass that does not happen.
- If a README and the code disagree, the code is what runs - fix the README in the same change,
  and say so.
- Do not write down what the code already says plainly. Documentation that restates the code
  goes stale fastest and helps least. Write the parts the code cannot say: why, what was
  rejected, what will break if you change it.
