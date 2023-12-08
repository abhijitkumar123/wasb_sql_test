WITH emp_hierarchy AS (
  SELECT 
    e.employee_id,
    e.manager_id,
    1 AS level
  FROM EMPLOYEE e
  WHERE manager_id IS NOT NULL  
),

updated_hierarchy AS (
  SELECT DISTINCT
    eh1.employee_id,
    eh2.manager_id AS manager_id,
    eh1.level + 1 AS level
  FROM emp_hierarchy eh1
    JOIN emp_hierarchy eh2 ON eh1.manager_id = eh2.employee_id
),

hierarchy AS (
  SELECT * FROM emp_hierarchy  
  UNION ALL
  SELECT * FROM updated_hierarchy
)

SELECT
  h1.employee_id,
  CONCAT(
    CAST(h1.manager_id AS VARCHAR), ',',
    CAST(h2.manager_id AS VARCHAR), ',',
    CAST(h3.manager_id AS VARCHAR)  
  ) AS cycles
FROM hierarchy h1
INNER JOIN hierarchy h2
  ON h1.employee_id = h2.manager_id AND
     h2.employee_id = h1.manager_id  
INNER JOIN hierarchy h3
  ON h1.employee_id = h3.employee_id
WHERE
  h1.level = 1 AND
  h2.level = 2 AND
  h3.level = 2
ORDER BY cycles;
