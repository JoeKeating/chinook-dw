with landing_playlist_track as (
    select  playlist_id
            ,track_id
            ,datetime_loaded
    from {{ source('playlist_track') }}
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
    select  playlist_source_id
            ,playlist_sk
            ,track_source_id
            ,track_sk
            ,datetime_loaded
    from    landing_playlist_track pt 
            join track_keys tk 
    on      pt.
)

transformed_playlist_track as (
    select  {{ generate_sk('playlist_track'
                        , ['playlist_id' ,'track_id']) }} as playlist_track_sk
            ,
)