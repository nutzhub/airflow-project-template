"""
First example for airflow dag
"""
from airflow.decorators import dag
from airflow.operators.dummy import DummyOperator
from airflow.utils.dates import days_ago


# [START example]
@dag(start_date=days_ago(2))
def run():
    start_task = DummyOperator(task_id="start_task")
    end_task = DummyOperator(task_id="start_task")
    start_task >> end_task


dag = run()
# [END example]
