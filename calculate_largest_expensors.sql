 -- Query to report the employee_id, employee_name, manager_id, manager_name and total_expensed_amount for anybody who's
 -- expensed more than 1000 of goods or services in SExI. Order the offenders by the total_expensed_amount in descending order
--  Output will be like
--  employee_id | employee_name | manager_id |   manager_name    | total_expensed_amount
-- -------------+---------------+------------+-------------------+-----------------------
--            3 | Alex Jacobson |          2 | Umberto Torrielli |               1682.00

 SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.manager_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
    SUM(exp.unit_price * exp.quantity) AS total_expensed_amount
FROM
    EMPLOYEE e
        JOIN
    EXPENSE exp ON e.employee_id = exp.employee_id
        LEFT JOIN
    EMPLOYEE m ON e.manager_id = m.employee_id
GROUP BY
    e.employee_id, e.first_name, e.last_name, e.manager_id, m.first_name, m.last_name
HAVING
    SUM(exp.unit_price * exp.quantity) > 1000
ORDER BY
    total_expensed_amount DESC;