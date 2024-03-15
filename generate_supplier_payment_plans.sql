/*------------------------------
TASK:6 - SUPPLIER PAYMENT PLANS
-------------------------------*/
WITH payment_info AS (
    SELECT
        supplier_id,
        invoice_amount,
        due_date AS payment_date,
        (invoice_amount / ((DATE_DIFF('day', CURRENT_DATE, DUE_DATE) / 30.0) + 1)) AS payment_amount,
        SUM(invoice_amount) OVER (PARTITION BY supplier_id, due_date) AS total_invoice_amount
    FROM
        invoice
)
SELECT
    s.supplier_id,
    s.name as supplier_name,
    COALESCE(SUM(p.payment_amount), 0) AS payment_amount,
    COALESCE(SUM(p.total_invoice_amount), 0) - COALESCE(SUM(p.payment_amount), 0) AS balance_outstanding,
    p.payment_date
FROM
    payment_info p
JOIN
    supplier s ON p.supplier_id = s.supplier_id
GROUP BY
    s.supplier_id,
    s.name,
    p.payment_date;
