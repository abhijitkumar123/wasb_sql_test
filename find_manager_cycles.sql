
SELECT
            temp_cycle.manager_id,
            ARRAY_AGG(distinct temp_cycle.employee_id) AS employee_list
        FROM
           (select e.employee_id, emp.manager_id 
            from memory.default.expense e
            left join memory.default.employee emp
            on e.employee_id = emp.employee_id) temp_cycle
        GROUP BY
            manager_id
            ;

 /*
    My output
manager_id | employee_list 
------------+---------------
          2 | [9, 3, 4]
          1 | [2]

All the employees who do the expenses are approved by employee_id 2 & 
employee_id 2 does an expense & it is approved by 1. Hence I dont see any cycle.

If employee_id 2's expense is approved by any employee_ids - 3,4 or 9 then there is a cycle.
*/