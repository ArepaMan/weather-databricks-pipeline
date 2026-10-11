# Weather medallion pipeline on Databricks

Bronze → silver → gold ETL on the Kaggle **Global Weather Repository**, with data-quality checks and a SQL dashboard. Built to demonstrate **basic Databricks** and **practical ETL/ELT** for analyst-style roles (personal learning project).

**Dataset:** same CSV as [`weather-trend-forecasting`](https://github.com/ArepaMan/weather-trend-forecasting) — place `GlobalWeatherRepository.csv` in a Unity Catalog volume (not in git).

## Results (completed run)

| Metric | Value |
|--------|--------|
| Bronze | 167,813 rows |
| Silver (clean) | 167,811 |
| Quarantine | 2 |
| DQ checks | 6 PASS |
| Job | `weather_medallion_pipeline` (bronze → silver → gold → dq) |
| Dashboard | **Weather pipeline ops** |

**Demo write-up:** [docs/DEMO.md](docs/DEMO.md) (dashboard link, screenshot checklist, application one-liner).

## What you will deliver

| Artifact | Purpose |
|----------|---------|
| Delta tables (bronze / silver / gold / quarantine) | Medallion lakehouse |
| `sql/04_data_quality.sql` | Pass/fail DQ report table |
| Databricks **Job** (4 tasks) | Scheduled ETL |
| **SQL dashboard** | Gold-layer KPIs |
| This repo + short LinkedIn/application blurb | Portfolio proof |

## Start here

Follow the guide in order (about **6–10 hours** total, spread over 2–3 days):

1. **[docs/00-PREREQUISITES.md](docs/00-PREREQUISITES.md)** — accounts, CSV, naming conventions  
2. **[docs/01-SIGNUP-AND-WORKSPACE.md](docs/01-SIGNUP-AND-WORKSPACE.md)** — Databricks Free Edition, SQL warehouse, volume upload  
3. **[docs/02-RUN-SQL-PIPELINE.md](docs/02-RUN-SQL-PIPELINE.md)** — run `sql/01`–`04` in order  
4. **[docs/03-JOB-AND-DASHBOARD.md](docs/03-JOB-AND-DASHBOARD.md)** — workflow job + dashboard  
5. **[docs/04-INTERVIEW-STORY.md](docs/04-INTERVIEW-STORY.md)** — how to describe the project honestly  

Optional course (parallel): [Databricks Fundamentals](https://customer-academy.databricks.com/) on Databricks Academy.

## Repository layout

```
sql/
  00_setup_catalog.sql      # schemas + volume path (run once)
  01_bronze.sql             # ingest raw CSV → Delta
  02_silver.sql             # clean + quarantine bad rows
  03_gold.sql               # analyst-ready aggregates
  04_data_quality.sql       # checks → dq_results
docs/                       # step-by-step guides
```

## Configuration

This project was built with catalog **`weather_pipeline`**, schema **`landing`** + volume **`weather_raw`** for the CSV, and schemas `weather_bronze`, `weather_silver`, `weather_gold`, `weather_dq`. Adjust paths in `sql/00_setup_catalog.sql` and `sql/01_bronze.sql` if your workspace differs.

**Volume path used:**

`/Volumes/weather_pipeline/landing/weather_raw/GlobalWeatherRepository.csv`

## Author

Manuel Vargas Alvarez — personal learning project (2026).
