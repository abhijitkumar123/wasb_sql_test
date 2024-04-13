-- Create recursive CTE which will find the manager loops
WITH ManagerHierarchy AS (
    -- Anchor; create the first employye - manager pairs and our depth to ensure we have a limit to our recursions
    SELECT
        employee_id,
        manager_id,
		CONCAT(CAST(employee_id AS varchar(100)), '; ', CAST(manager_id AS varchar(100))) AS loop,
        1 AS depth
    FROM
        EMPLOYEE

    UNION ALL

    -- Recursive member: Join with previous results to find the next level of hierarchy and concatenate this into our path column
    SELECT
		mh.employee_id,
        mh.manager_id,
        CASE
			WHEN mh.loop like '%' + CAST(e.manager_id AS varchar(100)) + '%' 
				THEN mh.loop
			ELSE 
				CAST(CONCAT(mh.loop, '; ', CAST(e.manager_id AS varchar(100))) AS varchar(100))
		END AS loop,
        mh.depth + 1 AS depth
    FROM
        ManagerHierarchy mh 
    JOIN
        EMPLOYEE e
    ON
        RIGHT(mh.loop, 1) = e.employee_id
    WHERE
		mh.depth < 20
)

-- Find the maximum length loops of the iterations, group by employee_id so we only get the maximum loop, and order by employee_id to aid visualisation
SELECT
    employee_id,
    MAX(loop) AS loop
FROM
    ManagerHierarchy
GROUP BY employee_id
ORDER BY employee_id;
