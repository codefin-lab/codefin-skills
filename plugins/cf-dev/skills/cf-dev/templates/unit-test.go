// Table-driven unit test.
//
// Named after the requirement it proves (or the defect it guards), one table, one loop,
// substituted at the interface the code already defines rather than mocked call by call.

package portfolio

import (
	"context"
	"errors"
	"testing"
)

// fakeHoldings substitutes at the port the service already depends on. One fake at the
// boundary beats a mock per call: when the boundary is right, the fake stays small.
type fakeHoldings struct {
	rows []Holding
	err  error
}

func (f fakeHoldings) ByAccount(_ context.Context, _ string) ([]Holding, error) {
	return f.rows, f.err
}

func TestSummarise(t *testing.T) {
	t.Parallel()

	tests := []struct {
		name    string // starts with US-<epic>.<n>, or DEF-<n> (US-<epic>.<n>) for a regression
		repo    fakeHoldings
		want    Summary
		wantErr error
	}{
		{
			name: "US-3.4 an account with no holdings summarises to zero, not an error",
			repo: fakeHoldings{rows: nil},
			want: Summary{Count: 0, Total: 0},
		},
		{
			name: "US-3.4 holdings are totalled across currencies at the given rate",
			repo: fakeHoldings{rows: []Holding{{Value: 100}, {Value: 250}}},
			want: Summary{Count: 2, Total: 350},
		},
		{
			name:    "DEF-901 (US-3.4) a repository failure surfaces instead of reporting zero",
			repo:    fakeHoldings{err: errATimeout},
			wantErr: errATimeout,
		},
	}

	for _, tc := range tests {
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()

			got, err := NewService(tc.repo).Summarise(context.Background(), "acct-1")

			if !errors.Is(err, tc.wantErr) {
				t.Fatalf("error: got %v, want %v", err, tc.wantErr)
			}
			if tc.wantErr == nil && got != tc.want {
				t.Errorf("summary: got %+v, want %+v", got, tc.want)
			}
		})
	}
}
