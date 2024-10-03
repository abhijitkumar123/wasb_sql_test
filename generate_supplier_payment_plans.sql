WITH invoices_summary AS (
    SELECT
        s.supplier_id,
        s.name AS supplier_name,
        SUM(i.invoice_ammount) AS total_invoice_amount,
        MAX(i.due_date) AS last_due_date
    FROM
        memory.default.invoice i
    JOIN
        memory.default.supplier s
    ON
        i.supplier_id = s.supplier_id
    GROUP BY
        s.supplier_id, s.name
),
payments_schedule AS (
    SELECT 
        supplier_id,
        supplier_name,
        total_invoice_amount,
        date_trunc('month', current_date) AS payment_start_date,
        last_due_date,
        CEIL(total_invoice_amount / (date_diff('month', current_date, last_due_date) + 1)) AS monthly_payment
    FROM 
        invoices_summary
    WHERE 
        last_due_date > current_date
),
monthly_payments AS (
    SELECT
        supplier_id,
        supplier_name,
        monthly_payment AS payment_amount,
        total_invoice_amount - SUM(monthly_payment) OVER (PARTITION BY supplier_id ORDER BY date_add('month', n, payment_start_date)) AS balance_outstanding,
        CASE 
            WHEN n = 0 THEN 'End of this month'
            WHEN n = 1 THEN 'End of next month'
            ELSE 'End of the month after'
        END AS payment_date,
        n
    FROM
        payments_schedule,
        UNNEST(SEQUENCE(0, date_diff('month', last_due_date, current_date))) AS t(n)
)
SELECT
    supplier_id,
    supplier_name,
    payment_amount,
    balance_outstanding,
    payment_date
FROM
    monthly_payments
ORDER BY
    supplier_id, n;
