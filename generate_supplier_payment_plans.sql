-- Here we're using a recursive CTE to keep going through the data until each payment's due_date

WITH Supplier_Payment_Plan AS (
	
	-- Getting our original table of this month as a baseline, paying at the end
	-- Assumption that this was christmas 2023, all payment dates have been created based on this.
	

	SELECT 
        S.supplier_id,
        S.name AS supplier_name,
		due_date,
		CAST(I.invoice_amount / DATEDIFF(MONTH, '12/31/23', due_date) AS DECIMAL(8,2)) AS payment_amount,
        CAST(I.invoice_amount AS DECIMAL(8,2)) AS balance_outstanding,
        EOMONTH('12/01/23') AS payment_date,
		0 AS month_step
    FROM SUPPLIER S
    JOIN INVOICES I
	ON S.supplier_id = I.supplier_id
    WHERE I.invoice_amount > 0

	UNION ALL

	-- Now using the recursion section, subtract the monthly payments until our due_date has arrived
	

	SELECT 
        supplier_id,
        supplier_name,
		due_date,
		payment_amount,
        CAST((balance_outstanding - payment_amount) AS DECIMAL(8,2)) AS balance_outstanding,
        EOMONTH(DATEADD(MONTH, 1, payment_date)) AS payment_date,
		month_step + 1 AS month_step
    FROM Supplier_Payment_Plan SP
    WHERE 
		due_date >= payment_date -- Use next payment date
)


-- Selecting the final result, group by clause at this level to ensure that we're accounting for costs that are being paid prior to the final invoice due_date
SELECT 
    supplier_id,
    supplier_name,
    SUM(payment_amount) AS payment_amount,
    SUM(balance_outstanding) AS balance_outstanding,
    payment_date
FROM 
    Supplier_Payment_Plan
WHERE due_date >= payment_date
GROUP BY payment_date, supplier_name, supplier_id
ORDER BY payment_date
