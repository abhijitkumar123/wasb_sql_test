USE memory.default;

WITH invoice_payments AS (
    SELECT 
        i.supplier_id,
        i.invoice_amount,
        i.due_date,
        CEIL(DATE_DIFF('month', CURRENT_DATE, i.due_date)) AS months_to_pay,
        i.invoice_amount / NULLIF(CEIL(DATE_DIFF('month', CURRENT_DATE, i.due_date)), 0) AS monthly_payment
    FROM INVOICE i
),
max_months AS (
    SELECT MAX(months_to_pay) AS max_months FROM invoice_payments
),
months_sequence AS (
    SELECT CAST(numbers.number AS INTEGER) AS month
    FROM UNNEST(SEQUENCE(1, (SELECT max_months FROM max_months))) AS numbers(number)
),
payment_schedule AS (
    SELECT 
        ip.supplier_id,
        LAST_DAY_OF_MONTH(DATE_ADD('MONTH', ms.month - 1, CURRENT_DATE)) AS payment_date,
        SUM(CASE WHEN ms.month <= ip.months_to_pay THEN ip.monthly_payment ELSE 0 END) AS payment_amount
    FROM invoice_payments ip
    CROSS JOIN months_sequence ms
    GROUP BY ip.supplier_id, ms.month
    HAVING SUM(CASE WHEN ms.month <= ip.months_to_pay THEN ip.monthly_payment ELSE 0 END) > 0
),
cumulative_payments AS (
    SELECT 
        supplier_id,
        payment_date,
        payment_amount,
        SUM(payment_amount) OVER (PARTITION BY supplier_id ORDER BY payment_date) AS total_paid
    FROM payment_schedule
),
supplier_totals AS (
    SELECT supplier_id, SUM(invoice_amount) AS total_amount
    FROM INVOICE
    GROUP BY supplier_id
)
SELECT 
    cp.supplier_id,
    s.name AS supplier_name,
    ROUND(cp.payment_amount, 2) AS payment_amount,
    ROUND(st.total_amount - cp.total_paid, 2) AS balance_outstanding,
    cp.payment_date
FROM cumulative_payments cp
JOIN SUPPLIER s ON cp.supplier_id = s.supplier_id
JOIN supplier_totals st ON cp.supplier_id = st.supplier_id
ORDER BY cp.supplier_id, cp.payment_date;