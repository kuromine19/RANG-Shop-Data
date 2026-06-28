select
id as log_id,
session_id,
event_type,
product_id,
product_name,
data,
page_url,

--extract from JSONB
data->>'deviceType' as device_type,
data->>'category' as category,

cast(created_at as timestamp) as event_at

from {{ source('app_events','behavior_logs')}}

where 
ip_address not in ('::1','127.0.0.1') --remove internal ip
and event_type in (
'page_view','product_view','add_to_cart',
'remove_from_cart','cart_view', 
'checkout_start','checkout_complete'
)
