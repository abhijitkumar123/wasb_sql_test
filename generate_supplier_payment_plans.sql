-- Query to report the supplier_id, supplier_name, payment_amount, balance_outstanding, payment_date for each of our suppliers/invoices in SExI
-- Output will be like
--
--  supplier_id |     supplier_name     | payment_amount | balance_outstanding | payment_date
-- -------------+-----------------------+----------------+---------------------+--------------
--            1 | Catering Plus         |           4000 |             3500.00 | 2024-11-01
--            2 | Dave's Discos         |           1000 |              500.00 | 2024-11-01
--            3 | Entertainment Tonight |           6000 |             6000.00 | 2024-11-01
--            4 | Ice Ice Baby          |           4000 |             4000.00 | 2024-11-01
--            5 | Party Animals         |           6000 |             6000.00 | 2024-11-01

WITH SupplierPayments AS (
    SELECT
        s.supplier_id,
        s.name AS supplier_name,
        SUM(i.invoice_amount) AS total_invoice_amount,
        SUM(CASE
                WHEN i.due_date > DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1' month THEN i.invoice_amount
                ELSE 0
            END) AS balance_outstanding,
        DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1' month AS payment_date
    FROM
        SUPPLIER s
            JOIN
        INVOICE i ON s.supplier_id = i.supplier_id
    GROUP BY
        s.supplier_id, s.name
),

     MonthlyPayments AS (
         SELECT
             supplier_id,
             supplier_name,
             balance_outstanding,
             CEIL(balance_outstanding / 1000) * 1000 AS payment_amount, -- Assuming uniform payments as 1000 per month
             payment_date
         FROM
             SupplierPayments
     )

SELECT
    supplier_id,
    supplier_name,
    payment_amount,
    balance_outstanding,
    payment_date
FROM
    MonthlyPayments
WHERE
    balance_outstanding > 0
ORDER BY
    supplier_id, payment_date;