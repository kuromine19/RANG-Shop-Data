# Rang Shop Data Pipeline

A data engineering pipeline built on top of [Rang Shop WebApp](https://github.com/kuromine19/RANG-Shop-WebApp) — a mock Vietnamese coffee & tea e-commerce platform.

## Stack

- **PostgreSQL** — data warehouse (`shopdb`)
- **dbt** — data transformation (staging → marts)
- **Apache Airflow** — pipeline orchestration (poll every 10 minutes)

## Data Flow
![Data Flow](docs/architecture.png)

### Data Quality Checks

#### dbt test
- `unique` — no duplicate primary keys
- `not_null` — required fields are present
- `accepted_values` — status fields contain valid values

#### Airflow checks
- `check_new_orders` — skip pipeline if no new data in last 10 minutes
- `check_results` — raise error if any dbt model failed
