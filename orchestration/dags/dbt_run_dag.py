from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.python import ShortCircuitOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from datetime import datetime, timedelta

default_args = {
    'owner': 'dpp',
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

def check_new_orders(**context):
    hook = PostgresHook(postgres_conn_id='shopdb_conn')
    sql = """
        SELECT COUNT(*) 
        FROM app.orders 
        WHERE updated_at >= NOW() - INTERVAL '10 minutes'
    """
    result = hook.get_first(sql)
    return result[0] > 0

with DAG(
    dag_id='dbt_run_on_orders_update',
    default_args=default_args,
    description='Run dbt models when orders table is updated',
    schedule_interval='*/10 * * * *',
    start_date=datetime(2026, 1, 1),
    catchup=False,
    tags=['dbt', 'shopdb'],
) as dag:

    check_orders = ShortCircuitOperator(
        task_id='check_new_orders',
        python_callable=check_new_orders,
    )

    run_dbt = BashOperator(
        task_id='run_dbt_models',
        bash_command='cd ~/dbt && dbt run',
    )

    check_orders >> run_dbt
