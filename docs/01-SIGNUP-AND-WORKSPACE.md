# Phase 1 — Databricks account and workspace

## Step 1 — Create a Free Edition account

1. Open **https://www.databricks.com/learn/free-edition**
2. Click **Get started free** (or **Try Databricks**).
3. Sign up with **Google**, **Microsoft**, or email.
4. Complete verification if prompted.
5. Choose **Serverless** / **Free** when asked about compute (wording varies; avoid paid trial that requires a card unless you intend to pay).

You should land in a workspace URL like `https://dbc-xxxxx.cloud.databricks.com`.

**Checkpoint:** You can open the home page without errors.

---

## Step 2 — Enable SQL (SQL warehouse)

1. Left sidebar → **SQL** (or **SQL Editor**).
2. If prompted, create a **SQL warehouse**:
   - Name: `weather-sql`
   - Type: **Serverless** (Free Edition)
   - Size: smallest available
3. Wait until status is **Running** (green).

**Checkpoint:** **SQL Editor** opens and shows a warehouse selector with `weather-sql`.

---

## Step 3 — Unity Catalog volume (raw file landing)

Free Edition includes Unity Catalog. We land the CSV on a **volume** (managed storage), not on your laptop.

1. Left sidebar → **Catalog** (or **Data** → **Volumes**).
2. Navigate: **Catalog** `main` → **Schema** `default` (create if missing is usually automatic).
3. **Create volume**:
   - Name: `weather_raw`
   - Full path will be: `/Volumes/main/default/weather_raw`
4. Open the volume → **Upload** → select `GlobalWeatherRepository.csv`.
5. Confirm the file appears (single file, ~167k rows when loaded).

**Checkpoint:** In Catalog explorer you see  
`/Volumes/main/default/weather_raw/GlobalWeatherRepository.csv`

---

## Step 4 — Create schemas (one-time)

1. Open **SQL Editor**, attach warehouse `weather-sql`.
2. Open this repo file: `sql/00_setup_catalog.sql`.
3. Copy the full script → paste into SQL Editor → **Run**.

**Checkpoint:** Catalog explorer shows schemas `weather_bronze`, `weather_silver`, `weather_gold`, `weather_dq`.

---

## Step 5 — Databricks Academy (optional, same day)

1. Go to **https://customer-academy.databricks.com/**
2. Sign in with the **same** Databricks account if linked, or create an academy account.
3. Enroll in **Databricks Fundamentals** (self-paced).
4. Finish at least:
   - What is the Databricks Lakehouse?
   - Databricks SQL overview

You can run this in parallel while building the pipeline.

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| No **Volumes** menu | Use **Catalog** → `main` → `default` → **Create** → **Volume** |
| Upload fails / file too large | Zip is not supported; upload the CSV directly; try a stable network |
| SQL warehouse won’t start | Refresh; Free Edition can cold-start — wait 2–3 minutes |
| Catalog is not `main` | Run `SELECT current_catalog();` in SQL Editor and update `00_setup_catalog.sql` |

Next: **[02-RUN-SQL-PIPELINE.md](02-RUN-SQL-PIPELINE.md)**
