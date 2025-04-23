with landing_genre as
(
select  cast(genre_id as bigint) as genre_id
        ,name as name
        ,datetime_loaded
from    {{ source('landing', 'genre') }} 
)

select  genre_id 
        ,name 
        ,datetime_loaded
from    landing_genre