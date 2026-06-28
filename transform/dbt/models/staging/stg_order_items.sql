select
id as order_item_id,
order_id,
product_name,
cast(product_price as numeric(10,2)) as unit_price,
quantity,
cast(subtotal as numeric(10,2)) as subtotal,

--validate subtotal
case
when quantity*product_price=subtotal then True
else False
end as is_valid_subtotal

from {{source('app','order_items')}}
where quantity>0
