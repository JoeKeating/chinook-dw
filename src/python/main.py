import json
import logging
from src.python.config.chinook_secrets import chinook_secrets
from sqlalchemy import create_engine, text
from sqlalchemy.engine import Connection, Engine

logging.basicConfig(
                        level=logging.INFO,
                        format = '%(asctime)s - %(levelname)s - %(message)s'

    )

logger = logging.getLogger(__name__)

def open_db_connection(secrets: dict) -> Engine | None:
    '''Open a connection to Snowflake'''
    
    db_user         = secrets['DB_USER']
    db_password     = secrets['DB_PASSWORD']
    db_account      = secrets['DB_ACCOUNT']
    db_database     = secrets['DB_DATABASE']
    db_schema       = secrets['DB_SCHEMA']
    db_role         = secrets['DB_ROLE']
    db_warehouse    = secrets['DB_WAREHOUSE']
    try:
        engine = create_engine(
                f'snowflake://{db_user}:{db_password}@{db_account}/'
                f'{db_database}/{db_schema}?role={db_role}&warehouse={db_warehouse}')
        return engine

    except Exception as e:
        print(f'An exception occurred creating connection:{e} ')
        return None


    

def read_chinook_data(file_path: str) -> dict | None:
    """ Read in chinook json """

    try:
        with open(file_path, 'r') as in_file:
            return  json.load(in_file)
    except FileNotFoundError as e:
        logger.error(f'{e}')
        return None
    except Exception as e:
        logger.error(f'An error occurred reading the file: {e}')
        return None

def load__genre(chinook_data: dict) -> bool :
    max_key = max(chinook_data.keys())
    insert_query = f'insert into chinook.genres (genre_id, name) values '
    for insert_item in chinook_data['Genre']:
        print(insert_item)
        if insert_item['GenreId'] != max_key:
            insert_query += f'("{insert_item['GenreId']}", "{insert_item['Name']}"),\n'
        else:
            insert_query += f'("{insert_item['GenreId']}", "{insert_item['Name']}")'

    print(insert_query)
    return True
        
    
    # with engine.connect() as connection:
    #     result = connection.execute(text("SELECT current_version()")).fetchone()
        
    

def load__media_type() -> bool :
    pass

def load__artist() -> bool :
    pass

def load__album() -> bool :
    pass

def load__track() -> bool :
    pass

def load__employee() -> bool :
    pass

def load__customer() -> bool :
    pass

def load__invoice() -> bool :
    pass

def load__invoice_line() -> bool :
    pass

def load__playlist() -> bool :
    pass

def load__playlistTrack() -> bool :
    pass






def main():
    
    # with engine.connect() as connection:
    #     result = connection.execute(text("SELECT current_version()")).fetchone()
    #     print(f'-------> {result[0]}')
    url = '/Users/jpk/Projects/chinook-dw/data/ChinookData.json'
    chinook_data = read_chinook_data(url)

    load__genre(chinook_data)




    

if __name__ == '__main__':
    main()

