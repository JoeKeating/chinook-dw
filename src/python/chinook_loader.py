import logging
from sqlalchemy import Table, MetaData, insert
from sqlalchemy.engine import Engine

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)


def check_for_key(in_dict: dict, key: str) -> bool:
    """Check if key exists in dictionary"""
    try:
        if key in in_dict.keys():
            logging.info("Function check_for_keys: Completed successfully.")
            return True  
        else:
            logging.info("Function check_for_keys: Completed successfully.")
            return False
    except Exception as e:
        logging.info("Function check_for_keys: Error occurred: {e}")
        return False



def check_for_schema(parsed_yaml_json: dict, in_schema: str) -> bool:
    """Check if schema exists in parsed yaml file"""
    try:
        schema_list = [
            schema["name"] for schema in parsed_yaml_json["databases"][0]["schemas"]
        ]
        for schema in schema_list:

            if in_schema in schema_list:
                logging.info(f"Function check_for_schema: Completed successfully")
                return True
            else:
                logging.info(
                    f'Function check_for_schema: Completed successfully: "{in_schema}" not found'
                )
                return False
        return True
    except Exception as e:
        logging.error(f"Function check_for_schema: Error occurred {e}")
        return False


def get_table_list(parsed_yaml_json: dict, in_schema: str) -> list:
    """Get list of tables to load"""
    try:
        db_schemas = [parsed_yaml_json["databases"][0]["schemas"]]

        for schema in db_schemas[0]:
            if check_for_schema(parsed_yaml_json, "landing") and check_for_key(
                schema, "tables"
            ):
                table_list = [table["name"] for table in schema["tables"]]

            else:
                logging.info(f"Function get_table_list: Completed successfully")
                return []
        if table_list:
            logging.info(f"Function get_table_list: Completed successfully")
            return table_list
        else:
            logging.info(f"Function get_table_list: Completed successfully")
            return []
    except Exception as e:
        logging.error(f"Function get_table_list: Error occurred {e}")
        return []


def build_load_data(
    chinook_data: dict, parsed_yaml_json: dict, schema_name: str, table_name: str
) -> dict:
    """Build data payload package for load into db"""
    try:
        for schema in parsed_yaml_json["databases"][0]["schemas"]:
            if schema["name"] == schema_name:
                load_payload_data = {}
                for table in schema["tables"]:
                    if table["name"] == table_name:
                        load_payload_data["name"] = table["name"]
                        load_payload_data["source_name"] = table["source_name"]
                        column_list = [
                            {
                                "name": column["name"],
                                "source_name": column["source_name"],
                            }
                            for column in table["columns"]
                            if column["name"] != "datetime_loaded"
                        ]
                        load_payload_data["columns"] = column_list

                        table_data = [
                            {
                                column["name"]: item[column["source_name"]]
                                for column in load_payload_data["columns"]
                            }
                            for item in chinook_data[load_payload_data["source_name"]]
                        ]
        logging.info("Function build_load_data: Completed successfully")
        return table_data

    except Exception as e:
        logging.error(f"Function build_load_data: Error occurred: {e}")
        return {}


def load_chinook_data(
    table_data: dict, schema_name: str, table_name: str, engine: Engine
) -> bool:
    """Load chinook.genre table"""
    metadata = MetaData()

    # Define table object
    try:
        load_table = Table(
            table_name.upper(),
            metadata,
            autoload_with=engine,
            schema=schema_name.upper(),
        )

    except Exception as e:
        logging.info(f"Function load_chinook_data: Error occurred: {e}")
        return False
    try:
        with engine.begin() as conn:
            conn.execute(insert(load_table), table_data)
            logger.info(
                f"Function load_chinook_data: Completed successfully, loaded {table_name}"
            )
            return True
    except Exception as e:
        logger.error(
            f"Function load_chinook_data: Error occurred loading {table_name}: {e}"
        )
        return False


def main():
    pass


if __name__ == "__main__":
    main()
