-- Gold: aggregates for BI / dashboard.
USE CATALOG weather_pipeline;

CREATE OR REPLACE TABLE weather_gold.gold_data_profile
USING DELTA
AS
SELECT 'bronze' AS layer, COUNT(*) AS row_count,
       MIN(ingested_at) AS min_ts, MAX(ingested_at) AS max_ts
FROM weather_bronze.global_weather_raw
UNION ALL
SELECT 'silver', COUNT(*), MIN(last_updated), MAX(last_updated)
FROM weather_silver.global_weather
UNION ALL
SELECT 'quarantine', COUNT(*), MIN(ingested_at), MAX(ingested_at)
FROM weather_silver.global_weather_quarantine;

CREATE OR REPLACE TABLE weather_gold.gold_country_daily_temp
USING DELTA
AS
WITH eligible_countries AS (
  SELECT country
  FROM weather_silver.global_weather
  WHERE country IS NOT NULL
  GROUP BY country
  HAVING COUNT(*) >= 100
)
SELECT
  s.country,
  CAST(s.last_updated AS DATE) AS observation_date,
  AVG(s.temperature_celsius) AS avg_temperature_c,
  COUNT(*) AS observation_count
FROM weather_silver.global_weather s
INNER JOIN eligible_countries e ON s.country = e.country
GROUP BY s.country, CAST(s.last_updated AS DATE);

CREATE OR REPLACE TABLE weather_gold.gold_city_monthly
USING DELTA
AS
SELECT
  location_name,
  country,
  DATE_TRUNC('month', last_updated) AS month_start,
  AVG(temperature_celsius) AS avg_temperature_c,
  AVG(humidity) AS avg_humidity,
  COUNT(*) AS observation_count
FROM weather_silver.global_weather
GROUP BY location_name, country, DATE_TRUNC('month', last_updated);

CREATE OR REPLACE TABLE weather_gold.gold_kyiv_daily
USING DELTA
AS
SELECT
  CAST(last_updated AS DATE) AS observation_date,
  AVG(temperature_celsius) AS avg_temperature_c,
  AVG(humidity) AS avg_humidity,
  MAX(precip_mm) AS max_precip_mm,
  COUNT(*) AS observation_count
FROM weather_silver.global_weather
WHERE location_name = 'Kyiv'
GROUP BY CAST(last_updated AS DATE);
