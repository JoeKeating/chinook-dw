with landing_playlist as (
    select  playlist_id
            ,name   
            ,datetime_loaded  
    from {{ source('landing', 'playlist')}}      
),
transformed_playlist as (
    select  {{ generate_sk('playlist', ['playlist_id']) }} as playlist_sk
            ,cast(playlist_id as bigint) as playlist_source_id
            ,cast(name as varchar(50)) as playlist_name
            ,{{ generate_hashdiff('playlist', ['name']) }} as playlist_hashdiff 
            ,datetime_loaded as  source_data_loaded_datetime
    from    landing_playlist
)

select      playlist_sk
            ,playlist_source_id
            ,playlist_name
            ,playlist_hashdiff 
            ,source_data_loaded_datetime
    from    transformed_playlist

