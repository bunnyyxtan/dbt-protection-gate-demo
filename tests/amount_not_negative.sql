select *
from {{ ref('orders') }}
where not (amount >= 0)
