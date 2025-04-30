with landing_track as (
    select  track_id        
            ,name           
            ,album_id       
            ,media_type_id  
            ,genre_id       
            ,composer       
            ,milliseconds   
            ,bytes          
            ,unit_price     
            ,datetime_loaded  
    from {{source('landing', 'track')}} 
),
media_type_keys as (
    select  media_type_sk
            ,media_type_source_id
    from    {{ ref('media_type') }}
),
album_keys as (
    select  album_sk
            ,album_source_id
    from    {{ ref('album') }}
),
genre_keys as (
    select  genre_sk
            ,genre_source_id
    from    {{ ref('genre') }}
),
joined_track as (
    select  t.track_id
            ,t.name
            ,ak.album_sk
            ,ak.album_source_id
            ,mtk.media_type_sk
            ,mtk.media_type_source_id
            ,gk.genre_sk
            ,gk.genre_source_id
            ,composer
            ,milliseconds
            ,bytes
            ,unit_price
            ,datetime_loaded
    from    landing_track t 
            join album_keys ak 
    on      t.album_id = 
            ak.album_source_id
            join genre_keys gk
    on      t.genre_id =
            gk.genre_source_id
            join media_type_keys mtk
    on      t.media_type_id =
            mtk.media_type_source_id
),
transformed_track as (
    select {{ generate_sk('track', ['track_id']) }} as track_sk
            ,cast(track_id as bigint) as track_source_id
            ,cast(name as varchar(50)) as track_name
            ,cast(album_source_id as bigint) as album_source_id
            ,cast(media_type_source_id as bigint) as media_type_source_id
            ,cast(genre_source_id  as bigint) as genre_source_id
            ,album_sk
            ,media_type_sk
            ,genre_sk
            ,cast(composer as varchar(255)) as track_composer
            ,cast(milliseconds as bigint) as track_length_milliseconds
            ,cast(unit_price as number(10,2)) as track_unit_price
            ,{{ generate_hashdiff('track', ['name'
                                            ,'media_type_source_id'
                                            ,'genre_source_id'
                                            ,'track_composer'
                                            ,'track_length_milliseconds'
                                            ,'track_unit_price']) }} as track_hashdiff
            , datetime_loaded as source_data_loaded_datetime
    from    joined_track

)

select  track_sk
        ,track_source_id
        ,track_name
        ,album_source_id
        ,album_sk
        ,media_type_source_id
        ,media_type_sk
        ,genre_source_id
        ,genre_sk
        ,track_composer
        ,track_length_milliseconds
        ,track_unit_price
        ,track_hashdiff
        ,source_data_loaded_datetime
from    transformed_track

