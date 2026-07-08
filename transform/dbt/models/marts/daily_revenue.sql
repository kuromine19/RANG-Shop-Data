select
order_created_at::date as record_date,
payment_method,
count(*) as total_orders,
sum(total_amount) as revenue,
round(avg(total_amount),2) as avg_order_value

from {{ref('stg_orders')}}
where status='delivered'
group by 1,2
order by 1 desc

