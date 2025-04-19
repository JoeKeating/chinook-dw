import os
import logging
import json
from dotenv import load_dotenv
from boto3 import Session


logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)


load_dotenv()

try:
    chinook_db_config = {
        "DB_ACCOUNT": os.getenv("SNOWFLAKE_ACCOUNT"),
        "DB_DATABASE": os.getenv("SNOWFLAKE_DATABASE"),
        "DB_SCHEMA": os.getenv("SNOWFLAKE_SCHEMA"),
        "DB_ROLE": os.getenv("SNOWFLAKE_ROLE"),
        "DB_WAREHOUSE": os.getenv("SNOWFLAKE_WAREHOUSE"),
    }

except Exception as e:
    print(f"An exception has occurred: {e}")


def get_chinook_loader_secret() -> dict | bool:
    try:
        session = Session(profile_name="chinook-loader-secret-reader")
        client = session.client(service_name="secretsmanager", region_name="us-east-2")
    except Exception as e:
        logging.error(
            f"An error occurred establishing the " "connection to" f"AWS: {e}"
        )
        return False
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId="chinook_loader_secret"
        )
        logging.info("Retrieved chinook_loader_secret")
        parsed_secrets = json.loads(get_secret_value_response["SecretString"])
        return parsed_secrets
    except Exception as e:
        logging.error(f"Error retrieving chinook_loader_secret {e}")
        return False


def main():
    pass


if __name__ == "__main__":
    main()
