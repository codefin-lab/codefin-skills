"""Minimal production code the unit-test template is written against."""

from dataclasses import dataclass


@dataclass(frozen=True)
class Summary:
    count: int
    total: int


def summarise(repo, account_id: str) -> Summary:
    rows = repo.by_account(account_id)
    return Summary(count=len(rows), total=sum(r["value"] for r in rows))
