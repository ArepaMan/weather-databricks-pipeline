# Phase 0 — Prerequisites

## Time

| Block | Hours |
|-------|-------|
| Signup + workspace | 1–2 |
| First SQL + bronze/silver/gold | 3–4 |
| DQ + job + dashboard | 2–3 |
| Fundamentals course (optional) | 2–3 |

## What you need on your PC

- The Kaggle CSV: `GlobalWeatherRepository.csv` (~50 MB) from [Global Weather Repository](https://www.kaggle.com/datasets/nelgiriyewithana/global-weather-repository).
- A browser (Chrome or Edge recommended).
- This repo cloned or opened at `C:\Users\manol\Projects\weather-databricks-pipeline`.

## Naming (use consistently)

| Object | This project |
|--------|----------------|
| Catalog | `weather_pipeline` (created in UI) |
| Landing schema + volume | `landing` / `weather_raw` |
| Bronze / silver / gold / dq | `weather_bronze`, `weather_silver`, `weather_gold`, `weather_dq` |
| CSV in volume | `/Volumes/weather_pipeline/landing/weather_raw/GlobalWeatherRepository.csv` |

Free Edition may also expose a `workspace` or `main` catalog; if you use that instead, update `USE CATALOG` in all `sql/*.sql` files and the volume path in `01_bronze.sql`.

## Checkpoint

- [ ] CSV downloaded locally  
- [ ] Repo on disk  
- [ ] You know which email you will use for Databricks (work or personal is fine)

Next: **[01-SIGNUP-AND-WORKSPACE.md](01-SIGNUP-AND-WORKSPACE.md)**
