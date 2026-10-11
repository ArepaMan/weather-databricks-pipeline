# Prerequisites

- Kaggle file **`GlobalWeatherRepository.csv`** ([dataset](https://www.kaggle.com/datasets/nelgiriyewithana/global-weather-repository)) — not committed to git.
- Databricks workspace with SQL warehouse and Unity Catalog (Free Edition is sufficient).
- This repository cloned locally.

## Naming (this repo)

| Object | Value |
|--------|--------|
| Catalog | `weather_pipeline` |
| Landing volume | `/Volumes/weather_pipeline/landing/weather_raw/` |
| Schemas | `weather_bronze`, `weather_silver`, `weather_gold`, `weather_dq` |

See [01-SIGNUP-AND-WORKSPACE.md](01-SIGNUP-AND-WORKSPACE.md), then [02-RUN-SQL-PIPELINE.md](02-RUN-SQL-PIPELINE.md).
