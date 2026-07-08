select
    id                  as order_id,
    session_id,
    customer_name,
    customer_email,
    customer_phone,
    shipping_address,
    payment_method,
    status,
    cast(total_amount as numeric(10,2)) as total_amount,
    cast(created_at as Timestamp) as order_created_at,
    cast(updated_at as timestamp) as order_updated_at
from {{ source('app', 'orders') }}
where customer_name is not null
and customer_phone is not null
and total_amount>0
and status!='test'
