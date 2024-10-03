--  Check for cycles of employees who approve each others expenses in SExI.
SELECT 
    e1.employee_id,
    CONCAT(e1.employee_id, ' <-> ', e2.employee_id) AS pattern
FROM 
    EMPLOYEE em1
JOIN 
    EMPLOYEE em2 ON em1.manager_id = em2.employee_id
WHERE 
    em2.manager_id = em1.employee_id
GROUP BY 
    em1.employee_id, em2.employee_id;

	-- Tests:
	--Verify the pattern output, if the employee_id matches in employee_id, ' <-> ', e2.employee_id, 
	--flag this as it means employees are approving their own expenses

	----Also find where there is a pattern, i.e. emp_id1 --> emp_id2 --> emp_id1
	--flag this too as it means employees are approving one another's expenses