import json
import logging
import yaml
import src.python.chinook_loader as chinook_loader
import src.python.utils.db_connection_helpers as db_connection_helpers
import argparse


logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)

def read_chinook_data(file_path: str) -> dict:
    """Read in chinook json"""

    try:
        with open(file_path, "r") as in_file:
            logging.info(f'Function read_chinook_data: Completed successfully')
            return json.load(in_file)
    except FileNotFoundError as e:
        logger.error(f"Function read_chinook_data: Error occurred {e}")
        return {}
    except Exception as e:
        logger.error(f"Function read_chinook_data: Error occurred {e}")
        return {}


def read_table_load_yaml(file_path: str) -> dict:
    """Read in table_load.yaml"""
    try:
        with open(file_path, "r") as in_file:
            parsed_config_data = yaml.safe_load(in_file)
            logging.info(f'Function read_table_load_yaml: Completed successfully')
            return parsed_config_data
    except FileNotFoundError as e:
        logger.error(f"Function read_table_load_yaml: Error occurred {e}")
        return {}
    except Exception as e:
        logger.error(f"Function read_table_load_yaml: Error occurred {e}")
        return {}

def run_data_load():
    '''Run full data load'''
    try:
        chinook_data_file_path = r"/Users/jpk/Projects/chinook-dw/data/ChinookData.json"
        table_load_file_path =  r"/Users/jpk/Projects/chinook-dw/src/python/config/table_load.yaml"
        

        chinook_data = read_chinook_data(chinook_data_file_path)
        parsed_yaml_json = read_table_load_yaml(table_load_file_path)
        table_list = chinook_loader.get_table_list(parsed_yaml_json, "landing")
        connect_string =  db_connection_helpers.get_connection_string("chinook-loader-secret-reader",
                                                                        "chinook-connection-strings")
        engine = db_connection_helpers.create_chinook_dw_engine(connect_string)
        for table in table_list:
            table_data = chinook_loader.build_load_data(
                chinook_data,
                parsed_yaml_json,
                "landing",
                table,
            )
            chinook_loader.load_chinook_data(table_data, "landing", table, engine)
        logging.info(f'Function main: Completed successfully') 
        return True   
    except Exception as e:
        logging.error(f'Function main: Error occurred: {e}')
        return False




def main():
    parser = argparse.ArgumentParser(
        description="Chinook Loader CLI"
    )
    parser.add_argument(
        "command",
        choices=["load"],
        help="Command to run full chinook dw load (only load is supported now)"
    )
    args = parser.parse_args()
    if args.command == "load":
        run_data_load()
        return True
    else:
        logging.error("Invalid Command")
        return False
    


if __name__ == "__main__":
    main()
