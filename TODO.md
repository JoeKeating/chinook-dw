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
- [x] CLI commands: `load`
- [x] Add logging with timestamps for all loads
- [x] chinook_loader secrets moved to AWS Secrets
- [x] Buildout foundation models in dbt
- [x] Replace hardcoded load functions with a loop driven by a config map
- [x] Create Makefile


## 🧪 Version 3 – Test & Automate
- [ ] Buildout core models in dbt
- [ ] Add test coverage with Pytest or Unittest
- [ ] Mock Snowflake connections in local test mode
- [ ] Move hardcoded file paths into configs
- [ ] Add config based automated db setup
- [ ] Add CI via GitHub Actions


## 🌐 Future Wishlist
- [ ] Generate new data and updates for updates
- [ ] Configure for incremental loads
- [ ] Terraform for Snowflake provisioning
- [ ] Integration with dbt Cloud or Airflow
- [ ] Optional web interface to trigger jobs

---
> Created by Joe Keating.
