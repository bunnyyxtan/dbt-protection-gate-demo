select o.* from {{ ref('orders') }} o left join {{ ref('customers') }} c using (customer_id) where c.customer_id is null
