/*-------------------------------------
TASK:5 - OFFENDER WITH LARGEST EXPENSE
--------------------------------------*/
 WITH employee_expenses AS (
    SELECT
        employee_id,
        SUM(unit_price * quantity) AS total_expensed_amount
    FROM
        memory.default.EXPENSE
    GROUP BY
        employee_id
),
employee_details AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name,' ',e.last_name) AS employee_name,
        e.manager_id,
        CONCAT(m.first_name, ' ', m.last_name) AS manager_name
    FROM
        EMPLOYEE e
    LEFT JOIN
        EMPLOYEE m ON e.manager_id = m.employee_id
)
SELECT
    employee_details.employee_id,
    employee_details.employee_name,
    employee_details.manager_id,
    employee_details.manager_name,
    employee_expenses.total_expensed_amount
FROM
    employee_details
LEFT JOIN
    employee_expenses ON employee_details.employee_id = employee_expenses.employee_id
WHERE
    employee_expenses.total_expensed_amount > 1000
ORDER BY
    employee_details.employee_id DESC;