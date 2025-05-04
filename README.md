# 🎵 Chinook Data Warehouse (chinook-dw)

Welcome to the Chinook Data Warehouse — a showcase data engineering project that models and transforms music industry data into a clean, dimensional warehouse using Snowflake, dbt, and Python.

## 📦 Project Structure

```
chinook-dw-main/
├── dbt/                  # dbt project: sources, models, macros
├── src/                  # Python source files for data loading
├── logs/                 # dbt logs
├── .env.example          # Example environment configuration
├── requirements.txt      # Python dependencies
├── Makefile              # Utility commands
├── TODO.md               # Project roadmap
└── README.md             # This file
```

## 🚀 Project Goals

- Build a foundational data warehouse using the [Chinook dataset](https://github.com/lerocha/chinook-database)
- Load and transform data into **landing**, **foundation**, and **core** zones
- Practice version-controlled, testable, and scalable data engineering techniques
- Prep for real-world use of **dbt**, **Snowflake**, and **SQLAlchemy**

## 🛠️ Technologies Used

- **Snowflake** – Cloud Data Platform
- **dbt Core** – Transformation & Documentation
- **SQLAlchemy** – Data loading & Python DB API
- **Python** – ETL scripting
- **Makefile** – Simplified command-line utility

## 🧪 Getting Started

Before beginning, note that the database environment must be created manually by running SQL scripts located in src/sql/ddl/. These scripts must be executed in the following order:

1. create_db_and_schemas.sql

2. create_landing_tables.sql

3. create_users.sql

4. create_roles.sql

5. Clone the repo and create a virtual environment (compatible with both python3 -m venv and pyenv workflows):
   ```bash
   git clone https://github.com/yourusername/chinook-dw.git
cd chinook-dw
pyenv virtualenv 3.x.x chinook-dw  # or use python3 -m venv venv
pyenv local chinook-dw
pip install -r requirements.txt
   ```

6. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

7. Configure your AWS credentials to allow secure access to Snowflake connection secrets via AWS Secrets Manager.

8. Run initial data loads:
   ```bash
   python -m src.python.main load
   ```

9. Navigate into the `dbt` directory and run transformations:
   ```bash
   cd dbt
   dbt build
   ```

## 🗂️ dbt Models

- **Sources**: Sources in landing zone defined in `models/sources/src_landing.yml`
- **Models**: To be built across  `foundation`, and `core`
- **Tests**: Place future assertions in `tests/`

## 🎯 Version Roadmap

Track progress and planned enhancements in [`TODO.md`](TODO.md)


