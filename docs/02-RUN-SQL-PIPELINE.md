# Run the SQL pipeline

Execute in the **SQL Editor** with a running warehouse. Order matters.

## 1. Bronze — `sql/01_bronze.sql`

Loads the volume CSV into `weather_bronze.global_weather_raw` with `ingested_at` and `source_file`.

```sql
SELECT COUNT(*) FROM weather_pipeline.weather_bronze.global_weather_raw;
-- ~167,813
```

## 2. Silver — `sql/02_silver.sql`

Parses timestamps, deduplicates on `(location_name, last_updated)`, writes quarantine rows to `weather_silver.global_weather_quarantine`, clean rows to `weather_silver.global_weather`.

```sql
SELECT COUNT(*) FROM weather_pipeline.weather_silver.global_weather;
-- ~167,811

SELECT quarantine_reason, COUNT(*)
FROM weather_pipeline.weather_silver.global_weather_quarantine
GROUP BY 1;
```

## 3. Gold — `sql/03_gold.sql`

Builds `weather_gold.gold_data_profile`, `gold_country_daily_temp`, `gold_kyiv_daily`, and related aggregates.

```sql
SELECT * FROM weather_pipeline.weather_gold.gold_data_profile;
SELECT COUNT(*) FROM weather_pipeline.weather_gold.gold_kyiv_daily;
-- ~862 Kyiv daily rows
```

## 4. Data quality — `sql/04_data_quality.sql`

Appends check results to `weather_dq.pipeline_checks`.

```sql
SELECT check_name, status, failed_rows, detail
FROM weather_pipeline.weather_dq.pipeline_checks
ORDER BY checked_at DESC, check_name;
```

Continue with [03-JOB-AND-DASHBOARD.md](03-JOB-AND-DASHBOARD.md).
