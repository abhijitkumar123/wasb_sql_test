-- #############################################################################################
-- # Created By: Milind Keer
-- # Created on: 01/10/2024
-- # Description: Create a SQL query to report the employee_id, employee_name, manager_id, manager_name 
-- and total_expensed_amount for anybody who's expensed more than 1000 of goods or services in SExI. 
-- Order the offenders by the total_expensed_amount in descending order.
-- the expensed_amount of an EXPENSE is the EXPENSE.unit_price * EXPENSE.quantity.
-- the total_expensed_amount of an EMPLOYEE is the SUM of the expensed_amounts for all EXPENSEs with their employee_id.
-- the employee_name is the EMPLOYEE.first_name and EMPLOYEE.last_name separated by a space (" ") of the employee having the employee_id.
-- the manager_nameis the EMPLOYEE.first_name and EMPLOYEE.last_name separated by a space (" ") of the EMPLOYEE having EMPLOYEE.employee_id = manager_id.
-- #############################################################################################


-- Calculate the expensed amount for each expense
WITH expense_details AS (
    SELECT 
        employee_id,
        (unit_price * quantity) AS expensed_amount
    FROM 
        EXPENSE
),

-- Calculate total expensed amount per employee
total_expense AS (
    SELECT 
        employee_id,
        SUM(expensed_amount) AS total_expensed_amount
    FROM 
        expense_details
    GROUP BY 
        employee_id
)

-- Join with EMPLOYEE table to get employee and manager details
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.manager_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    te.total_expensed_amount
FROM 
    total_expense te
JOIN 
    EMPLOYEE e ON te.employee_id = e.employee_id
LEFT JOIN 
    EMPLOYEE m ON e.manager_id = m.employee_id
WHERE 
    te.total_expensed_amount > 1000
ORDER BY 
    te.total_expensed_amount DESC;
