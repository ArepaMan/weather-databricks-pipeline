# Demo — Weather pipeline on Databricks

Evidence for portfolio, LinkedIn, and job applications. **Databricks links require workspace access**; always include screenshots in this folder for reviewers who cannot log in.

## Live artifacts (your workspace)

| Artifact | Name / ID | Notes |
|----------|-----------|--------|
| **Catalog** | `weather_pipeline` | Unity Catalog |
| **Job** | `weather_medallion_pipeline` | Tasks: `bronze` → `silver` → `gold` → `dq` |
| **Dashboard** | `Weather pipeline ops` | Lakeview / SQL dashboard |

**Published dashboard (login required):**  
https://dbc-48a6cb8e-c1bd.cloud.databricks.com/dashboardsv3/01f1c52320361a2f80d6a1d8876ed7c7/published?o=7474650545176309  

Use a **clean link** without date filters: open the dashboard, clear any `observation_date` filter, publish again, copy link.

## Verified results (Oct 2026 run)

| Layer / check | Value |
|---------------|--------|
| Bronze rows | **167,813** |
| Silver clean | **167,811** |
| Quarantine | **2** |
| Reconciliation | bronze = silver + quarantine |
| DQ checks | **6 / 6 PASS** |
| Kyiv gold daily | **862** rows |

Related analysis (Python, stats, forecasting): [weather-trend-forecasting](https://github.com/ArepaMan/weather-trend-forecasting).

## Screenshot checklist

Add PNGs under `docs/screenshots/` (not committed if large — optional):

- [ ] `job-run-success.png` — Job run timeline, all tasks green  
- [ ] `dashboard-layer-counts.png` — Pipeline layer counts bar chart  
- [ ] `dashboard-dq.png` — dq_latest table (all PASS)  
- [ ] `dashboard-kyiv.png` — Kyiv temperature line (full date range, AVG not SUM)

## One-liner (applications)

Built a medallion ETL on Databricks (Unity Catalog volume → Delta bronze/silver/gold, quarantine table, automated DQ checks, 4-task Job, SQL dashboard) on a 167k-row global weather panel—with full row reconciliation and documented quarantine rules.

## Companion repo

Clone and run SQL from [weather-databricks-pipeline](https://github.com/ArepaMan/weather-databricks-pipeline); ingest the same Kaggle CSV used in the forecasting project.
