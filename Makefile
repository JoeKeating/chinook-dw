# Makefile for Chinook DW Project

# Variables
VENV_NAME=venv
PYTHON=$(VENV_NAME)/bin/python
PIP=$(VENV_NAME)/bin/pip
ACTIVATE=. $(VENV_NAME)/bin/activate

# Default target
.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make venv        - Create virtual environment"
	@echo "  make install     - Install Python dependencies"
	@echo "  make ddl         - Run SQL DDL scripts manually"
	@echo "  make load        - Run data load scripts"
	@echo "  make dbt         - Run dbt transformations"
	@echo "  make all         - Do it all (except DDL, must run separately)"

.PHONY: venv
venv:
	python3 -m venv $(VENV_NAME)
	@echo "Virtual environment created. Activate with: source $(VENV_NAME)/bin/activate"

.PHONY: install
install:
	$(PIP) install -r requirements.txt

.PHONY: ddl
ddl:
	@echo "NOTE: Run these scripts manually via SnowSQL or Snowflake Web UI in order:"
	@echo "1. src/sql/ddl/001_create_database.sql"
	@echo "2. src/sql/ddl/002_create_schemas.sql"
	@echo "3. src/sql/ddl/003_create_tables.sql"
	@echo "4. src/sql/ddl/004_create_roles.sql"

.PHONY: load
load:
	$(PYTHON) -m src.python.main load

.PHONY: dbt
dbt:
	cd dbt && dbt build

.PHONY: all
all: venv install load dbt
