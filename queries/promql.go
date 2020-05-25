package queries

import (
	"context"
	"log"
	"time"

	"github.com/prometheus/client_golang/api"
	v1 "github.com/prometheus/client_golang/api/prometheus/v1"
)

type promQL struct {
	ctx       context.Context
	api       v1.API
	query     string
	timeRange v1.Range
	timeShift time.Duration
}

func (q *promQL) Request() {
	//var warnings v1.Warnings
	//var err error

	if q.timeShift != 0 {
		q.timeRange.Start = time.Now().Add(-q.timeShift)
		q.timeRange.End = time.Now().Add(-q.timeShift).Add(q.timeRange.Start.Sub(q.timeRange.End))
	}
	_, _, _ = q.api.QueryRange(q.ctx, q.query, q.timeRange)

	//if err != nil {
	//	log.Println(err)
	//} else if len(warnings) > 0 {
	//	for warning := range warnings {
	//		log.Println(warning)
	//	}
	//}
}

// NewPromQL 封装 promQL
func NewPromQL(ctx context.Context, url, queryRange string, start, end time.Time, step time.Duration, timeMove bool) Query {
	cfg := api.Config{
		Address: url,
	}
	if client, err := api.NewClient(cfg); err != nil {
		log.Fatalln("Failed on create prometheus api client: ", err)
		return nil
	} else {
		promQL := &promQL{
			ctx:   ctx,
			api:   v1.NewAPI(client),
			query: queryRange,
			timeRange: v1.Range{
				Start: start,
				End:   end,
				Step:  step,
			},
		}
		if timeMove {
			promQL.timeShift = time.Now().Sub(start)
		}
		return promQL
	}
}
