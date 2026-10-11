# Job and dashboard

## Workflow job

1. **Jobs & Pipelines** → **Create job** → name: `weather_medallion_pipeline`.
2. Add four **SQL** tasks, each pointing at a saved query (or pasted script body):

| Task | Script | Depends on |
|------|--------|------------|
| `bronze` | `sql/01_bronze.sql` | — |
| `silver` | `sql/02_silver.sql` | `bronze` |
| `gold` | `sql/03_gold.sql` | `silver` |
| `dq` | `sql/04_data_quality.sql` | `gold` |

3. Use the same serverless SQL warehouse for all tasks.
4. **Run now** to validate the chain.

For a static Kaggle extract, a schedule is optional; manual runs are enough unless the landing file is refreshed.

## SQL dashboard

Lakeview dashboard **Weather pipeline ops** uses SQL datasets on gold and DQ tables, for example:

- `weather_gold.gold_data_profile` — row counts by layer
- `weather_dq.pipeline_checks` — latest check status per `check_name`
- `weather_gold.gold_kyiv_daily` — line chart (`observation_date` vs `avg_temperature_c`; use **AVG**, not **SUM**, on the measure)

Publish from the dashboard editor. Shared links require Databricks workspace access; see [DEMO.md](DEMO.md) for the published URL and [screenshots/](screenshots/) for static captures.
