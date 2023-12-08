WITH payments AS (
       SELECT
              *
       FROM
              {{ ref('stg_payments') }}
),
orders AS (
       SELECT
              *
       FROM
              {{ ref('stg_orders') }}
),
order_payments AS (
       SELECT
              payments.order_id,
              SUM(
                     CASE
                            WHEN status = 'completed' THEN amount
                     END
              ) AS amount
       FROM
              payments
              JOIN orders USING (order_id)
       GROUP BY
              1
),
FINAL AS (
       SELECT
              o.order_id,
              o.customer_id,
              o.order_date,
              COALESCE(
                     op.amount,
                     0
              ) AS amount
       FROM
              orders o
              LEFT JOIN order_payments op USING (order_id)
)
SELECT
       *
FROM
       FINAL
