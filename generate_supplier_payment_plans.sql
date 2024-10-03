
SELECT 
    s.supplier_id, 
    s.name AS supplier_name, 
    SUM(i.invoice_amount / DATEDIFF(MONTH, GETDATE(), i.due_date)) AS payment_amount,
    SUM(i.invoice_amount) AS balance_outstanding,
    EOMONTH(GETDATE()) AS payment_date
FROM 
    SUPPLIER s
JOIN 
    INVOICE i ON s.supplier_id = i.supplier_id
WHERE 
    i.due_date > GETDATE()  -- Only consider invoices that are due in the future
GROUP BY 
    s.supplier_id, s.name
ORDER BY 



----•	Tests: to validate the following:
--Correct Supplier
--Positive Payment Amount: 
--Negative Balance Outstanding: i.e. less than 0
--Correct Payment Date: ensure date is set to the end of the current month
--Payment per Month: Verifies that the payments are distributed across the months leading to the due date
