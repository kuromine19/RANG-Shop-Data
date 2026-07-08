SELECT
    s.session_id,
    s.device_type,
    s.referrer,
    s.session_start,
    s.session_end,
    s.session_duration_minutes,

    COUNT(b.log_id) AS total_events,
SUM(CASE WHEN b.event_type = 'page_view'
        THEN 1 ELSE 0 END) AS page_views,    
SUM(CASE WHEN b.event_type = 'product_view' 
        THEN 1 ELSE 0 END) AS product_views,
    SUM(CASE WHEN b.event_type = 'add_to_cart' 
        THEN 1 ELSE 0 END) AS add_to_carts,

    MAX(CASE WHEN o.order_id IS NOT NULL 
        THEN 1 ELSE 0 END) AS has_converted,
    SUM(o.total_amount) AS total_spent

FROM {{ ref('stg_sessions') }} s
LEFT JOIN {{ ref('stg_behavior_logs') }} b
    ON s.session_id = b.session_id
LEFT JOIN {{ ref('stg_orders') }} o
    ON s.session_id = o.session_id

GROUP BY 1, 2, 3, 4, 5, 6
