# Interview notes — weather Databricks pipeline

## 30-second pitch

"I ingested the Global Weather Repository into Databricks using a medallion layout: bronze Delta from a Unity Catalog volume, silver with deduplication and a quarantine table for bad temperatures and duplicate keys, and gold tables for country and monthly summaries. I added explicit data-quality checks and scheduled the SQL steps as a Job, with a SQL dashboard for stakeholders."

## Likely questions

**Why not delete bad rows?**  
Quarantine preserves audit trail and lets analysts sample failures (same mindset as payment exception queues).

**How is this different from your Jupyter project?**  
Same dataset and business rules; Databricks adds scheduled, governed tables that BI tools query directly.

**What would you do next?**  
Incremental `MERGE` on `last_updated`, partition silver by `date(last_updated)`, alert on Slack when DQ fails, and parameterize catalog for dev/prod.

## Numbers to remember

- Bronze: **167,813** rows  
- Silver clean: **167,812** (one duplicate `(location_name, last_updated)`)  
- Known anomaly: Kyiv **2026-08-17** ~1.1°C (also flagged in forecasting project)
