# colour vars
WORK_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

VENV_CMD=. venv/bin/activate

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

venv: ## Enable virtual env
	@if [ ! -e "venv/bin/activate_this.py" ] ; then python -m venv venv ; fi
.PHONY: venv

install_dev: venv ## Install development tools and dependencies
	$(VENV_CMD) && pip install -r requirements.dev.txt
.PHONY: install_dev

install_airflow: venv ## Install airflow with constraint
	$(VENV_CMD) && pip install 'apache-airflow==2.2.3' --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.2.3/constraints-3.7.txt"
.PHONY: install_airflow

install: venv install_dev install_airflow ## Install all
	$(VENV_CMD) && pip install -r requirements.txt
.PHONY: install

setup_dev: venv ## Setup development tools
	$(VENV_CMD) && pre-commit install
.PHONY: devsetup

lint: venv ## Run flake8
	$(VENV_CMD) && flake8 -r n dags
.PHONY: lint

test: venv lint ## Run pytest
	$(VENV_CMD) && pytest -v -s
.PHONY: test

.DEFAULT_GOAL := help
