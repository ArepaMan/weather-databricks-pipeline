# Phase 4 — How to talk about this project

## One-liner (Clara / analyst roles)

> Personal project: I built a medallion ETL on Databricks SQL over a 167k-row weather panel—bronze ingest from a Unity Catalog volume, silver dedupe and quarantine for bad timestamps and out-of-range readings, gold aggregates for country and city trends, and automated DQ checks plus a SQL dashboard.

## Be honest

- Say **personal / learning project**, not production Clara data.
- Same dataset as your **weather-trend-forecasting** repo — you already know the caveats (observation-hour drift, Kyiv scrape error).

## Concepts to explain if asked

| Topic | Your answer |
|-------|-------------|
| ETL vs ELT | **ELT**: load raw first (bronze), transform in the warehouse (silver/gold) |
| Why Delta | ACID tables, time travel, schema evolution on ingest |
| Quarantine vs delete | Audit trail; finance-adjacent roles care about not silently dropping money/movement rows |
| Idempotency | Re-running job replaces gold/DQ; bronze uses overwrite or merge pattern you chose |
| DQ checks | Row-count reconciliation, null keys, duplicate keys, FK-like card→txn style checks adapted to location+timestamp |

## Link to your other work

- **SQL practice:** DQ checks mirror the Clara-style audit problem (duplicates, orphans, bad amounts).
- **Python:** Jupyter project goes deeper on forecasting; Databricks project shows **scale + pipeline + BI**.

## Application bullet (optional)

- Databricks Free Edition: medallion pipeline (bronze/silver/gold), Delta tables, SQL workflow job, DQ suite, SQL dashboard — Global Weather Repository.
