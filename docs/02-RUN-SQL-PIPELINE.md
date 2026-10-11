# Run the SQL pipeline

Run scripts **in order** in the **SQL Editor** (warehouse `weather-sql`). Each file is idempotent where possible (`CREATE OR REPLACE` / `MERGE` patterns).

## Step 1 — Bronze (`sql/01_bronze.sql`)

**Purpose:** Load raw CSV into Delta with lineage columns (`ingested_at`, `source_file`).

1. Open `sql/01_bronze.sql` locally.
2. Paste into SQL Editor → **Run all**.
3. Verify:

```sql
SELECT COUNT(*) AS row_cnt FROM main.weather_bronze.global_weather_raw;
-- Expect ~167,813
```

**Checkpoint:** Table `main.weather_bronze.global_weather_raw` exists and row count matches the CSV.

---

## Step 2 — Silver (`sql/02_silver.sql`)

**Purpose:**

- Parse `last_updated` to timestamp
- Deduplicate on `(location_name, last_updated)` (keep first)
- Route bad rows to **quarantine** Delta table
- Clean table: `main.weather_silver.global_weather`

Quarantine reasons include: unparseable date, duplicate key (extras), temperature outside plausible bounds, null location.

Verify:

```sql
SELECT COUNT(*) FROM main.weather_silver.global_weather;
-- Expect ~167,812 (one duplicate removed in source data)

SELECT quarantine_reason, COUNT(*)
FROM main.weather_silver.global_weather_quarantine
GROUP BY 1;
```

**Checkpoint:** Silver row count ≈ bronze minus quarantined duplicates/outliers.

---

## Step 3 — Gold (`sql/03_gold.sql`)

**Purpose:** Analyst-ready aggregates (mirrors your Jupyter EDA themes):

| Table | Content |
|-------|---------|
| `gold_country_daily_temp` | Daily mean temp by country (countries with ≥100 rows in silver) |
| `gold_city_monthly` | Monthly mean temp/humidity by city |
| `gold_kyiv_daily` | Kyiv daily series for dashboard |
| `gold_data_profile` | Row counts and date ranges per layer |

Verify:

```sql
SELECT * FROM main.weather_gold.gold_data_profile;
SELECT COUNT(*) FROM main.weather_gold.gold_kyiv_daily;
```

**Checkpoint:** `gold_kyiv_daily` has hundreds of rows; profile shows bronze ≥ silver + quarantine.

---

## Step 4 — Data quality (`sql/04_data_quality.sql`)

**Purpose:** Insert one row per check into `main.weather_dq.pipeline_checks` with `status` PASS/FAIL and `failed_rows`.

1. Run `sql/04_data_quality.sql`.
2. Review:

```sql
SELECT check_name, status, failed_rows, checked_at
FROM main.weather_dq.pipeline_checks
ORDER BY checked_at DESC, check_name;
```

**Checkpoint:** All checks **PASS** (or you document known FAILs — e.g. if you intentionally keep scrape errors in silver).

---

Next: **[03-JOB-AND-DASHBOARD.md](03-JOB-AND-DASHBOARD.md)**
