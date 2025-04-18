import json
import logging
from src.python.config.chinook_secrets import chinook_secrets
from sqlalchemy import create_engine, Table, MetaData, insert, func
from sqlalchemy.engine import Engine


logging.basicConfig(
                        level=logging.INFO,
                        format = '%(asctime)s - %(levelname)s - %(message)s'

    )

logger = logging.getLogger(__name__)

def open_create_engine(secrets: dict) -> Engine | None:
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
                f'{db_database}/{db_schema}?role={db_role}&warehouse={db_warehouse}&timezone=America/New_York')
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
    
  
def load__genre(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.genre table"""
    metadata = MetaData()
    # Extract genre data
    genre_data = [
        {'genre_id': item['GenreId'], 'name': item['Name']}
        for item in chinook_data['Genre']
    ]
    
    # Define table object
    try:
        genre_table = Table(
            'GENRE',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'genre_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(genre_table), genre_data)
            logger.info(f'Successfully loaded genre_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into genre table: {e}')
        return False
        

def load__media_type(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.media_type table"""
    metadata = MetaData()
    # Extract media_type data
    media_type_data = [
        {'media_type_id': item['MediaTypeId'], 'name': item['Name']}
        for item in chinook_data['MediaType']
    ]
    
    
    # Define table object
    try:
        media_type_table = Table(
            'media_type',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'media_type_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(media_type_table), media_type_data)
            logger.info(f'Successfully loaded media_type_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into media_type table: {e}')
        return False



def load__artist(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.artist table"""
    metadata = MetaData()
    # Extract artist data
    artist_data = [
        {'artist_id': item['ArtistId'], 'name': item['Name']}
        for item in chinook_data['Artist']
    ]
    
    
    # Define table object
    try:
        artist_table = Table(
            'ARTIST',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'artist_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(artist_table), artist_data)
            logger.info(f'Successfully loaded artist_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into artist table: {e}')
        return False

def load__album(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.album table"""
    metadata = MetaData()
    # Extract album data
    album_data = [
        {'album_id': item['AlbumId'], 'title': item['Title'], 'artist_id': item['ArtistId']}
        for item in chinook_data['Album']
    ]
    
    
    # Define table object
    try:
        album_table = Table(
            'ALBUM',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'album_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(album_table), album_data)
            logger.info(f'Successfully loaded album_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into album table: {e}')
        return False

def load__track(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.track table"""
    metadata = MetaData()
    # Extract track data
    track_data = [
        {'track_id': item['TrackId'] 
         ,'name': item['Name']
         ,'album_id': item['AlbumId']
         ,'media_type_id':item['MediaTypeId']
         ,'genre_id':item['GenreId']
         ,'composer':item['Composer']
         ,'milliseconds':item['Milliseconds']
         ,'bytes':item['Bytes']
         ,'unit_price':item['UnitPrice']}
        for item in chinook_data['Track']
    ]
    
    
    # Define table object
    try:
        track_table = Table(
            'TRACK',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'track_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(track_table), track_data)
            logger.info(f'Successfully loaded track_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into track table: {e}')
        return False

def load__employee(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.employee table"""
    metadata = MetaData()
    # Extract employee data
    employee_data = [
        {'employee_id': item['EmployeeId'] 
         ,'last_name': item['LastName']
         ,'first_name': item['FirstName']
         ,'title':item['Title']
         ,'reports_to':item['ReportsTo']
         ,'birth_date':item['BirthDate']
         ,'hire_date':item['HireDate']
         ,'address':item['Address']
         ,'city':item['City']
         ,'state':item['State']
         ,'country':item['Country']
         ,'postal_code':item['PostalCode']
         ,'phone':item['Phone']
         ,'fax':item['Fax']
         ,'email':item['Email']
         }
        for item in chinook_data['Employee']
    ]
    
    
    # Define table object
    try:
        employee_table = Table(
            'EMPLOYEE',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'employee_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(employee_table), employee_data)
            logger.info(f'Successfully loaded employee_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into employee table: {e}')
        return False

def load__customer(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.customer table"""
    metadata = MetaData()
    # Extract customer data
    customer_data = [
        {'customer_id': item['CustomerId'] 
         ,'first_name': item['FirstName']
         ,'last_name': item['LastName']
         ,'company':item['Company']
         ,'address':item['Address']
         ,'city':item['City']
         ,'state':item['State']
         ,'country':item['Country']
         ,'postal_code':item['PostalCode']
         ,'phone':item['Phone']
         ,'fax':item['Fax']
         ,'email':item['Email']
         ,'support_rep_id':item['SupportRepId']
         }
        for item in chinook_data['Customer']
    ]
    
    # Define table object
    try:
        customer_table = Table(
            'CUSTOMER',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'customer_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(customer_table), customer_data)
            logger.info(f'Successfully loaded customer_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into customer table: {e}')
        return False

def load__invoice(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.invoice table"""
    metadata = MetaData()
    # Extract invoice data
    invoice_data = [
        {'invoice_id': item['InvoiceId'] 
         ,'customer_id': item['CustomerId']
         ,'invoice_date': item['InvoiceDate']
         ,'billing_address':item['BillingAddress']
         ,'billing_city':item['BillingCity']
         ,'billing_state':item['BillingState']
         ,'billing_country':item['BillingCountry']
         ,'billing_postal_code':item['BillingPostalCode']
         ,'total':item['Total']
         }
        for item in chinook_data['Invoice']
    ]
    
    # Define table object
    try:
        invoice_table = Table(
            'INVOICE',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'invoice_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(invoice_table), invoice_data)
            logger.info(f'Successfully loaded invoice_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into invoice table: {e}')
        return False

def load__invoice_line(chinook_data: dict, engine: Engine) -> bool :
    """Load chinook.invoice_line table"""
    metadata = MetaData()
    # Extract invoice_line data
    invoice_line_data = [
        {'invoice_line_id': item['InvoiceLineId'] 
         ,'invoice_id': item['InvoiceId']
         ,'track_id': item['TrackId']
         ,'unit_price':item['UnitPrice']
         ,'quantity':item['Quantity']
         }
        for item in chinook_data['InvoiceLine']
    ]
    
    # Define table object
    try:
        invoice_line_table = Table(
            'INVOICE_LINE',
            metadata,
            autoload_with=engine,
            schema='LANDING'
        )
        
    except Exception as e:
        print(f'invoice_line_table failed: {e}')
        return False

    try:
        with engine.begin() as conn:
            conn.execute(insert(invoice_line_table), invoice_line_data)
            logger.info(f'Successfully loaded invoice_line_table')
            return True
    except Exception as e:
        logger.error(f'Failed to insert into invoice_line table: {e}')
        return False

def load__playlist(chinook_data: dict, engine: Engine) -> bool :
    pass

def load__playlistTrack(chinook_data: dict, engine: Engine) -> bool :
    pass






def main():
    
    
    url = '/Users/jpk/Projects/chinook-dw/data/ChinookData.json'
    chinook_data = read_chinook_data(url)
    engine = open_create_engine(chinook_secrets)
    
    # load__genre(chinook_data, engine)
    # load__media_type(chinook_data, engine)
    # load__artist(chinook_data, engine)
    # load__album(chinook_data, engine)
    # load__track(chinook_data, engine)
    # load__employee(chinook_data, engine)
    # load__customer(chinook_data, engine)
    # load__invoice(chinook_data, engine)
    load__invoice_line(chinook_data, engine)




    

if __name__ == '__main__':
    main()

