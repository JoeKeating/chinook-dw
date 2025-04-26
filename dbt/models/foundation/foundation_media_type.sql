with landing_media_type as
(
select   media_type_id
        ,name
        ,datetime_loaded
from    {{ source('landing', 'media_type') }} 
),
transformed_media_type as (

select  {{ dbt_utils.generate_surrogate_key(['name']) }} as media_type_sk
        ,cast(media_type_id as bigint) as media_type_source_id
        ,name as media_type_name
        ,{{ generate_hashdiff('media_type', ['name']) }} as media_type_hashdiff
        ,datetime_loaded as source_data_loaded_datetime
from    landing_media_type
)

select  media_type_sk
        ,media_type_source_id
        ,media_type_name 
        ,media_type_hashdiff
        ,source_data_loaded_datetime
from    transformed_media_type 