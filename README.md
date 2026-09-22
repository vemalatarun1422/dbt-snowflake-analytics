# dbt + Snowflake Analytics

An **analytics engineering project built with dbt on Snowflake**. Raw e-commerce data is modeled into clean staging views and a star schema (fact + dimensions) ready for BI tools such as Power BI.

## Data Model

```
 seeds / raw schema          staging (views)            marts (tables)
 ───────────────────         ─────────────────          ─────────────────────────
 raw_customers  ───────────► stg_customers ───────────► dim_customers
 raw_orders     ───────────► stg_orders    ─┐
 raw_payments   ───────────► stg_payments  ─┴─────────► fct_orders (incremental)
```

## Tech Stack
dbt Core · Snowflake · SQL · Jinja · dbt tests

## Project Structure
```
models/staging/   # 1:1 cleaned views over raw sources + source/column tests
models/marts/     # dim_customers, fct_orders (incremental merge)
seeds/            # Sample raw CSV data (load with `dbt seed`)
tests/            # Singular data tests
macros/           # Reusable macros (cents_to_dollars)
profiles.example.yml
```

## Run It
```bash
pip install dbt-snowflake
cp profiles.example.yml ~/.dbt/profiles.yml   # fill in your Snowflake account details via env vars
dbt seed
dbt build          # runs models + tests
dbt docs generate && dbt docs serve
```

## Key Features
- Layered modeling (staging → marts) with consistent naming
- `unique`, `not_null`, `relationships`, and `accepted_values` tests on keys and statuses
- Incremental `fct_orders` using Snowflake `merge` on `order_id`
- Credentials read from environment variables — nothing secret in the repo
