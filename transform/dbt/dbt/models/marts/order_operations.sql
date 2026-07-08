SELECT
    o.order_id,
    o.status,
    o.payment_method,
    o.total_amount,
    o.order_created_at,

    MIN(CASE WHEN sh.status = 'confirmed' 
        THEN sh.changed_at END)             AS confirmed_at,
    MIN(CASE WHEN sh.status = 'delivering' 
        THEN sh.changed_at END)             AS delivering_at,
    MIN(CASE WHEN sh.status = 'delivered' 
        THEN sh.changed_at END)             AS delivered_at,
    MIN(CASE WHEN sh.status = 'cancelled' 
        THEN sh.changed_at END)             AS cancelled_at,

    EXTRACT(EPOCH FROM (
        MIN(CASE WHEN sh.status = 'delivered' 
            THEN sh.changed_at END) - o.order_created_at
    )) / 60                                 AS total_processing_minutes

FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_order_status_history') }} sh
    ON o.order_id = sh.order_id

GROUP BY 1, 2, 3, 4, 5
