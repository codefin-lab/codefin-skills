# Testability gaps

What cannot be tested, why, and what is needed. A maintained document, not remarks in a chat —
it is a deliverable QA owes Dev, and the most effective way to make the suite better over time.

| # | What cannot be tested | Why | What is needed | Scenarios blocked | Owner | Status |
| :-- | :-- | :-- | :-- | :-- | :-- | :-- |
| 1 | the confirmation dialog | no stable identifier on the buttons | a test identifier on each action | TS-900, TS-901 | | open |
| 2 | the expired-session path | no way to force a session to expire | a supported way to expire a session in non-production | TS-902 | | open |
| 3 | the month-end batch outcome | no way to seed data at a chosen date | a seeding command taking a date | TS-903 | | open |

Raise each as an item with an owner, the same as a defect, and track it until it closes. An
entry with no owner is a complaint; an entry with an owner is work.

**Count these in the round report.** A round where six scenarios could not run for want of a
test identifier is a round whose coverage number means less than it appears to, and the report
should say so.
