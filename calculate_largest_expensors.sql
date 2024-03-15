with employee_expense
as (select e.employee_id emp,
           concat(e.first_name, ' ', e.last_name) as employee_name,
           e.manager_id manager_id,
           (
               select concat(a.first_name, ' ', a.last_name) as employee_name
               from employee a
               where a.employee_id = e.manager_id
           ) as manager_name,
           (ex.unit_price * ex.quantity) as expensed_amount
    from employee e
        join expense ex
            on e.employee_id = ex.employee_id
   )
select emp employee_id,
       employee_name,
       manager_id,
       manager_name,
       sum(expensed_amount) as total_expensed_amount
from employee_expense
group by emp,
         employee_name,
         manager_id,
         manager_name
having sum(expensed_amount) > 1000
order by total_expensed_amount desc;
