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
    from    {{ ref('foundation_media_type') }}
),
album_keys as (
    select  album_sk
            ,album_source_id
    from    {{ ref('foundation_album') }}
),
genre_keys as (
    select  genre_sk
            ,genre_source_id
    from    {{ ref('foundation_genre') }}
),
joined_track as (
    select  t.track_id
            ,t.name
            ,ak.album_sk
            ,ak.album_source_id
            ,mk.media_type_sk
            ,mk.media_type_source_id
            ,g.genre_sk
            ,g.genre_source_id
    from    landing_track t 
            join album_keys a 
    on      t.album_id = 
            a.album_source_id
            join genre_keys 
    on      t.genre_id =
            g.genre_source_id
    on      t.media_type_id =
            mk.media_type_source_id
),

