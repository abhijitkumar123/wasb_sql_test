-- Create Employee table
CREATE TABLE EMPLOYEE (
  employee_id TINYINT PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  job_title TEXT,
  manager_id TINYINT
);
---------------------------------------------------------------------------------------------------------------------
-- Insert employee records
INSERT INTO EMPLOYEE (employee_id, first_name, last_name, job_title, manager_id) VALUES
(1, 'Ian', 'James', 'CEO', 4),
(2, 'Umberto', 'Torrielli', 'CSO', 1),
(3, 'Alex', 'Jacobson', 'MD EMEA', 2),
(4, 'Darren', 'Poynton', 'CFO', 2),
(5, 'Tim', 'Beard', 'MD APAC', 2),
(6, 'Gemma', 'Dodd', 'COS', 1),
(7, 'Lisa', 'Platten', 'CHR', 6),
(8, 'Stefano', 'Camisaca', 'GM Activation', 2),
(9, 'Andrea', 'Ghibaudi', 'MD NAM', 2);
---------------------------------------------------------------------
--Tests:
Table structure tests: Verify Employee table is created with 5 specified columns and expected data types:
SELECT 
    CASE 
        WHEN COUNT(*) = 5 
             AND STRING_AGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY COLUMN_NAME) = 'employee_id,first_name,last_name,job_title,manager_id'
             AND STRING_AGG(DATA_TYPE, ', ') WITHIN GROUP (ORDER BY COLUMN_NAME) = 'tinyint, text, text, text, int'
        THEN 'Test Passes: Table EMPLOYEE is created correctly'
        ELSE 'Test Fails: Table EMPLOYEE is missing columns or has incorrect data types'
    END AS validation_result
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'EMPLOYEE';

--Data Tests:
--Verify the Employee table consists of 9 rows of data
SELECT COUNT (1)
FROM Employees
Validate data displayed is as expected, i.e. there is no truncation, no NULL values and that data is complete and matches the data inserted. Validate there are no NULL values: e.g.
SELECT 
    E.[First_Name], 
    E.[Last_Name], 
    E.[Job_Title], 
    E.[Manager_Id],
    CASE 
        WHEN (SELECT COUNT(1) FROM Employees WHERE [Employee_Id] IS NULL) = 0 
        THEN 'Test Passes: No NULL Employee_Id found'
        ELSE 'Test Fails: NULL Employee_Id found'
    END AS Test_Result
FROM Employees E
WHERE [Employee_Id] IS NULL;

--Also, to validate the data of each employee, we could use the following CASE WHEN, THEN clauses but this can be cumbersome; especially for larger data sets
--SELECT employee_id, CASE WHEN employee_id = 1 AND first_name = 'Ian' AND last_name = 'James' AND job_title = 'CEO' AND manager_id = 4 THEN 'Test passes' ELSE 'Test fails' END AS result
