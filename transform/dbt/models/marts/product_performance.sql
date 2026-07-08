select 
oi.product_id,
oi.product_name,
p.category,
count(distinct oi.order_id) as total_orders,
sum(oi.quantity) as total_quantity_sold,
sum(oi.subtotal) as total_revenue,
round(avg(oi.unit_price),2) as avg_selling_price,
count(case when o.status='cancelled' then 1 end) as cancelled_orders
from {{ref('stg_order_items')}} oi
left join {{ref('stg_orders')}} o
on oi.order_id=o.order_id
left join {{source('app','products')}} p
on oi.product_id=p.id
group by 1,2,3
order by total_revenue desc



