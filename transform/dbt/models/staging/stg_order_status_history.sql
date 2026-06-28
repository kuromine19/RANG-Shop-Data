select 
id as history_id,
order_id,
status,
cast(changed_at as timestamp) as changed_at,
lead(changed_at) over(
	partition by order_id
	order by changed_at
) as status_trans_time,
row_number() over(
	partition by order_id
	order_by changed_at
) as status_sequence
from {{source('app','order_status_history')}}
where status is not null
and status !='test'
