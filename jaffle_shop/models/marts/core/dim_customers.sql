WITH customers AS (
       SELECT
              *
       FROM
              {{ ref('stg_customers') }}
),
orders AS (
       SELECT
              *
       FROM
              {{ ref('fct_orders') }}
),
customer_orders AS (
       SELECT
              customer_id,
              MIN(order_date) AS first_order_date,
              MAX(order_date) AS most_recent_order_date,
              COUNT(order_id) AS number_of_orders,
              SUM(amount) AS lifetime_value
       FROM
              orders
       GROUP BY
              1
),
FINAL AS (
       SELECT
              C.customer_id,
              C.first_name,
              C.last_name,
              co.first_order_date,
              co.most_recent_order_date,
              COALESCE(
                     co.number_of_orders,
                     0
              ) AS number_of_orders,
              co.lifetime_value
       FROM
              customers C
              LEFT JOIN customer_orders co USING (customer_id)
)
SELECT
       *
FROM
       FINAL
