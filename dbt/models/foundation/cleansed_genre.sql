with landing_genre as(

    select  genre_id
            ,name 
            ,datetime_loaded
    from {{ source('landing', 'genre') }}
           
)

select  {{ dbt_utils.generate_surrogate_key(['name']) }} as genre_sk
        ,cast(genre_id as bigint) as source_id
        ,name 
        ,datetime_loaded as source_data_loaded_datetime
from landing_genre
