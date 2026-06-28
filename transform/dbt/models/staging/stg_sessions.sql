select
id as session_id,
device_type,
referrer,
cast(first_seen as timestamp) as session_start,
cast(last_seen as timestamp) as session_end,

--calculate duration
extract(epoch from(last_seen - first_seen) / 60 
as session_duration_minutes


from {{source('app_events','sessions')}}
where first_seen is not null
