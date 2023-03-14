import datetime as dt
import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow_dbt_python.operators.dbt import (
    DbtRunOperator,
    DbtTestOperator,
    DbtSourceFreshnessOperator
)

args = {
    "owner": "clauro",
    "retries":7
}

with DAG(
    dag_id="tweet_elt",
    default_args=args,
    schedule="@daily",
    start_date=pendulum.today("UTC").add(days=-1),
    dagrun_timeout=dt.timedelta(minutes=60)
    ) as dag:

    extract_tweet_data = BashOperator(
        task_id='extract_tweet_data',
        bash_command="python /home/clauro/personal_projects/FlixDataEngineering/twitter_api/main.py")

    pre_dbt_test = DbtTestOperator(
        task_id="pre_dbt_test",
        project_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt",
        profiles_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt"
    )

    dbt_run_raw = DbtRunOperator(
        task_id="raw_incremental_ingest",
        full_refresh=False,
        select=["raw"],
        project_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt",
        profiles_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt"
    )

    dbt_source_freshness = DbtSourceFreshnessOperator(
        task_id="freshness_check",
        project_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt",
        profiles_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt"
    )

    dbt_run_mart = DbtRunOperator(
        task_id="mart_transform",
        select=["mart"],
        project_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt",
        profiles_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt"
    )

    post_dbt_test = DbtTestOperator(
        task_id="post_dbt_test",
        project_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt",
        profiles_dir="/home/clauro/personal_projects/FlixDataEngineering/dbt"
    )

    extract_tweet_data >> pre_dbt_test >> dbt_run_raw >> dbt_source_freshness >> dbt_run_mart >> post_dbt_test
