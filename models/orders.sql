select * from (values
    (1, 10, 100.00, 'placed'),
    (2, 20, 25.00, 'shipped'),
    (3, 10, 50.00, 'placed')
) as t(order_id, customer_id, amount, status)
