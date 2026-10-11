-- Data quality checks → append results (latest run per check used in dashboard).
USE CATALOG weather_pipeline;

CREATE TABLE IF NOT EXISTS weather_dq.pipeline_checks (
  check_id STRING,
  check_name STRING,
  status STRING,
  failed_rows BIGINT,
  detail STRING,
  checked_at TIMESTAMP
) USING DELTA;

CREATE OR REPLACE TEMP VIEW _dq_run AS
WITH
bronze_cnt AS (SELECT COUNT(*) AS n FROM weather_bronze.global_weather_raw),
silver_cnt AS (SELECT COUNT(*) AS n FROM weather_silver.global_weather),
quarantine_cnt AS (SELECT COUNT(*) AS n FROM weather_silver.global_weather_quarantine),
dup_silver AS (
  SELECT COUNT(*) AS n
  FROM (
    SELECT location_name, last_updated, COUNT(*) AS c
    FROM weather_silver.global_weather
    GROUP BY 1, 2
    HAVING c > 1
  ) d
),
null_location AS (
  SELECT COUNT(*) AS n
  FROM weather_silver.global_weather
  WHERE location_name IS NULL OR TRIM(location_name) = ''
),
null_ts AS (
  SELECT COUNT(*) AS n
  FROM weather_silver.global_weather
  WHERE last_updated IS NULL
),
kyiv_gold AS (SELECT COUNT(*) AS n FROM weather_gold.gold_kyiv_daily),
reconcile AS (
  SELECT
    b.n AS bronze_n,
    s.n AS silver_n,
    q.n AS quarantine_n
  FROM bronze_cnt b, silver_cnt s, quarantine_cnt q
)
SELECT
  uuid() AS check_id,
  checks.*
FROM (
  SELECT
    'bronze_has_rows' AS check_name,
    IF(n > 160000, 'PASS', 'FAIL') AS status,
    IF(n > 160000, 0, 1) AS failed_rows,
    CONCAT('bronze_n=', n) AS detail,
    current_timestamp() AS checked_at
  FROM bronze_cnt
  UNION ALL
  SELECT
    'silver_no_duplicate_keys',
    IF(n = 0, 'PASS', 'FAIL'),
    n,
    CONCAT('duplicate_groups=', n),
    current_timestamp()
  FROM dup_silver
  UNION ALL
  SELECT
    'silver_no_null_location',
    IF(n = 0, 'PASS', 'FAIL'),
    n,
    CONCAT('null_location_rows=', n),
    current_timestamp()
  FROM null_location
  UNION ALL
  SELECT
    'silver_no_null_timestamp',
    IF(n = 0, 'PASS', 'FAIL'),
    n,
    CONCAT('null_ts_rows=', n),
    current_timestamp()
  FROM null_ts
  UNION ALL
  SELECT
    'gold_kyiv_has_rows',
    IF(n > 100, 'PASS', 'FAIL'),
    IF(n > 100, 0, 1),
    CONCAT('kyiv_daily_rows=', n),
    current_timestamp()
  FROM kyiv_gold
  UNION ALL
  SELECT
    'bronze_silver_quarantine_reconcile',
    IF(silver_n + quarantine_n = bronze_n, 'PASS', 'FAIL'),
    ABS(bronze_n - silver_n - quarantine_n),
    CONCAT('bronze=', bronze_n, ' silver=', silver_n, ' quarantine=', quarantine_n),
    current_timestamp()
  FROM reconcile
) checks;

INSERT INTO weather_dq.pipeline_checks
SELECT check_id, check_name, status, failed_rows, detail, checked_at
FROM _dq_run;
