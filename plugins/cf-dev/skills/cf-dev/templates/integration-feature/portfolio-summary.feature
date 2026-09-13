# Scenario names carry the requirement, so a red run names the clause of the agreement that is
# now untrue - readable by the BA without a translation step.

Feature: TS-900 Portfolio summary (US-3.4)

  Background:
    Given the database is seeded from fixtures "portfolio/base"
    And I am authenticated as a customer with account "acct-1"

  Scenario: TS-900 an account with no holdings shows the empty state
    Given account "acct-1" has no holdings
    When I request the portfolio summary for "acct-1"
    Then the response status is 200
    And the summary count is 0
    And no error is returned

  Scenario: TS-900 holdings are totalled across currencies
    Given account "acct-1" holds:
      | instrument | currency | value |
      | AAPL       | USD      | 100   |
      | PTT        | THB      | 250   |
    When I request the portfolio summary for "acct-1"
    Then the summary total is 350
    And the database row for "acct-1" in "portfolio_summary" has "holding_count" of 2

  # A regression test earned from a defect, named so the link back is obvious.
  Scenario: DEF-901 (US-3.4) a holding with no valuation date does not abort the summary
    Given account "acct-1" holds an instrument with no valuation date
    When I request the portfolio summary for "acct-1"
    Then the response status is 200
    And the holding is reported as unvalued rather than omitted
