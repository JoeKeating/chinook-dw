from boto3 import Session
from sqlalchemy import create_engine
from sqlalchemy.engine import Engine
import logging
import json

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s"
)

logger = logging.getLogger(__name__)

def get_connection_string(profile_name: str, secret_name: str) -> str:
    """Get connection string fro AWS Secrets"""
    try:
        session = Session(profile_name = profile_name)
        client = session.client(service_name="secretsmanager", region_name="us-east-2")
    except Exception as e:
        logging.error(
            f"Function get_chinook_loader_secret: Error occurred establishing {e}"
        )
        return ''
    try:
        get_secret_value_response = client.get_secret_value(
            SecretId= secret_name
        )
        parsed_secrets = json.loads(get_secret_value_response["SecretString"])
        logging.info(f"Function get_chinook_loader_secret: Completed successfully.")
        return parsed_secrets['chinook_loader_conn']
    except Exception as e:
        logging.error(
            f"Function get_chinook_loader_secret: Error occurred establishing {e}"
        )
        return ''

def create_chinook_dw_engine(connect_string: str) -> Engine | bool:
    """Open a connection to Snowflake"""

    try:
        engine = create_engine(connect_string)
        logging.info(f'Function create_chinook_dw_engine: Completed successfully')
        return engine

    except Exception as e:
        logging.error(f"Function create_chinook_dw_engine: Error occurred {e} ")
        return False
    
def main():
    pass
if __name__ == '__main__':
    main()