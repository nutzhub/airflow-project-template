from airflow.models.dagbag import DagBag


def test_dag_import():
    dag_bag = DagBag()
    assert len(dag_bag.import_errors) == 0, "No Import Failures"
