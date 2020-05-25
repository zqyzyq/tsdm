package queries

import (
	v2 "github.com/influxdata/influxdb/client/v2"
	"testing"
)

func TestInfluxQL_TimeRelatedOverwriteCommand(t *testing.T) {
	influxQL := &influxQL{
		query: v2.Query{
			Command: "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE (\"name\" = 'recNoteStatsRedis') AND time > '2020-05-11T13:00:00Z' AND time<'2020-05-11T13:01:00Z' GROUP BY time(1s)",
		},
	}
	influxQL.TimeRelatedOverwriteCommand()
}