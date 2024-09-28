WITH expenses AS (
    SELECT
        exp.employee_id,
        exp.unit_price * exp.quantity AS expensed_amount
    FROM
        EXPENSE AS exp
)
-- SELECT * FROM expenses;
,total_expenses AS 
(
    SELECT
        ex.employee_id
        ,SUM(ex.expensed_amount)    AS total_expensed_amount
    FROM 
        expenses                    AS ex
    GROUP BY 
        ex.employee_id
)
-- SELECT * FROM total_expenses;
,personnel AS 
(
    SELECT
        emp.employee_id
        ,CONCAT(emp.first_name, ' ', emp.last_name)   AS employee_name
        ,man.employee_id                                AS manager_id
        ,CONCAT(man.first_name, ' ', man.last_name)     AS manager_name
    FROM
        EMPLOYEE                                        AS emp
    LEFT JOIN
        EMPLOYEE                                        AS man 
        ON emp.manager_id = man.employee_id
)
--SELECT * FROM personnel;
SELECT
    per.employee_id
    ,per.employee_name
    ,per.manager_id
    ,per.manager_name
    ,exp.total_expensed_amount
FROM 
    personnel       AS per
INNER JOIN 
    total_expenses  AS exp
    ON per.employee_id = exp.employee_id
WHERE 
    exp.total_expensed_amount > 1000
ORDER BY exp.total_expensed_amount DESC;