import json
import logging
import yaml
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


def read_chinook_data(file_path: str) -> dict:
    """Read in chinook json"""

    try:
        with open(file_path, "r") as in_file:
            return json.load(in_file)
    except FileNotFoundError as e:
        logger.error(f"An error occurred reading the file: {e}")
        return {}
    except Exception as e:
        logger.error(f"An error occurred reading the file: {e}")
        return {}


def read_table_load_yaml(file_path: str) -> dict:
    """Read in table_load.yaml"""

    try:
        with open(file_path,'r') as in_file:
            parsed_config_data = yaml.safe_load(in_file)
            return parsed_config_data

    except FileNotFoundError as e:
        logger.error(f"An error occurred reading the file: {e}")
        return {}
    except Exception as e:
        logger.error(f"An error occurred reading the file: {e}")
        return {}


def main():

    chinook_data_file_path = r'/Users/jpk/Projects/chinook-dw/data/ChinookData.json'
    table_load_file_path = r'/Users/jpk/Projects/chinook-dw/src/python/config/table_load.yaml'
    
    chinook_data = read_chinook_data(chinook_data_file_path)
    parsed_yaml_json = read_table_load_yaml(table_load_file_path)
    table_list = chinook_loader.get_table_list(parsed_yaml_json, 'landing')
    engine = open_create_engine(chinook_db_config)

    
  
    for table in table_list:
        table_data = chinook_loader.build_load_data(chinook_data,\
                                                        parsed_yaml_json, \
                                                        'landing',
                                                        table,
                                                        ) 
        chinook_loader.load_chinook_data(table_data, 'landing', table, engine)

        

    

    # chinook_loader.load__genre(chinook_data, engine)
    # chinook_loader.load__media_type(chinook_data, engine)
    # chinook_loader.load__artist(chinook_data, engine)
    # chinook_loader.load__album(chinook_data, engine)
    # chinook_loader.load__track(chinook_data, engine)
    # chinook_loader.load__employee(chinook_data, engine)
    # chinook_loader.load__customer(chinook_data, engine)
    # chinook_loader.load__invoice(chinook_data, engine)
    # chinook_loader.load__invoice_line(chinook_data, engine)
    # chinook_loader.load__playlist(chinook_data, engine)
    # chinook_loader.load__playlist_track(chinook_data, engine)


if __name__ == "__main__":
    main()
