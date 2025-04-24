with landing_artist as
(
select   artist_id
        ,name
        ,datetime_loaded
from    {{ source('landing', 'artist') }} 
),
transformed_artist as (

select  {{ dbt_utils.generate_surrogate_key(['name']) }} as artist_sk
        ,cast(artist_id as bigint) as artist_source_id
        ,name as artist_name
        ,datetime_loaded as source_data_loaded_datetime
from    landing_artist
)

select  artist_sk
        ,artist_source_id
        ,artist_name 
        ,source_data_loaded_datetime
from    transformed_artist