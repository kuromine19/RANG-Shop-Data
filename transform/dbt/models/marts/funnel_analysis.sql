WITH events AS (
    SELECT
        session_id,
        MAX(CASE WHEN event_type = 'page_view' 
            THEN 1 ELSE 0 
	END) AS has_page_view,
        MAX(CASE WHEN event_type = 'product_view' 
            THEN 1 ELSE 0 
	END) AS has_product_view,
        MAX(CASE WHEN event_type = 'add_to_cart' 
            THEN 1 ELSE 0 
	END) AS has_add_to_cart,
        MAX(CASE WHEN event_type = 'checkout_start' 
            THEN 1 ELSE 0 
	END) AS has_checkout_start,
        MAX(CASE WHEN event_type = 'checkout_complete' 
            THEN 1 ELSE 0 
	END) AS has_checkout_complete
    FROM {{ ref('stg_behavior_logs') }}
    GROUP BY 1
),

orders AS (
    SELECT DISTINCT session_id, 1 AS has_order
    FROM {{ ref('stg_orders') }}
    WHERE status = 'delivered'
)

SELECT
    COUNT(*) AS total_sessions,
    SUM(has_page_view) AS page_view,
    SUM(has_product_view) AS product_view,
    SUM(has_add_to_cart) AS add_to_cart,
    SUM(has_checkout_start) AS checkout_start,
    SUM(has_checkout_complete) AS checkout_complete,
    COUNT(o.has_order) AS delivered,

    ROUND(100.0 * SUM(has_product_view) 
        / NULLIF(SUM(has_page_view), 0), 2) AS view_to_product_rate,
    ROUND(100.0 * SUM(has_add_to_cart) 
        / NULLIF(SUM(has_product_view), 0), 2) AS product_to_cart_rate,
    ROUND(100.0 * SUM(has_checkout_start) 
        / NULLIF(SUM(has_add_to_cart), 0), 2) AS cart_to_checkout_rate,
    ROUND(100.0 * COUNT(o.has_order) 
        / NULLIF(SUM(has_checkout_complete), 0), 2) AS checkout_to_delivered_rate

FROM events e
LEFT JOIN orders o ON e.session_id = o.session_id
