
WITH employee_expenses AS (
    SELECT
        e.employee_id,
        e.first_name AS employee_first_name,
        e.last_name AS employee_last_name,
        e.manager_id,
        e2.first_name AS manager_first_name,
        e2.last_name AS manager_last_name,
        SUM(exp.unit_price * exp.quantity) AS total_expensed_amount
    FROM memory.default.employee e
    LEFT JOIN memory.default.expenses exp ON e.employee_id = exp.employee_id
    LEFT JOIN memory.default.employee e2 ON e.manager_id = e2.employee_id
    GROUP BY
        e.employee_id,
        e.first_name,
        e.last_name,
        e.manager_id,
        e2.first_name,
        e2.last_name
)
SELECT
    employee_id,
    CONCAT(employee_first_name, ' ', employee_last_name) AS employee_name,
    manager_id,
    CONCAT(manager_first_name, ' ', manager_last_name) AS manager_name,
    total_expensed_amount
FROM employee_expenses
WHERE total_expensed_amount > 1000
ORDER BY total_expensed_amount DESC;
