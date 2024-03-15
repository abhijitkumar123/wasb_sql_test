Select e3.employee_id,employee_path
from employee e3
join 
(SELECT 
e1.employee_id as employee,
e2.manager_id AS manager,
concat(cast(e2.manager_id as varchar),'->' ,cast(e2.employee_id as varchar),'->' ,cast(e1.employee_id as varchar)) AS employee_path
FROM 
    employee e1
JOIN 
    employee e2 ON e1.manager_id = e2.employee_id
order by e1.manager_id)Loop
on e3.manager_id= employee
where manager=e3.employee_id
order by 1;
