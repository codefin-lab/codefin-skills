"""Table-driven unit test.

Parametrised cases, a fake at the boundary the code already defines, and an id per case that
starts with the requirement it proves so a failure names the clause that is untrue.
"""

from dataclasses import dataclass

import pytest

from portfolio import Summary, summarise


@dataclass
class FakeHoldings:
    """Substitutes at the port the service depends on."""

    rows: list | None = None
    error: Exception | None = None

    def by_account(self, _account_id: str) -> list:
        if self.error is not None:
            raise self.error
        return self.rows or []


CASES = [
    pytest.param(
        FakeHoldings(rows=[]),
        Summary(count=0, total=0),
        id="US-3.4 an account with no holdings summarises to zero, not an error",
    ),
    pytest.param(
        FakeHoldings(rows=[{"value": 100}, {"value": 250}]),
        Summary(count=2, total=350),
        id="US-3.4 holdings are totalled across currencies at the given rate",
    ),
]


@pytest.mark.parametrize(("repo", "expected"), CASES)
def test_summarise(repo: FakeHoldings, expected: Summary) -> None:
    assert summarise(repo, "acct-1") == expected


def test_summarise_surfaces_repository_failure() -> None:
    """DEF-118 (US-3.4) a repository failure surfaces instead of reporting zero."""
    boom = TimeoutError("timeout")

    with pytest.raises(TimeoutError):
        summarise(FakeHoldings(error=boom), "acct-1")
