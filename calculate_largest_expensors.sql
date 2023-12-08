WITH EmployeeExpenses AS (
  SELECT
    E.employee_id,
    CONCAT(E.first_name,' ',E.last_name) AS employee_name,
    E.manager_id,
    CONCAT(M.first_name, ' ', M.last_name) AS manager_name,
    SUM(EXP.unit_price * EXP.quantity) AS total_expensed_amount
  FROM  
    EMPLOYEE E
  INNER JOIN 
    EXPENSE EXP ON EXP.employee_id = E.employee_id
  LEFT JOIN
    EMPLOYEE M ON M.employee_id = E.manager_id
  GROUP BY
    E.employee_id, E.first_name, E.last_name, E.manager_id, M.first_name, M.last_name
)
SELECT
  employee_id,
  employee_name,
  manager_id,
  manager_name,
  total_expensed_amount
FROM
  EmployeeExpenses
WHERE
  total_expensed_amount > 1000  
ORDER BY
  total_expensed_amount DESC;
