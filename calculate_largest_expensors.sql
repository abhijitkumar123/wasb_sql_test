
WITH cte
     AS (SELECT employee_id,
                manager_id,
                CONCAT_WS(' ', first_name, last_name) AS employee_name,
                SUM(unit_price * quantity)            AS total_expensed_amount
         FROM   employee
                join expense USING (employee_id)
         GROUP  BY employee_id,
                    manager_id,
                   CONCAT_WS(' ', first_name, last_name))
SELECT c.employee_id,
       c.employee_name,
       c.manager_id,
       (SELECT CONCAT_WS(' ', e.first_name, e.last_name)
        FROM employee e
        WHERE e.employee_id = c.manager_id) AS manager_name,
       c.total_expensed_amount
FROM   cte c
WHERE  c.total_expensed_amount > 1000;