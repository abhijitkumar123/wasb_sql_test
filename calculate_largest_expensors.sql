USE memory.default;

SELECT e.employee_id,
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
       m.manager_id,
       CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
       SUM(ex.unit_price * ex.quantity) AS total_expensed_amount
FROM employee e
JOIN expense ex ON e.employee_id = ex.employee_id
LEFT JOIN employee m ON e.manager_id = m.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name, m.manager_id, m.first_name, m.last_name
HAVING SUM(ex.unit_price * ex.quantity) > 1000
ORDER BY total_expensed_amount DESC;

