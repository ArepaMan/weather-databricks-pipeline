-- Bronze: load CSV from Unity Catalog volume into Delta (full refresh).
USE CATALOG weather_pipeline;

CREATE OR REPLACE TABLE weather_bronze.global_weather_raw
USING DELTA
COMMENT 'Raw Kaggle Global Weather Repository + ingest metadata'
AS
SELECT
  src.*,
  current_timestamp() AS ingested_at,
  'GlobalWeatherRepository.csv' AS source_file
FROM read_files(
  '/Volumes/weather_pipeline/landing/weather_raw/GlobalWeatherRepository.csv',
  format => 'csv',
  header => true,
  inferSchema => true
) AS src;
