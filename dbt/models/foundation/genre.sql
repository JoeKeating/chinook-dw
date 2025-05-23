with landing_genre as
(
select  genre_id
        ,name
        ,datetime_loaded
from    {{ source('landing', 'genre') }} 
),
transformed_genre as (
select  {{ generate_sk('genre',['genre_id']) }} as genre_sk
        ,cast(genre_id as bigint) as genre_source_id
        ,name as genre_name
        ,{{ generate_hashdiff('genre', ['name']) }} as genre_hashdiff
        ,datetime_loaded as source_data_loaded_datetime
from    landing_genre
)
select  genre_sk
        ,genre_source_id
        ,genre_name 
        ,genre_hashdiff
        ,source_data_loaded_datetime
from    transformed_genre
