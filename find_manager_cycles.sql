WITH RECURSIVE approvals (employee_id, manager_id,chain) AS 
(
    -- select statment to get employee id , manager id , and the current manager id into the chain array
    SELECT 
        employee_id
        ,manager_id
        ,ARRAY[manager_id] AS chain
    FROM 
        EMPLOYEE
    
    UNION ALL 

    SELECT
        -- similar to before but appends new manager id to chain array
        e.employee_id
        ,e.manager_id
        ,a.chain || e.manager_id
    FROM 
        EMPLOYEE AS e
    INNER JOIN 
        approvals AS a
        ON e.manager_id = a.employee_id
WHERE 
    NOT CONTAINS(a.chain,e.employee_id)
)
SELECT 
    chain[1] AS employee_id
    ,chain
FROM 
    approvals
WHERE 
    chain[1] = chain[1];