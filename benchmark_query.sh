#!/usr/bin/env bash

# java-rns.redis_ops
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:01:00Z' GROUP BY time(1s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 1 -move -interval 5s -duration 3m
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:01:00Z' GROUP BY time(1s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 10 -move -interval 5s -duration 3m
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:01:00Z' GROUP BY time(1s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 100 -move -interval 5s -duration 3m

./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 1 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:03:00Z" -end "2020-05-11T13:04:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 10 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:06:00Z" -end "2020-05-11T13:07:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 100 -duration 3m -interval 5s

./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb164:8481/select/1/prometheus" -move -concurrency 1 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:03:00Z" -end "2020-05-11T13:04:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb164:8481/select/1/prometheus" -move -concurrency 10 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:06:00Z" -end "2020-05-11T13:07:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb164:8481/select/1/prometheus" -move -concurrency 100 -duration 3m -interval 5s

# java-rus.redis_ops
./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-20T13:00:00Z' AND time < '2020-05-20T13:30:00Z' GROUP BY time(10s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 1 -move -interval 5s -duration 3m
./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-20T13:00:00Z' AND time < '2020-05-20T13:30:00Z' GROUP BY time(10s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 10 -move -interval 5s -duration 3m
./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-20T13:00:00Z' AND time < '2020-05-20T13:30:00Z' GROUP BY time(10s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 100 -move -interval 5s -duration 3m

./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 1 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 10 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 100 -duration 3m -interval 5s

./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb164:8481/select/1/prometheus" -move -concurrency 1 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb164:8481/select/1/prometheus" -move -concurrency 10 -duration 3m -interval 5s
./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb164:8481/select/1/prometheus" -move -concurrency 100 -duration 3m -interval 5s


# 数据点数量
# 7525/s
./tsdm -promQL -start "2020-05-20T10:00:00Z" -end "2020-05-20T10:00:05Z" -step "1s" -query "sum by (name) (sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 12 -duration 1m -interval 5s
./tsdm -influxQL -db "note-core" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-20T13:00:00Z' AND time < '2020-05-20T13:00:05Z' GROUP BY time(1s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 12 -move -interval 5s -duration 1m

# 71950/s
./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:00:05Z" -step "1s" -query "sum by (name) (sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 12 -duration 1m -interval 5s
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:00:05Z' GROUP BY time(1s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 12 -move -interval 5s -duration 1m

# 381000/s
./tsdm -promQL -start "2020-05-10T13:00:00Z" -end "2020-05-10T13:00:05Z" -step "1s" -query "sum by (service) (sum_over_time(thrift_calls_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 12 -duration 1m -interval 5s
./tsdm -influxQL -db "jarvis" -query "SELECT sum(\"qps\") FROM \"7_days\".\"thrift_calls\" WHERE time > '2020-05-10T13:00:00Z' AND time < '2020-05-10T13:00:05Z' GROUP BY time(1s), \"service\"" -queryURL "http://sns-influxdb26:8086" -concurrency 12 -move -interval 5s -duration 1m

# 时间范围
./tsdm -promQL -start "2020-05-20T13:00:00Z" -end "2020-05-20T13:01:00Z" -step "10s" -query "sum by (service) (sum_over_time(thrift_calls_qps{}[10s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 6 -duration 1m -interval 5s
./tsdm -promQL -start "2020-05-20T13:05:00Z" -end "2020-05-20T13:10:00Z" -step "10s" -query "sum by (service) (sum_over_time(thrift_calls_qps{}[10s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 6 -duration 1m -interval 5s
./tsdm -promQL -start "2020-05-20T13:12:00Z" -end "2020-05-20T13:22:00Z" -step "10s" -query "sum by (service) (sum_over_time(thrift_calls_qps{}[10s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 6 -duration 1m -interval 5s
./tsdm -promQL -start "2020-05-20T13:25:00Z" -end "2020-05-20T13:55:00Z" -step "10s" -query "sum by (service) (sum_over_time(thrift_calls_qps{}[10s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 6 -duration 1m -interval 5s

./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"thrift_calls\" WHERE time > '2020-05-20T13:00:00Z' AND time < '2020-05-20T13:01:00Z' GROUP BY time(10s), \"service\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m
./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"thrift_calls\" WHERE time > '2020-05-20T13:12:00Z' AND time < '2020-05-20T13:22:00Z' GROUP BY time(10s), \"service\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m
./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"thrift_calls\" WHERE time > '2020-05-20T13:05:00Z' AND time < '2020-05-20T13:10:00Z' GROUP BY time(10s), \"service\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m
./tsdm -influxQL -db "java-rus" -query "SELECT sum(\"qps\") FROM \"7_days\".\"thrift_calls\" WHERE time > '2020-05-20T13:25:00Z' AND time < '2020-05-20T13:55:00Z' GROUP BY time(10s), \"service\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m

# 聚合范围
./tsdm -promQL -start "2020-05-11T13:00:00Z" -end "2020-05-11T13:01:00Z" -step "1s" -query "sum(sum_over_time(redis_ops_qps{}[1s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 12 -duration 1m -interval 5s
./tsdm -promQL -start "2020-05-11T13:03:00Z" -end "2020-05-11T13:04:00Z" -step "10s" -query "sum(sum_over_time(redis_ops_qps{}[10s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 12 -duration 1m -interval 5s
./tsdm -promQL -start "2020-05-11T13:06:00Z" -end "2020-05-11T13:07:00Z" -step "100s" -query "sum(sum_over_time(redis_ops_qps{}[100s]))" -queryURL "http://sns-influxdb26:8428" -move -concurrency 12 -duration 1m -interval 5s

./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:01:00Z' GROUP BY time(1s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:01:00Z' GROUP BY time(10s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m
./tsdm -influxQL -db "java-rns" -query "SELECT sum(\"qps\") FROM \"7_days\".\"redis_ops\" WHERE time > '2020-05-11T13:00:00Z' AND time < '2020-05-11T13:01:00Z' GROUP BY time(100s), \"name\"" -queryURL "http://sns-influxdb26:8086" -concurrency 6 -move -interval 5s -duration 1m

