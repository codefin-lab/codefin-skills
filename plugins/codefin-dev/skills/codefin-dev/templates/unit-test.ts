// Table-driven unit test, Codefin shape. vitest here; jest is the same idea.

import { describe, expect, it } from "vitest";
import { summarise } from "./portfolio";
import type { Holding } from "./types";

// A fake at the boundary the code already defines, not a mock of every call.
const holdingsReturning = (rows: Holding[]) => ({
  byAccount: async () => rows,
});

const holdingsFailing = (error: Error) => ({
  byAccount: async () => {
    throw error;
  },
});

describe("summarise", () => {
  const cases = [
    {
      // The name starts with the requirement, so a red run names the clause that is untrue.
      name: "US-3.4 an account with no holdings summarises to zero, not an error",
      repo: holdingsReturning([]),
      expected: { count: 0, total: 0 },
    },
    {
      name: "US-3.4 holdings are totalled across currencies at the given rate",
      repo: holdingsReturning([{ value: 100 }, { value: 250 }] as Holding[]),
      expected: { count: 2, total: 350 },
    },
  ];

  it.each(cases)("$name", async ({ repo, expected }) => {
    await expect(summarise(repo, "acct-1")).resolves.toEqual(expected);
  });

  it("DEF-118 (US-3.4) a repository failure surfaces instead of reporting zero", async () => {
    const boom = new Error("timeout");
    await expect(summarise(holdingsFailing(boom), "acct-1")).rejects.toThrow(boom);
  });
});
