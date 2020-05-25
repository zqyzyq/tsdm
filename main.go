package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"sync"
	"time"

	"github.com/zqyzyq/tsdm/queries"
	"github.com/rcrowley/go-metrics"
)

var (
	queryURL    = flag.String("queryURL", "", "The URL from which data is queried")
	queryString = flag.String("query", "", "The query string executed by tsdb")

	influxQL       = flag.Bool("influxQL", false, "Specified the query string format")
	influxDB       = flag.String("db", "", "Database")
	influxRP       = flag.String("rp", "", "Retention policy")
	promQL         = flag.Bool("promQL", false, "Specified the query string format")
	promRangeStart = flag.String("start", "", "RFC3330 date-time or unix_timestamp")
	promRangeEnd   = flag.String("end", "", "RFC3330 date-time or unix_timestamp")
	promRangeStep  = flag.Duration("step", time.Second, "Query request interval")

	timeRangeMove = flag.Bool("move", false, "Move the time range of queries, for Grafana emulation")

	concurrency = flag.Int("concurrency", 1, "Query concurrency, default 1")
	interval    = flag.Duration("interval", time.Millisecond*100, "Query request interval")
	duration    = flag.Duration("duration", time.Minute*10, "Benchmark time duration")

)

type benchmarkTask struct {
	id    int
	timer metrics.Timer
	query queries.Query
}

// Run benchmark task
func (task *benchmarkTask) Run(initWG, doneWG *sync.WaitGroup, interval, duration time.Duration) {
	initWG.Wait()
	defer doneWG.Done()
	starter := time.Now()
	latest := starter
	for latest.Sub(starter) < duration {
		task.query.Request()
		now := time.Now()
		task.timer.Update(now.Sub(latest))
		latest = now
		time.Sleep(interval)
	}
}

func main() {

	defer func() {
		if err := recover(); err != nil {
			log.Println(err)
			flag.Usage()
		}
	}()

	// -- Configure benchmark runner
	flag.Parse()

	if *queryURL == "" {
		panic("Must provide query url.")
	}
	if *queryString == "" {
		panic("Must provide query string.")
	}
	if *concurrency < 1 || *interval < 0 || *duration < 0 {
		panic("Invalid args")
	}

	var queryBuilder struct {
		start, end time.Time
		build      func() queries.Query
	}
	var err error
	if *influxQL {
		queryBuilder.build = func() queries.Query {
			return queries.NewInfluxQL(*queryURL, *influxDB, *influxRP, *queryString, *timeRangeMove)
		}
	}

	if *promQL {
		if queryBuilder.start, err = time.Parse(time.RFC3339, *promRangeStart); err != nil {
			panic(fmt.Sprintln("Invalid prometheus time range start: ", *promRangeStart, "error: ", err))
		}
		if queryBuilder.end, err = time.Parse(time.RFC3339, *promRangeEnd); err != nil {
			panic(fmt.Sprintln("Invalid prometheus time range end: ", *promRangeStart, "error: ", err))
		}
		queryBuilder.build = func() queries.Query {
			return queries.NewPromQL(context.Background(), *queryURL, *queryString, queryBuilder.start, queryBuilder.end, *promRangeStep, *timeRangeMove)
		}
	}
	// --

	initWG := &sync.WaitGroup{}
	doneWG := &sync.WaitGroup{}
	initWG.Add(*concurrency)
	doneWG.Add(*concurrency)
	for i := 0; i < *concurrency; i++ {
		task := &benchmarkTask{
			id:    i,
			timer: metrics.NewTimer(),
			query: queryBuilder.build(),
		}
		go task.Run(initWG, doneWG, *interval, *duration)
		initWG.Done()
	}
	doneWG.Wait()

}
