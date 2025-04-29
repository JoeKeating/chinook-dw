with landing_artist as
(
select   artist_id
        ,name
        ,datetime_loaded
from    {{ source('landing', 'artist') }} 
),
transformed_artist as (

select  {{ generate_sk('artist',['artist_id']) }} as artist_sk
        ,cast(artist_id as bigint) as artist_source_id
        ,name as artist_name
        ,{{ generate_hashdiff('artist', ['name']) }} as artist_hashdiff
        ,datetime_loaded as source_data_loaded_datetime
from    landing_artist
)

select  artist_sk
        ,artist_source_id
        ,artist_name 
        ,artist_hashdiff
        ,source_data_loaded_datetime
from    transformed_artist