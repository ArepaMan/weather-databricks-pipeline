# Databricks workspace setup

## Account and SQL warehouse

1. Create a workspace via [Databricks Free Edition](https://www.databricks.com/learn/free-edition).
2. **SQL** → create or start a **Serverless** SQL warehouse.

## Catalog, volume, and upload

1. **Catalog** → create catalog **`weather_pipeline`** (Standard, default storage).
2. Inside that catalog, create schema **`landing`**.
3. In **`landing`**, create volume **`weather_raw`**.
4. Upload **`GlobalWeatherRepository.csv`** to the volume.

Expected path:

`/Volumes/weather_pipeline/landing/weather_raw/GlobalWeatherRepository.csv`

## Schemas

Run `sql/00_setup_catalog.sql` in the SQL editor (attached to the running warehouse).

## Optional

[Databricks Fundamentals](https://customer-academy.databricks.com/) on Databricks Academy — lakehouse and SQL overview modules align with this repo.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `PATH_NOT_FOUND` on ingest | Copy the volume path from Catalog explorer into `sql/01_bronze.sql` |
| Warehouse stopped | Start serverless warehouse before running SQL |
| Wrong catalog | `SELECT current_catalog();` then align `USE CATALOG` in all `sql/*.sql` files |

Continue with [02-RUN-SQL-PIPELINE.md](02-RUN-SQL-PIPELINE.md).
