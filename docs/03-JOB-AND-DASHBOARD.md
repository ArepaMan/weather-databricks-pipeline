# Phase 3 — Job workflow and dashboard

## Part A — Databricks Job (ETL automation)

### Option 1 — Workflow UI (recommended for learning)

1. Left sidebar → **Jobs & Pipelines** → **Create job**.
2. Name: `weather-medallion-daily` (schedule can be manual for learning).
3. Add **Tasks** (type **SQL**), same warehouse `weather-sql`:

| Task key | SQL source |
|----------|------------|
| `bronze` | Paste contents of `sql/01_bronze.sql` |
| `silver` | `sql/02_silver.sql` — **depends on** `bronze` |
| `gold` | `sql/03_gold.sql` — **depends on** `silver` |
| `dq` | `sql/04_data_quality.sql` — **depends on** `gold` |

4. **Run now** → confirm all tasks green.
5. (Optional) Add schedule: daily at 06:00 — only useful if you refresh the CSV; for a static Kaggle file, **manual run** is enough.

**Checkpoint:** One successful multi-task run in **Runs** tab.

### Option 2 — Notebook wrapper (if SQL tasks are unavailable)

Create a notebook with four `%sql` cells, one per script, and create a **Notebook task** job. Same dependency order.

---

## Part B — SQL dashboard

1. **SQL** → **Dashboards** → **Create dashboard**.
2. Name: `Weather pipeline KPIs`.
3. Add widgets (each is a saved SQL query):

**Widget 1 — Pipeline health**

```sql
SELECT check_name, status, failed_rows
FROM main.weather_dq.pipeline_checks
QUALIFY ROW_NUMBER() OVER (PARTITION BY check_name ORDER BY checked_at DESC) = 1
ORDER BY check_name;
```

Visualization: **Table**, conditional formatting on `status`.

**Widget 2 — Layer row counts**

```sql
SELECT * FROM main.weather_gold.gold_data_profile ORDER BY layer;
```

Visualization: **Bar chart** (`layer` vs `row_count`).

**Widget 3 — Kyiv temperature trend**

```sql
SELECT observation_date, avg_temperature_c
FROM main.weather_gold.gold_kyiv_daily
ORDER BY observation_date;
```

Visualization: **Line chart**.

**Widget 4 — Top 10 warmest countries (mean temp)**

```sql
SELECT country, ROUND(AVG(avg_temperature_c), 2) AS mean_temp
FROM main.weather_gold.gold_country_daily_temp
GROUP BY country
ORDER BY mean_temp DESC
LIMIT 10;
```

Visualization: **Bar chart**.

4. **Share** → copy link (workspace-only is fine for interviews).

**Checkpoint:** Dashboard loads in &lt;30s with four widgets.

---

## Part C — Git hygiene

```powershell
cd C:\Users\manol\Projects\weather-databricks-pipeline
git add -A
git status   # confirm no CSV committed
```

Commit when ready (you ask when you want a commit message).

Next: **[04-INTERVIEW-STORY.md](04-INTERVIEW-STORY.md)**
