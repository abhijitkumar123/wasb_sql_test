USE memory.default;

WITH employee_expenses AS (
    SELECT 
        e.employee_id,
        SUM(ex.unit_price * ex.quantity) AS total_expensed_amount
    FROM 
        EMPLOYEE e
    JOIN 
        EXPENSE ex ON e.employee_id = ex.employee_id
    GROUP BY 
        e.employee_id
    HAVING 
        SUM(ex.unit_price * ex.quantity) > 1000
)
-- Select FUN employee
SELECT 
    ee.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.manager_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    ee.total_expensed_amount
FROM 
    employee_expenses ee
JOIN 
    EMPLOYEE e ON ee.employee_id = e.employee_id
LEFT JOIN 
    EMPLOYEE m ON e.manager_id = m.employee_id
ORDER BY 
    ee.total_expensed_amount DESC;