package queries

import (
	"log"
	"strconv"
	"strings"
	"time"
	"unicode/utf8"

	v2 "github.com/influxdata/influxdb/client/v2"
)

type influxQL struct {
	query  v2.Query
	client v2.Client
}

func (q *influxQL) Request() {
	_, _ = q.client.Query(q.query)
}

func (q *influxQL) TimeRelatedOverwriteCommand() {
	sep := "time"
	commandSlice := strings.SplitN(q.query.Command, sep, -1)

	if len(commandSlice) == 1 {
		// There is not time condition
		return
	}
	greater, _ := utf8.DecodeRuneInString(">")
	smaller, _ := utf8.DecodeRuneInString("<")
	equal, _ := utf8.DecodeRuneInString("=")
	overwroteCommand := make([]string, 0, 2*len(commandSlice))
	overwroteCommand = append(overwroteCommand, commandSlice[0])
	now := time.Now()
	for	partIndex := 1; partIndex < len(commandSlice); partIndex++ {
		part := []rune(strings.TrimSpace(commandSlice[partIndex]))
		if len(part) > 2 {
			var t time.Time
			var shift int64
			var other string
			var condition []string = make([]string, 0, 10)
			// -- Process the `time>{RFC3339 time or unix timestamp}` part
			if part[0] == greater {
				if part[1] == equal {
					t, other = parseTime(string(part[2:]))
					shift = int64(now.Sub(t).Seconds())
					condition = append(condition, ">= now() - ")
				} else {
					t, other = parseTime(string(part[1:]))
					shift = int64(now.Sub(t).Seconds())
					condition = append(condition, "> now() - ")
				}
				// --
			} else if part[0] == smaller {
				if part[1] == equal {
					t, other = parseTime(string(part[2:]))
					shift = int64(now.Sub(t).Seconds())
					condition = append(condition, "<= now() - ")
				} else {
					t, other = parseTime(string(part[1:]))
					shift = int64(now.Sub(t).Seconds())
					condition = append(condition, "< now() - ")
				}
			} else {
				overwroteCommand = append(overwroteCommand, commandSlice[partIndex])
				continue
			}
			condition = append(condition, strconv.FormatInt(shift*1000, 10), "ms ", other, " ")
			overwroteCommand = append(overwroteCommand, strings.Join(condition, ""))
			continue
		}
		overwroteCommand = append(overwroteCommand, commandSlice[partIndex])
	}
	q.query.Command = strings.Join(overwroteCommand, sep)
	log.Println(q.query.Command)
}

func parseTime(str string) (t time.Time, useless string) {

	timeString := strings.TrimSpace(str)
	timeRunes := []rune(timeString)
	if  timeString[0] != '\'' {
		one, _ := utf8.DecodeRuneInString("0")
		nine, _ := utf8.DecodeRuneInString("9")
		numberIndex := 0
		for ; numberIndex < len(timeRunes); numberIndex++ {
			if timeRunes[numberIndex] < one || timeRunes[numberIndex] > nine {
				numberIndex++
				break
			}
		}
		unixTimestamp, _ := strconv.ParseInt(string(timeRunes[:numberIndex]), 10, 64)
		sec := unixTimestamp / (int64)(time.Second)
		nsec := unixTimestamp %  (int64)(time.Second)
		return time.Unix(sec, nsec), string(timeRunes[numberIndex:])
	} else {
		timeRunes := []rune(timeString)
		z, _ := utf8.DecodeRuneInString("Z")
		zIndex := 1
		for  ; zIndex < len(timeRunes); zIndex++ {
			if timeRunes[zIndex] == z {
				zIndex++
				break
			}
		}
		t, _ = time.Parse(time.RFC3339, string(timeRunes[1:zIndex]))
		return t, string(timeRunes[zIndex+1:])
	}
}

// NewInfluxQL 封装 influxQL
func NewInfluxQL(url, db, rp, command string, timeRangeMove bool) Query {
	conf := v2.HTTPConfig{
		Addr: url,
	}
	if client, err := v2.NewHTTPClient(conf); err != nil {
		log.Fatalln("Failed on create prometheus api client: ", err)
		return nil
	} else {
		influxQL := &influxQL{
			client: client,
			query: v2.Query{
				Database:        db,
				RetentionPolicy: rp,
				Command:         command,
			},
		}
		if timeRangeMove {
			influxQL.TimeRelatedOverwriteCommand()
		}
		return influxQL
	}
}
