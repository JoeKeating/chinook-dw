with landing_album as (
        select   album_id
                ,title
                ,artist_id
                ,datetime_loaded
        from    {{ source('landing', 'album') }} 
),
artist_keys as (
        select  artist_sk
                ,artist_source_id
        from    {{ ref('foundation_artist') }}
),
joined_album as (
        select  a.album_id
                ,a.title 
                ,ak.artist_sk
                ,ak.artist_source_id
                ,a.datetime_loaded
        from    landing_album a 
                join artist_keys ak 
        on      a.artist_id =
                ak.artist_source_id 
),
transformed_album as (
        select  {{ dbt_utils.generate_surrogate_key(['title', 'artist_source_id']) }} as album_sk
                ,cast(album_id as bigint) as album_source_id
                ,title as album_title
                ,artist_sk
                ,datetime_loaded as source_data_loaded_datetime
        from    joined_album
)
    
        select  album_sk
                ,album_source_id
                ,album_title
                ,artist_sk
                ,source_data_loaded_datetime
        from    transformed_album
        
