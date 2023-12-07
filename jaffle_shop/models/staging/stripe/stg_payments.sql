WITH payments AS (
    SELECT
        id AS payment_id,
        order_id,
        payment_method,
        amount
    FROM
        { { source('stripe', 'payments') } }
)
SELECT
    *
FROM
    payments