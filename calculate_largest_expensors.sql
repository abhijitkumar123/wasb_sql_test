USE memory.default;

DROP TABLE IF EXISTS expensors; 
DROP TABLE IF EXISTS employee_totals;
DROP TABLE IF EXISTS emp_man;

-- get simple row totals
CREATE TABLE expensors AS
SELECT
	employee_id, 
	(unit_price * quantity) AS total
FROM expense;

-- group by employee
CREATE TABLE employee_totals AS
SELECT
    employee_id, 
    SUM(total) AS total_expensed_amount
FROM expensors
GROUP BY employee_id;

--concatenate names
CREATE TABLE emp_man AS
SELECT 
	employee_id,
	first_name,
	last_name,
	first_name || ' ' || last_name AS employee_name,
	manager_id,
    (SELECT first_name || ' ' || last_name FROM employee AS mn WHERE mn.employee_id = employee.manager_id) AS manager_name
FROM 
    employee;


-- Print Report
SELECT
	e.employee_id,
    e.employee_name,
	e.manager_id,
	e.manager_name,
	t.total_expensed_amount
FROM 
    emp_man e
JOIN 
    employee_totals t ON e.employee_id = t.employee_id
WHERE 
	total_expensed_amount > 1000;
	