USE memory.default;

WITH monthly_payments AS (
    SELECT s.supplier_id, s.name AS supplier_name, i.invoice_amount,
           date_add('day', -1, date_add('month', 1, date_trunc('month', current_date))) AS payment_date,
           i.invoice_amount AS balance_outstanding
    FROM supplier s
    JOIN invoice i ON s.supplier_id = i.supplier_id
)
SELECT supplier_id, supplier_name, invoice_amount AS payment_amount,
       balance_outstanding, payment_date
FROM monthly_payments;

