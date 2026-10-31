select * from {{ ref('orders') }} where amount < 0
