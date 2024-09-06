WITH invoice_payments AS (
    SELECT 
        i.supplier_id,
        s.name AS supplier_name,
        i.invoice_amount AS total_invoice_amount,
        i.due_date,
        EXTRACT(YEAR FROM i.due_date) * 12 + EXTRACT(MONTH FROM i.due_date) - EXTRACT(YEAR FROM CURRENT_DATE) * 12 - EXTRACT(MONTH FROM CURRENT_DATE) + 1 AS months_until_due,
        i.invoice_amount AS balance_outstanding
    FROM 
        memory.default.invoices i
    JOIN 
        memory.default.suppliers s ON i.supplier_id = s.supplier_id
),
monthly_payments AS (
    SELECT
        supplier_id,
        supplier_name,
        total_invoice_amount,
        balance_outstanding,
        due_date,
        ROUND(total_invoice_amount / months_until_due, 2) AS monthly_payment_amount,
        DATE_ADD('day', -1, DATE_ADD('month', 1, DATE_TRUNC('month', DATE_ADD('month', seq - 1, CURRENT_DATE)))) AS payment_date
    FROM 
        invoice_payments
    CROSS JOIN UNNEST(SEQUENCE(1, months_until_due)) AS t(seq)
)
SELECT
    supplier_id,
    supplier_name,
    SUM(monthly_payment_amount) AS payment_amount,
    MAX(balance_outstanding) AS balance_outstanding,
    payment_date
FROM
    monthly_payments
GROUP BY 
    supplier_id, supplier_name, payment_date
ORDER BY 
    supplier_id, payment_date asc;
