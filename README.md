# weather-databricks-pipeline

Medallion **bronze → silver → gold** pipeline in Databricks SQL on the Kaggle [Global Weather Repository](https://www.kaggle.com/datasets/nelgiriyewithana/global-weather-repository). Raw CSV lands in a Unity Catalog volume; transforms run as SQL into Delta tables, with a quarantine path for bad rows, automated data-quality checks, a workflow job, and a SQL dashboard.

Companion repo for exploratory analysis and forecasting: [weather-trend-forecasting](https://github.com/ArepaMan/weather-trend-forecasting) (same dataset, different stack).

## Architecture

```
GlobalWeatherRepository.csv  (volume: landing/weather_raw)
        │
        ▼
  weather_bronze.global_weather_raw
        │
        ▼
  weather_silver.global_weather          ──► weather_silver.global_weather_quarantine
        │
        ▼
  weather_gold.*  (aggregates)
        │
        ▼
  weather_dq.pipeline_checks
```

**Catalog:** `weather_pipeline`  
**Job:** `weather_medallion_pipeline` (`bronze` → `silver` → `gold` → `dq`)  
**Dashboard:** Weather pipeline ops

## Reference run (Oct 2026)

| Layer | Rows |
|-------|------|
| Bronze | 167,813 |
| Silver | 167,811 |
| Quarantine | 2 |
| DQ checks | 6 / 6 pass |

Details and dashboard URL: [docs/DEMO.md](docs/DEMO.md).

## Repository layout

```
sql/
  00_setup_catalog.sql
  01_bronze.sql
  02_silver.sql
  03_gold.sql
  04_data_quality.sql
docs/
  00-PREREQUISITES.md
  01-SIGNUP-AND-WORKSPACE.md
  02-RUN-SQL-PIPELINE.md
  03-JOB-AND-DASHBOARD.md
```

## Quick start

1. Download `GlobalWeatherRepository.csv` from Kaggle (not stored in git).
2. Follow [docs/01-SIGNUP-AND-WORKSPACE.md](docs/01-SIGNUP-AND-WORKSPACE.md) to create the catalog, volume, and upload path.
3. Run `sql/00_setup_catalog.sql` through `sql/04_data_quality.sql` in order in the SQL editor ([docs/02-RUN-SQL-PIPELINE.md](docs/02-RUN-SQL-PIPELINE.md)).
4. Wire the same scripts into a job and dashboard ([docs/03-JOB-AND-DASHBOARD.md](docs/03-JOB-AND-DASHBOARD.md)).

## Configuration

Default volume path (edit in `sql/01_bronze.sql` if needed):

`/Volumes/weather_pipeline/landing/weather_raw/GlobalWeatherRepository.csv`

Schemas: `weather_bronze`, `weather_silver`, `weather_gold`, `weather_dq`, plus `landing` for the volume.

## License

No license file yet — treat as source-available personal project unless you add one.

## Author

Manuel Vargas Alvarez (2026).
