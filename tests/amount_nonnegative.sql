select * from {{ ref('orders') }} where amount_usd < 0
