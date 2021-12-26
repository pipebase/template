Data pipeline template for `mqtt`, `timescaledb` integration
### About
demo is based on `weather metrics` in timescale [`getting started`] section with following changes
1. weather metrics are read from csv and publish to mqtt broker
2. mqtt consumer read weather metric and ingest into timescaledb
3. `data/weather_data_sample.csv` include last 10k record in [`weather_data.zip`]
### Setup
download build and run everything (may take 15 mins) 
```bash
docker-compose up -d
```
### Monitor pipelines
visit [publisher](http://localhost:8000/v1/pipe)
```json
[
  {
    "name": "mqtt_publisher",
    "state": "done",
    "total_run": 10000,
    "failure_run": 0
  },
  {
    "name": "local_file_path_visitor",
    "state": "done",
    "total_run": 1,
    "failure_run": 0
  },
  {
    "name": "csv_deser",
    "state": "done",
    "total_run": 1,
    "failure_run": 0
  },
  {
    "name": "file_reader",
    "state": "done",
    "total_run": 1,
    "failure_run": 0
  },
  {
    "name": "json_ser",
    "state": "done",
    "total_run": 10000,
    "failure_run": 0
  },
  {
    "name": "metric_streamer",
    "state": "done",
    "total_run": 1,
    "failure_run": 0
  }
]
``` 
visit [subscriber](http://localhost:8100/v1/pipe)
```json
[
  {
    "name": "metric_collector",
    "state": "receive",
    "total_run": 1,
    "failure_run": 0
  },
  {
    "name": "json_deser",
    "state": "receive",
    "total_run": 10000,
    "failure_run": 0
  },
  {
    "name": "mqtt_subscriber",
    "state": "receive",
    "total_run": 10000,
    "failure_run": 0
  },
  {
    "name": "batch_psql_writer",
    "state": "receive",
    "total_run": 1,
    "failure_run": 0
  }
]
```
### Query timescaledb
login
```bash
docker exec -it timescaledb /bin/bash
psql -U postgres -d postgres -w
```
find the average temperature per 15 day period, for each city, in the past 12 months
```sql
SELECT time_bucket('15 days', time) as "bucket"
   ,city_name, avg(temp_c)
   FROM weather_metrics
   WHERE time > now() - (12* INTERVAL '1 month')
   GROUP BY bucket, city_name
   ORDER BY bucket DESC;
```

[`weather_data.zip`]: https://s3.amazonaws.com/assets.timescale.com/docs/downloads/weather_data.zip
[`getting started`]: https://docs.timescale.com/timescaledb/latest/getting-started/create-hypertable/