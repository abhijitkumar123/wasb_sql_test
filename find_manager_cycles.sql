
with direct_reports AS (
SELECT
    e1.employee_id AS employee_id,
    e1.manager_id AS manager_id
FROM memory.default.employee e1
WHERE e1.employee_id != e1.manager_id
)
, mutual_approvals AS(
SELECT
    e1.employee_id AS employee_id,
    e1.manager_id AS manager_id,
    e2.employee_id AS second_employee_id
FROM direct_reports e1
JOIN direct_reports e2
ON e1.manager_id = e2.employee_id AND e2.manager_id = e1.employee_id
WHERE e1.employee_id < e2.employee_id
)
, three_level_cycles AS(
SELECT
    e1.employee_id AS employee_id,
    e1.manager_id AS manager_id,
    e2.manager_id AS second_manager_id,
    e3.employee_id AS third_employee_id
FROM direct_reports e1
JOIN direct_reports e2 ON e1.manager_id = e2.employee_id
JOIN direct_reports e3 ON e2.manager_id = e3.employee_id
WHERE e3.manager_id = e1.employee_id
AND e1.employee_id < e2.employee_id
AND e2.employee_id < e3.employee_id
)
SELECT 
    employee_id,
    CONCAT(CAST(employee_id AS VARCHAR), ',', CAST(manager_id AS VARCHAR)) AS cycle
FROM direct_reports
WHERE employee_id = manager_id
UNION ALL
SELECT 
    employee_id,
    CONCAT(CAST(employee_id AS VARCHAR), ',', CAST(manager_id AS VARCHAR), ',', CAST(second_employee_id AS VARCHAR)) AS cycle
FROM mutual_approvals
UNION ALL
SELECT 
    employee_id,
    CONCAT(CAST(employee_id AS VARCHAR), ',', CAST(manager_id AS VARCHAR), ',', CAST(second_manager_id AS VARCHAR), ',', CAST(third_employee_id AS VARCHAR)) AS cycle
FROM three_level_cycles;