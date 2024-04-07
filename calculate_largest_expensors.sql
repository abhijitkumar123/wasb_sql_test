   SELECT ta.employee_id,
          e.employee_name,
          e.manager_id,
          e.manager_name,
          ta.total_expensed_amount
     FROM (
             SELECT employee_id, sum(unit_price * quantity) AS total_expensed_amount
               FROM memory.default.expense
           GROUP BY employee_id
          ) AS ta
LEFT JOIN (
              SELECT e1.employee_id,
                     concat_ws(' ', e1.first_name, e1.last_name) AS employee_name,
                     e1.manager_id,
                     concat_ws(' ', e2.first_name, e2.last_name) AS manager_name
                FROM memory.default.employee AS e1
           LEFT JOIN memory.default.employee AS e2
                  ON e1.manager_id = e2.employee_id
          ) e
       ON ta.employee_id = e.employee_id
    WHERE ta.total_expensed_amount > 1000
 ORDER BY ta.total_expensed_amount DESC;
