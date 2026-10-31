select * from {{ ref('orders') }} where amount < -1000
