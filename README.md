# Time Series Database Query Performance Benchmark Runner

### 导出数据
#### from InfluxDB
```
influx_inspect export -datadir {path to influx data} -waldir {path to influx wal} -database {db} -retention {rp} -start {rfc3339 time string or unix timestamp} -end {rfc3339 time string or unix timestamp} -compress -out {filename}
```

### 导入数据
#### export to anther InfluxDB from InfluxDB
```
influx -import -path {filename} -host {InfluxDB host} -port {InfluxDB port}
```

#### export to VictoriaMetrics from InfluxDB
使用 vmctl (慢)
```
./vmctl influx --influx-addr "http://localhost:8086" --influx-database {db} --influx-retention-policy {rp} --influx-filter-series {part of influxQL} --vm-addr {VictoriaMetrics addr}
```

使用 http 写接口
```
curl -X POST -H 'Content-Encoding: gzip' {VictoriaMetrics write api} -T {filename} 
```

### 查询数据

#### InfluxDB
```
## qps
SELECT sum("qps") FROM {db}.{rp}.{measurement} WHERE {...} GROUP BY time(10s)

## Usage
tsdm -influxQL -db <db> -rp <rp> -query <query> -queryURL <url>
## e.g.
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"measurement\" WHERE \"tag\" = 'tag value' AND time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:10:00Z' GROUP BY time(10s)" -queryURL {InfluxDB addr} -duration "1s"
```

#### Prometheus & VictoriaMetrics
```
## [from InfluxDB] qps 
## start=1589201960&end=1589202640&step=10
sum(sum_over_time(measurement{tag="tag value"}[10s]))

## Usage 
tsdm -promQL -start <start> -end <end> -step <step> -query <query> -queryURL <url>
## e.g.
./tsdm -promQL -start "2020-05-11T21:00:00Z" -end "2020-05-11T21:10:00Z" -step "10s" -query "sum(sum_over_time(measurement{tag=\"tag value\"}[10s]))" -queryURL {VictoriaMetrics addr}
```

移动 query 的时间窗口

使用 -move 参数，会将 influxQL 的时间条件替换为"now() - {time duration}"的形式。对于 promQL，则会在查询前根据当前时间和 query 指定的时间戳的偏移量，计算新的 query_range
