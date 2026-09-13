// End-to-end: page objects rather than selectors scattered through specs, named
// for the requirement, and pointed at an environment through ENV rather than a hard-coded host.
//
// Run with: make test-e2e ENV=sit

import { expect, test, type Page } from "@playwright/test";

const baseURL = process.env.E2E_BASE_URL ?? "http://localhost:3000";

// The page object keeps selectors in one place, so a UI change breaks one file rather than ten.
class PortfolioPage {
  constructor(private readonly page: Page) {}

  async open(accountId: string) {
    await this.page.goto(`${baseURL}/accounts/${accountId}/portfolio`);
  }

  summaryTotal() {
    return this.page.getByTestId("portfolio-summary-total");
  }

  emptyState() {
    return this.page.getByTestId("portfolio-empty-state");
  }
}

test.describe("TS-900 Portfolio summary (US-3.4)", () => {
  test("TS-900 an account with no holdings shows the empty state, not an error", async ({ page }) => {
    const portfolio = new PortfolioPage(page);

    await portfolio.open("acct-empty");

    await expect(portfolio.emptyState()).toBeVisible();
    await expect(page.getByRole("alert")).toHaveCount(0);
  });

  test("TS-900 the total reflects every holding on the account", async ({ page }) => {
    const portfolio = new PortfolioPage(page);

    await portfolio.open("acct-1");

    await expect(portfolio.summaryTotal()).toHaveText("350.00");
  });
});
