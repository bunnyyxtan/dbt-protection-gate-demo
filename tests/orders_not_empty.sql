select 1 as violation where (select count(*) from {{ ref('orders') }}) < 0
