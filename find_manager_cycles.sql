
select distinct(manager_id) as employee_id, array_agg(employee_id) as can_approve
from employee group by manager_id;
