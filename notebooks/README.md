# Notebooks (optional)

You can run the pipeline without notebooks by pasting `sql/*.sql` into **SQL Editor**.

If you prefer a single Job entry point:

1. **Create** → **Notebook** → Python or SQL
2. For SQL notebook, run each file in order with `%sql` cells, or use:

```python
# Python notebook — run SQL files from repo (after cloning repo to workspace Repos)
for name in ["01_bronze", "02_silver", "03_gold", "04_data_quality"]:
    path = f"../sql/{name}.sql"
    sql = open(path).read()
    spark.sql(sql)  # or use sqldf / SQL warehouse API
```

Free Edition: simplest path is **four SQL tasks** in one Job (see main README Phase 4).
