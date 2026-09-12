// Minimal production code the unit-test template is written against, so the template is
// executed rather than merely inspected.
package portfolio

import (
	"context"
	"errors"
)

var errATimeout = errors.New("timeout")

type Holding struct{ Value int }

type Summary struct {
	Count int
	Total int
}

type Holdings interface {
	ByAccount(ctx context.Context, id string) ([]Holding, error)
}

type Service struct{ repo Holdings }

func NewService(r Holdings) Service { return Service{repo: r} }

func (s Service) Summarise(ctx context.Context, id string) (Summary, error) {
	rows, err := s.repo.ByAccount(ctx, id)
	if err != nil {
		return Summary{}, err
	}
	out := Summary{Count: len(rows)}
	for _, h := range rows {
		out.Total += h.Value
	}
	return out, nil
}
