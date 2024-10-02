-- #############################################################################################
-- # Created By: Milind Keer
-- # Created on: 01/10/2024
-- # Description: Create a SQL query to check for cycles of employees who approve each others expenses in SExI. 
-- # results should contain a 2 columns, one of the employee_id in the loop, and then a column representing 
-- # the loop itself (array or comma separated employee_ids, for example. You choose.)
-- #############################################################################################

-- Set session property 

SET SESSION distinct_aggregations_strategy = 'single_step';
SET SESSION query_max_stage_count = 100;

-- Create the staging table for employee hierarchy if it doesn't exist
DROP TABLE IF EXISTS employee_hierarchy;  -- Ensure to clear previous attempts
CREATE TABLE employee_hierarchy (
    employee_id TINYINT,
    manager_id TINYINT,
    path VARCHAR
);

-- Insert initial data into the staging table
INSERT INTO employee_hierarchy (employee_id, manager_id, path)
SELECT 
    employee_id,
    manager_id,
    CAST(employee_id AS VARCHAR) AS path
FROM 
    employee;

-- Create a recursive CTE to build the employee hierarchy paths
WITH RECURSIVE hierarchy(employee_id, manager_id, path) AS (
    -- start with each employee
    SELECT
        employee_id,
        manager_id,
        CAST(employee_id AS VARCHAR) AS path
    FROM
        employee

    -- UNION ALL
    UNION  

    -- Recursive case: join employees to their managers
    SELECT
        e.employee_id,
        e.manager_id,
        CONCAT(h.path, '->', CAST(e.employee_id AS VARCHAR)) AS path
    FROM
        hierarchy h
    JOIN
        employee e ON h.employee_id = e.manager_id
    WHERE
        h.path NOT LIKE CONCAT('%->', CAST(e.employee_id AS VARCHAR), '->%')  -- Avoid cycles
)

-- Select count(*) from hierarchy

-- Step 5: Check for cycles in the employee hierarchy
SELECT 
    employee_id,
    path
FROM 
    hierarchy
WHERE 
    path LIKE CONCAT('%->', CAST(employee_id AS VARCHAR), '->%');


-- Note - I am getting below warning
-- WARNING: Number of stages in the query (80) exceeds the soft limit (50). 
-- If the query contains multiple aggregates with DISTINCT over different columns, 
-- please set the 'distinct_aggregations_strategy' session property to 'single_step'. 
-- If the query contains WITH clauses that are referenced more than once, 
-- please create temporary table(s) for the queries in those clauses.

-- I am assuming this is probably limitation of trino!
