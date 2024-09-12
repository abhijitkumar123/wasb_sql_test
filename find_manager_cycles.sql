USE memory.default;

WITH RECURSIVE employee_hierarchy (employee_id, first_name, manager_id, level, path, is_cycle) AS (
    -- Base case: Start with all employees
    SELECT 
        employee_id, 
        first_name, 
        manager_id, 
        0 AS level,
        ARRAY[employee_id] AS path,
        false AS is_cycle
    FROM employee

    UNION ALL
    
    -- Recursive case:
    SELECT 
        e.employee_id, 
        e.first_name, 
        e.manager_id, 
        eh.level + 1, 
        eh.path || e.employee_id,
        cardinality(filter(eh.path, x -> x = e.employee_id)) > 0 AS is_cycle
    FROM employee e
    JOIN employee_hierarchy eh ON eh.employee_id = e.manager_id
    WHERE NOT eh.is_cycle   -- Stop after including the employee that completes the cycle
)

SELECT employee_id, array_join(cast(path as array<varchar>), ', ') AS path
FROM employee_hierarchy
where is_cycle
ORDER BY level, employee_id;
