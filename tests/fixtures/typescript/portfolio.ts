// Minimal production code the unit-test template is written against.
import type { Holding } from "./types";

type Repo = { byAccount: () => Promise<Holding[]> };

export async function summarise(repo: Repo, _id: string) {
  const rows = await repo.byAccount();
  return { count: rows.length, total: rows.reduce((a, h) => a + h.value, 0) };
}
