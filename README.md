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

1. Clone the repo and create a virtual environment:
   ```bash
   git clone https://github.com/yourusername/chinook-dw.git
   cd chinook-dw
   python3 -m venv venv && source venv/bin/activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Set up your `.env` file based on `.env.example` with your Snowflake credentials.

4. Run initial data loads:
   ```bash
   python -m src.python.main
   ```

5. Navigate into the `dbt` directory and run transformations:
   ```bash
   cd dbt
   dbt build
   ```

## 🗂️ dbt Models

- **Sources**: Defined in `models/sources/src_landing.yml`
- **Models**: To be built across `landing`, `foundation`, and `core`
- **Tests**: Place future assertions in `tests/`

## 🎯 Version Roadmap

Track progress and planned enhancements in [`TODO.md`](TODO.md)


