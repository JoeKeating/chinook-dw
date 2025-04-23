with landing_media_type as
(
select  cast(media_type_id as bigint) as media_type_id
        ,name as name
        ,datetime_loaded
from    {{ source('landing', 'media_type') }} 
)

select  media_type_id 
        ,name 
        ,datetime_loaded
from    landing_media_type