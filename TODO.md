## TODO for chinook-dw

# 📈 chinook-dw Project Roadmap

## ✅ Version 1 – Initial Release
- [x] Load core Snowflake tables (genre, artist, album, etc.)
- [x] Use SQLAlchemy with .env for secure connections
- [x] Remove sensitive files from GitHub history
- [x] Version-controlled, clean GitHub repo established
- [x] Introduce dbt layer for data transformations

## 🔄 Version 2 – Enhancements & Refinement
- [x] Replace raw SQL setup with parameterized Python scripts
- [x] CLI commands: `create-user`, `load-all`, `setup-schema`
- [x] Add logging with timestamps for all loads
- [x] chinook_loader secrets moved to AWS Secrets
- [ ] Model Foundation zone in dbt


## 🧪 Version 3 – Test & Automate
- [ ] Add test coverage with Pytest or Unittest
- [ ] Mock Snowflake connections in local test mode
- [ ] Add CI via GitHub Actions
- [ ] Config-driven enhancements
    - [ ] Replace hardcoded load functions with a loop driven by a config map
    - [ ]  Centralize environment-specific metadata (e.g., DB, schema, role) in config
    - [ ]  Configure logging levels, formats, and output destinations via logging.yml
    - [ ]  Move retry logic and error-handling rules into a config file
    - [ ]  Support dynamic file paths and data sources via config entries
    - [ ]  Enable toggles for optional load steps (e.g., truncate tables before load)
    - [ ]  Designate test vs. production behaviors through config switches

## 🌐 Future Wishlist
- [ ] Terraform for Snowflake provisioning
- [ ] Integration with dbt Cloud or Airflow
- [ ] Optional web interface to trigger jobs

---
> Created by Joe Keating, curated with a little Ghostly guidance :ghost:
