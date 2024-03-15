/*---------------------------------------------------------------
TASK:4 - CYCLE OF EMPLOYEES WHO CAN APPROVE EACH OTHERS EXPENSES
---------------------------------------------------------------*/
select e.employee_id, e.manager_id
  from EMPLOYEE e LEFT JOIN EMPLOYEE m
  ON e.manager_id = m.employee_id;


/*-------------------------------
WITH EMPLOYEE AND MANAGER NAMES
-------------------------------*/
SELECT
    e.employee_id,
    CONCAT(e.first_name,' ',e.last_name) AS employee_name,
    e.manager_id,
    CONCAT(m.first_name, ' ', m.last_name) AS manager_name
  from EMPLOYEE e LEFT JOIN EMPLOYEE m
  ON e.manager_id = m.employee_id;