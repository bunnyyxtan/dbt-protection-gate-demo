select 1 as violation where (select sum(amount) from {{ ref('orders') }}) < 150
