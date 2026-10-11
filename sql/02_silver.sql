-- Silver: parse timestamps, dedupe keys, quarantine bad rows.
USE CATALOG weather_pipeline;

CREATE OR REPLACE TEMP VIEW _silver_tagged AS
WITH parsed AS (
  SELECT
    b.*,
    try_to_timestamp(CAST(last_updated AS STRING)) AS last_updated_ts
  FROM weather_bronze.global_weather_raw b
),
dup_keys AS (
  SELECT location_name, last_updated
  FROM parsed
  GROUP BY location_name, last_updated
  HAVING COUNT(*) > 1
),
numbered AS (
  SELECT
    p.*,
    ROW_NUMBER() OVER (
      PARTITION BY p.location_name, p.last_updated
      ORDER BY p.ingested_at, p.temperature_celsius
    ) AS key_rn
  FROM parsed p
),
tagged AS (
  SELECT
    n.*,
    CASE
      WHEN n.last_updated_ts IS NULL THEN 'unparseable_last_updated'
      WHEN n.location_name IS NULL OR TRIM(n.location_name) = '' THEN 'null_location'
      WHEN n.temperature_celsius IS NOT NULL
           AND (n.temperature_celsius < -60 OR n.temperature_celsius > 60)
        THEN 'temperature_out_of_range'
      WHEN n.key_rn > 1 THEN 'duplicate_key_extra_row'
      ELSE NULL
    END AS quarantine_reason
  FROM numbered n
)
SELECT * FROM tagged;

CREATE OR REPLACE TABLE weather_silver.global_weather_quarantine
USING DELTA
COMMENT 'Rows removed from silver with reason'
AS
SELECT
  quarantine_reason,
  location_name,
  last_updated,
  last_updated_ts,
  temperature_celsius,
  country,
  ingested_at,
  source_file
FROM _silver_tagged
WHERE quarantine_reason IS NOT NULL;

CREATE OR REPLACE TABLE weather_silver.global_weather
USING DELTA
COMMENT 'Cleaned weather panel'
AS
SELECT
  location_name,
  last_updated_ts AS last_updated,
  temperature_celsius,
  humidity,
  pressure_mb,
  wind_kph,
  precip_mm,
  country,
  latitude,
  longitude,
  ingested_at,
  source_file
FROM _silver_tagged
WHERE quarantine_reason IS NULL;
