with payments as (
    SELECT
        *
    from
        { { ref('stg_payments') } }
),
orders as (
    SELECT
        *
    from
        { { ref('stg_orders') } }
),
order_payments as (
    select
        payments.order_id,
        sum(case when status = 'completed' then amount end) as amount
    from
        payments
        join orders using(order_id)
    group by
        1
),
final as (
    SELECT
        o.order_id,
        o.customer_id,
        o.order_date,
        coalesce(op.amount, 0) as amount
    from
        orders o
        left join order_payments op using(order_id)
)
select
    *
from
    final