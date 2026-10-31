select * from {{ ref('orders') }} where status not in ('placed', 'shipped')
