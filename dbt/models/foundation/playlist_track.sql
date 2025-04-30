with landing_playlist_track as (
    select  playlist_id
            ,track_id
            ,datetime_loaded
    from {{ source('landing', 'playlist_track') }}
),
playlist_keys as (
    select  playlist_source_id
            ,playlist_sk
    from    {{ ref('playlist') }}
),
track_keys as (
    select  track_source_id
            ,track_sk
    from    {{ ref('track') }}
),
joined_playlist_track as (
    select  pk.playlist_source_id
            ,pk.playlist_sk
            ,tk.track_source_id
            ,tk.track_sk
            ,pt.datetime_loaded
    from    landing_playlist_track pt 
    join    track_keys tk 
    on      pt.track_id =
            tk.track_source_id
    join    playlist_keys pk 
    on      pt.playlist_id =
            pk.playlist_source_id
        

),

transformed_playlist_track as (
    select  {{ generate_sk('playlist_track'
                        , ['playlist_source_id' ,'track_source_id']) }} as playlist_track_sk
            ,cast(playlist_source_id as bigint) as playlist_source_id
            ,playlist_sk
            ,cast(track_source_id as bigint) as track_source_id
            ,track_sk
            ,datetime_loaded as source_data_loaded_datetime
    from    joined_playlist_track

)

select      playlist_track_sk
            ,playlist_source_id
            ,playlist_sk
            ,track_source_id
            ,track_sk
            ,source_data_loaded_datetime
    from    transformed_playlist_track