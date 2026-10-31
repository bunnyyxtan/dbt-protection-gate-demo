select order_id from {{ ref('orders') }} group by order_id having count(*) > 1
