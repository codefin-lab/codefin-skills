# DEF-<n>: <one line, what the customer experiences>

## Report

- **Reported by / channel**: <who, and where it arrived - Jira, email, LINE, a meeting>
- **Date**:
- **Environment**:
- **Version or build**:
- **Severity**: P0 | P1 | P2

**Steps**

1.
2.

**Observed**:
**Expected**:
**Violates**: `US-<epic>.<n>` - <quote the acceptance criterion>

> No record, no fix. If a field above cannot be filled, ask before starting.

## Defect or change request

- [ ] **Defect** - the code contradicts the document
- [ ] **CR** - the document is wrong, silent, or never covered this case. Stop here; amend the
      BRD or FSD first.

## Reproduction

Where the failing test lives, and on which environment it reproduces.

## Cause

One sentence. If it cannot be written in one sentence, it has not been found.

## Blast radius

What depends on the thing being changed. **Fill this in even when the answer is nothing** -
"checked the four consumers, none pass this field" is evidence; a blank is not.

| Kind | What was checked | Affected |
| :-- | :-- | :-- |
| shared library or module | | |
| external contract (schema, protocol, public interface) | | |
| data shape (table, column, format, migration) | | |
| message or event between systems | | |
| design-system component | | |
| internal function or interface | | |

Same mistake found elsewhere:

## Fix

- **Owner**:
- **What changed**:
- **ADR**: <link, if this decided how something works rather than restoring agreed behaviour>

## Regression test

Name and layer, and why that layer.

## Test run

| Layer | Ran | Cases | Passed | Note |
| :-- | :-- | --: | --: | :-- |
| unit | | | | |
| integration | | | | |
| e2e | | | | |

Layers skipped, and why:

## Verified

Environment, by whom, when.

## Closing note

*Written so the PO can send it to the customer unedited.*

The cause was <...>. We changed <...>. We also checked <...>. <Test name> now guards this, and it
was verified on <environment> on <date>.

## If reopened

Which step was skipped or done thinly:
