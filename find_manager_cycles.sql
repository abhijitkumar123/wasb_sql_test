-- Query to check for cycles of employees who approve each others expenses --
-- Results will be like
-- employee_id | cycle_path
-- -------------+------------
--            4 | 4,2,1
--            1 | 1,4,2
--            2 | 2,1,4

SELECT
    e1.employee_id AS employee_id,
    CONCAT(CAST(e1.employee_id AS VARCHAR), ',', CAST(e2.employee_id AS VARCHAR)) AS cycle_path
FROM
    EMPLOYEE e1
        JOIN
    EMPLOYEE e2 ON e1.manager_id = e2.employee_id
WHERE
    e1.employee_id = e2.manager_id

UNION

SELECT
    e1.employee_id AS employee_id,
    CONCAT(CAST(e1.employee_id AS VARCHAR), ',', CAST(e2.employee_id AS VARCHAR), ',', CAST(e3.employee_id AS VARCHAR)) AS cycle_path
FROM
    EMPLOYEE e1
        JOIN
    EMPLOYEE e2 ON e1.manager_id = e2.employee_id
        JOIN
    EMPLOYEE e3 ON e2.manager_id = e3.employee_id
WHERE
    e1.employee_id = e3.manager_id;