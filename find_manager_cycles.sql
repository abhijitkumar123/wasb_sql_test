USE memory.default;

WITH RECURSIVE approval_cycles (employee_id, path) AS (
    SELECT employee_id, CAST(employee_id AS VARCHAR) AS path
    FROM employee
    WHERE manager_id IS NOT NULL
    UNION ALL
    SELECT e.employee_id, ac.path || ',' || CAST(e.employee_id AS VARCHAR)
    FROM approval_cycles ac
    JOIN employee e ON e.manager_id = ac.employee_id
    WHERE ac.path NOT LIKE '%,' || CAST(e.employee_id AS VARCHAR) || ',%'
)
SELECT employee_id, path FROM approval_cycles;
