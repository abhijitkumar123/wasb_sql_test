-- Test to verify unique employee IDs
-- return no rows bcoz all employees has got unique IDs
--     OUTPUT:
-- employee_id | count
-- -------------+-------
-- (0 rows)
SELECT
    employee_id,
    COUNT(*) AS count
FROM
    EMPLOYEE
GROUP BY
    employee_id
HAVING
    COUNT(*) > 1;

-- Test to check null values in employee fields
-- This also returns no rows bcoz no employee has got Null values
--      OUTPUT:
--       employee_id | first_name | last_name | job_title | manager_id
-- -------------+------------+-----------+-----------+------------
-- (0 rows)

SELECT
    *
FROM
    EMPLOYEE
WHERE
    first_name IS NULL OR last_name IS NULL OR manager_id IS NULL;

-- Ensure that the calculated payment amounts should not exceed the balance outstanding for any supplier
-- OUTPUT:
-- supplier_id | supplier_name | total_invoice_amount | payment_amount
-- -------------+---------------+----------------------+----------------
-- (0 rows)

SELECT
    s.supplier_id,
    s.name AS supplier_name,
    SUM(i.invoice_amount) AS total_invoice_amount,
    CEIL(SUM(i.invoice_amount) / 500) * 500 AS payment_amount
FROM
    SUPPLIER s
        JOIN
    INVOICE i ON s.supplier_id = i.supplier_id
GROUP BY
    s.supplier_id, s.name
HAVING
    CEIL(SUM(i.invoice_amount) / 500) * 500 > SUM(i.invoice_amount);

-- Verify that all invoices have valid due dates (they should be in the future)
-- OUTPUT:
--  supplier_id | invoice_amount | due_date
-- -------------+----------------+----------
-- (0 rows)
SELECT * FROM INVOICE WHERE due_date < CURRENT_DATE;
