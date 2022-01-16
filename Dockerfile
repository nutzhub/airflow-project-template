FROM apache/airflow:2.2.3-python3.7

COPY ./dags /opt/airflow/
COPY ./plugins /opt/airflow/