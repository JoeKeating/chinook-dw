import json
import logging
from src.python.config.chinook_config import (
    chinook_db_config,
    get_chinook_loader_secret,
)
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
import src.python.chinook_loader as chinook_loader


logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)


def open_create_engine(db_config: dict) -> Engine | bool:
    """Open a connection to Snowflake"""

    # Get secrets from AWS Secrets Manager
    secrets = get_chinook_loader_secret()

    db_user = secrets["username"]
    db_password = secrets["password"]
    db_account = db_config["DB_ACCOUNT"]
    db_database = db_config["DB_DATABASE"]
    db_schema = db_config["DB_SCHEMA"]
    db_role = db_config["DB_ROLE"]
    db_warehouse = db_config["DB_WAREHOUSE"]
    try:
        engine = create_engine(
            f"snowflake://{db_user}:{db_password}@{db_account}/"
            f"{db_database}/{db_schema}?role={db_role}&warehouse={db_warehouse}&\
                timezone=America/New_York"
        )
        return engine

    except Exception as e:
        print(f"An exception occurred creating connection:{e} ")
        return False


def read_chinook_data(file_path: str) -> dict | bool:
    """Read in chinook json"""

    try:
        with open(file_path, "r") as in_file:
            return json.load(in_file)
    except FileNotFoundError as e:
        logger.error(f"{e}")
        return None
    except Exception as e:
        logger.error(f"An error occurred reading the file: {e}")
        return False


def main():

    url = "/Users/jpk/Projects/chinook-dw/data/ChinookData.json"
    chinook_data = read_chinook_data(url)
    engine = open_create_engine(chinook_db_config)

    chinook_loader.load__genre(chinook_data, engine)
    chinook_loader.load__media_type(chinook_data, engine)
    chinook_loader.load__artist(chinook_data, engine)
    chinook_loader.load__album(chinook_data, engine)
    chinook_loader.load__track(chinook_data, engine)
    chinook_loader.load__employee(chinook_data, engine)
    chinook_loader.load__customer(chinook_data, engine)
    chinook_loader.load__invoice(chinook_data, engine)
    chinook_loader.load__invoice_line(chinook_data, engine)
    chinook_loader.load__playlist(chinook_data, engine)
    chinook_loader.load__playlist_track(chinook_data, engine)


if __name__ == "__main__":
    main()
