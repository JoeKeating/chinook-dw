import json
import logging
import yaml
from boto3 import Session
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
import src.python.chinook_loader as chinook_loader


logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)


def get_chinook_loader_secret() -> dict:
    try:
        session = Session(profile_name="chinook-loader-secret-reader")
        client = session.client(service_name="secretsmanager", region_name="us-east-2")
    except Exception as e:
        logging.error(
            f"Function get_chinook_loader_secret: Error occurred establishing {e}"
        )
        return {}
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId="chinook_loader_secret"
        )
        parsed_secrets = json.loads(get_secret_value_response["SecretString"])
        logging.info(f"Function get_chinook_loader_secret: Completed successfully.")
        return parsed_secrets
    except Exception as e:
        logging.error(
            f"Function get_chinook_loader_secret: Error occurred establishing {e}"
        )
        return {}


def build_chinook_dw_connection_string(parsed_yaml_json: dict) -> str:
    """Get chinook connect data from table_load.yaml"""
    secrets = get_chinook_loader_secret()
    db_user = secrets["username"]
    db_password = secrets["password"]
    db_account = parsed_yaml_json["connection_string"]["account"]
    db_database = parsed_yaml_json["connection_string"]["database"]
    db_schema = parsed_yaml_json["connection_string"]["schema"]
    db_role = parsed_yaml_json["connection_string"]["role"]
    db_warehouse = parsed_yaml_json["connection_string"]["warehouse"]
    db_timezone = parsed_yaml_json["connection_string"]["timezone"]

    chinook_dw_connection_string = (
        f"snowflake://{db_user}:{db_password}@{db_account}/"
        f"{db_database}/{db_schema}?role={db_role}&warehouse={db_warehouse}&timezone={db_timezone}"
    )
    return chinook_dw_connection_string


def open_create_engine(connect_string: str) -> Engine | bool:
    """Open a connection to Snowflake"""

    try:
        engine = create_engine(connect_string)
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
        with open(file_path, "r") as in_file:
            parsed_config_data = yaml.safe_load(in_file)
            return parsed_config_data

    except FileNotFoundError as e:
        logger.error(f"An error occurred reading the file: {e}")
        return {}
    except Exception as e:
        logger.error(f"An error occurred reading the file: {e}")
        return {}


def main():

    chinook_data_file_path = r"/Users/jpk/Projects/chinook-dw/data/ChinookData.json"
    table_load_file_path = (
        r"/Users/jpk/Projects/chinook-dw/src/python/config/table_load.yaml"
    )

    chinook_data = read_chinook_data(chinook_data_file_path)
    parsed_yaml_json = read_table_load_yaml(table_load_file_path)
    table_list = chinook_loader.get_table_list(parsed_yaml_json, "landing")
    connect_string = build_chinook_dw_connection_string(parsed_yaml_json)
    engine = open_create_engine(connect_string)
    print(connect_string)

    for table in table_list:
        table_data = chinook_loader.build_load_data(
            chinook_data,
            parsed_yaml_json,
            "landing",
            table,
        )
        chinook_loader.load_chinook_data(table_data, "landing", table, engine)


if __name__ == "__main__":
    main()
