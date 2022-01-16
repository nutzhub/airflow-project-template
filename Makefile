PYTHON_VERSION := 3.7
AIRFLOW_VERSION := 2.2.3
CONSTRAINT := https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt

VENV_CMD=. venv/bin/activate # source venv

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help

venv: ## Enable virtual env
	@if [ ! -e "venv/bin/activate" ] ; then python -m venv venv ; fi
.PHONY: venv

install-dev: venv ## Install development tools and dependencies
	$(VENV_CMD) && pip install -r requirements.dev.txt
.PHONY: install-dev

install-airflow: venv ## Install airflow with constraint
	$(VENV_CMD) && pip install 'apache-airflow==2.2.3' --constraint ${CONSTRAINT}"
.PHONY: install-airflow

install-all: venv install-dev install-airflow ## Install all
	$(VENV_CMD) && pip install -r requirements.txt
.PHONY: install-all

setup_dev: venv ## Setup development tools
	$(VENV_CMD) && pre-commit install
.PHONY: devsetup

lint: venv ## Run flake8, black	
	$(VENV_CMD) && flake8 dags
	$(VENV_CMD) && flake8 plugins
	$(VENV_CMD) && flake8 tests
	$(VENV_CMD) && flake8 configs
	$(VENV_CMD) && black dags plugins tests configs --check
	
.PHONY: lint

test: venv lint ## Run pytest
	@( \
		export AIRFLOW_HOME=${PWD}; \
		$(VENV_CMD); \
		pytest tests --log-cli-level=info --disable-warnings; \
	)
.PHONY: test

clean-pytest: ## Gets rid of junk from running pytest locally
	@rm -rf *.cfg airflow.db logs .pytest_cache
.PHONY: clean-pytest


clean-venv: ## Cleans your virtualenv, run make venv to recreate it
	@rm -rf venv plugins.egg-info
.PHONY: test


clean-all: clean-pytest clean-venv ## Cleans everything
.PHONY: clean-all

.DEFAULT_GOAL := help
