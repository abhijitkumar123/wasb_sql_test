--Find largest expensors:
SELECT em.employee_id, 
CONCAT(em.first_name, ' ', em.last_name) AS employee_name, 
mg.employee_Id,
CONCAT(mg.first_name, ' ', mg.last_name) AS Manager_name,        
SUM(ex.unit_price * ex.quantity) AS total_expensed_amount,
CASE WHEN SUM(ex.unit_price * ex.quantity) > 1000.00 THEN ‘Test Passes’ ELSE  ‘Test Fails’ END AS Result,
FROM Employee em
INNER JOIN Employee mg
ON em.manager_Id = mg.employee_Id -- to find Manager 
INNER JOIN Expense ex
ON em.employee_id = ex.employee_Id
GROUP BY em.employee_id, employee_name, mg.Employee_Id, Manager_name
HAVING SUM(ex.unit_price * ex.quantity) > 1000.00
ORDER BY total_expensed_amount DESC
Tests would be the same as the Employee table (as above)

Tests: 
--Validate the data returns all employees with expenses that are greater than 1000
CASE WHEN SUM(ex.unit_price * ex.quantity) > 1000.00 
	THEN ‘Test Passes’
	ELSE  ‘Test Fails’ 
	END AS Result,
SELECT 
    s.supplier_id,
    s.name AS supplier_name,
    SUM(i.invoice_amount) AS payment_amount, -- Total payment amount
    SUM(i.invoice_amount) - SUM(CASE WHEN i.due_date < NOW() THEN i.invoice_amount ELSE 0 END) AS balance_outstanding,
    LAST_DAY(NOW() + INTERVAL 1 MONTH) AS payment_date -- Payment date set to the end of next month
FROM 
    SUPPLIER s
JOIN 
    INVOICE i ON s.supplier_id = i.supplier_id
GROUP BY 
    s.supplier_id, s.name
HAVING 
    balance_outstanding > 0 -- Ensure we only show suppliers with outstanding balances
ORDER BY 
    s.supplier_id; -- Optional: Order by supplier_id

-----------------------------------------------------------------------------------------
--TESTS:
-- Data Validation Tests 
SELECT 
CASE 
	WHEN SUM(i.invoice_amount) IS NULL 
	THEN 'Payment amount test fails' 
	ELSE 'Payment amount test passes' 
END AS payment_amount_status, 

CASE
WHEN (SUM(i.invoice_amount) - SUM(CASE WHEN i.due_date < NOW() THEN i.invoice_amount ELSE 0 END)) IS NULL 
	THEN 'Balance outstanding test fails' 
WHEN (SUM(i.invoice_amount) - SUM(CASE WHEN i.due_date < NOW() 
	THEN i.invoice_amount ELSE 0 END)) < 0 
	THEN 'Balance outstanding cannot be negative' ELSE 'Balance outstanding test passes' 
END AS balance_outstanding_status,

CASE 
WHEN LAST_DAY(NOW() + INTERVAL 1 MONTH) IS NULL
	THEN 'Payment date test fails' 
	ELSE 'Payment date test passes' 
END AS payment_date_status
