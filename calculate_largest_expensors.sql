
WITH total_expenses AS (
    SELECT 
        e.employee_id,
        e.manager_id,
        SUM(exp.unit_price * exp.quantity) AS total_expensed_amount
    FROM 
        memory.default.expense exp
    LEFT JOIN 
        memory.default.employee e
    ON 
        exp.employee_id = e.employee_id
    GROUP BY 
        e.employee_id, e.manager_id
)
SELECT 
    emp.employee_id,
    CONCAT(emp.first_name, ' ', emp.last_name) AS employee_name,
    emp.manager_id,
    CONCAT(mgr.first_name, ' ', mgr.last_name) AS manager_name,
    te.total_expensed_amount
FROM 
    total_expenses te
JOIN 
    memory.default.employee emp 
ON 
    te.employee_id = emp.employee_id
JOIN 
    memory.default.employee mgr 
ON 
    te.manager_id = mgr.employee_id
WHERE 
    te.total_expensed_amount > 1000
ORDER BY 
    te.total_expensed_amount DESC;

/*  Output
 employee_id | employee_name | manager_id |   manager_name    | total_expensed_amount 
-------------+---------------+------------+-------------------+-----------------------
           3 | Alex Jacobson |          2 | Umberto Torrielli |               1682.00 

There is only 1 employee who has spend more than 1000.

*/