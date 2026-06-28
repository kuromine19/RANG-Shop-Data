select date_trunc('day',created_at) as date,
count(*) as total_orders,
sum(total_amount) as amount_each_payment
from {{ref('stg_orders')}}
where status='delivered'
group by 1
order by 1 desc
