from dotenv import load_dotenv
import os


load_dotenv()

try:
    chinook_secrets = {
        "DB_USER": os.getenv("SNOWFLAKE_USER"),
        "DB_PASSWORD": os.getenv("SNOWFLAKE_PASSWORD"),
        "DB_ACCOUNT": os.getenv("SNOWFLAKE_ACCOUNT"),
        "DB_DATABASE": os.getenv("SNOWFLAKE_DATABASE"),
        "DB_SCHEMA": os.getenv("SNOWFLAKE_SCHEMA"),
        "DB_ROLE": os.getenv("SNOWFLAKE_ROLE"),
        "DB_WAREHOUSE": os.getenv("SNOWFLAKE_WAREHOUSE"),
    }

except Exception as e:
    print(f"An exception has occurred: {e}")
