select * from {{ ref('orderz') }} where amount < 0
