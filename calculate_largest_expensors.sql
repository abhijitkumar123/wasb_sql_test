-- Create 2 CTEs, one to get the names of the resources and manager, and the other to get the summed prices of the total_expenses grouped by id
WITH all_resources AS (
SELECT E1.employee_id,
	CONCAT(E1.first_name, ' ', E1.last_name) AS employee_name,
	E1.manager_id,
	CONCAT(E2.first_name, ' ', E2.last_name) AS manager_name
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2
ON E1.manager_id = E2.employee_id
) 
, total_expenses AS
(
SELECT Ex.employee_id,

	SUM(unit_price * quantity) AS total_expensed_amount		
FROM EXPENSE Ex
LEFT JOIN Employee Em
ON Ex.employee_id = Em.employee_id
GROUP BY Ex.employee_id
)

-- Join these tables together to get the information by using a "WHERE" clause to seek expenses over £1000
SELECT T.employee_id, 
	employee_name, 
	manager_id, 
	manager_name,
	total_expensed_amount
FROM total_expenses T
LEFT JOIN all_resources R
ON T.employee_id = R.employee_id
WHERE total_expensed_amount > 1000

