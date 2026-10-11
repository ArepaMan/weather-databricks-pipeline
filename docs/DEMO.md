# Deployment notes

Workspace-specific references for reproducing or reviewing this pipeline.

## Objects

| Type | Name |
|------|------|
| Catalog | `weather_pipeline` |
| Job | `weather_medallion_pipeline` |
| Dashboard | Weather pipeline ops |

**Published dashboard** (Databricks login required):  
https://dbc-48a6cb8e-c1bd.cloud.databricks.com/dashboardsv3/01f1c52320361a2f80d6a1d8876ed7c7/published?o=7474650545176309

Republish without dashboard filters if you want a shorter share URL.

## Last verified metrics

| Check | Value |
|-------|--------|
| Bronze rows | 167,813 |
| Silver rows | 167,811 |
| Quarantine rows | 2 |
| Reconciliation | bronze = silver + quarantine |
| DQ checks | 6 pass |
| `gold_kyiv_daily` | 862 rows |

## Screenshots

Committed under `docs/screenshots/` (`job-run-success.png`, `dashboard-layer-counts.png`, `dashboard-dq.png`, `dashboard-kyiv.png`). Embedded in the root README.
