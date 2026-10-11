-- One-time setup after creating catalog `weather_pipeline` in the UI.
USE CATALOG weather_pipeline;

CREATE SCHEMA IF NOT EXISTS landing
  COMMENT 'Unity Catalog volume for raw CSV uploads';

CREATE SCHEMA IF NOT EXISTS weather_bronze
  COMMENT 'Raw ingest layer (Delta)';

CREATE SCHEMA IF NOT EXISTS weather_silver
  COMMENT 'Cleaned + quarantined bad rows';

CREATE SCHEMA IF NOT EXISTS weather_gold
  COMMENT 'Analyst-ready aggregates';

CREATE SCHEMA IF NOT EXISTS weather_dq
  COMMENT 'Pipeline check results';

-- Create volume `weather_raw` inside schema `landing`, upload CSV, then:
-- /Volumes/weather_pipeline/landing/weather_raw/GlobalWeatherRepository.csv
