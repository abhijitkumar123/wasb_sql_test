--================================
-- DROP TABLES IF ALREADY CREATED
--================================
DROP TABLE IF EXISTS EXPENSE_1;
DROP TABLE IF EXISTS EXPENSE;
--================================
--To Create the temp table with values from txt files
----------------------------------
CREATE TABLE IF NOT EXISTS EXPENSE_1
(
    employee_name VARCHAR(20)
    ,unit_price DECIMAL(8, 2)
    ,quantity TINYINT
)
COMMENT 'staging table For expenses logged by employees';
-- SHOW results from EXPENSE 
------------------------------------
SELECT * FROM EXPENSE_1;

-- Insert initial Values from txt files to staging table 
--------------------------------------
INSERT INTO EXPENSE_1 (employee_name, unit_price, quantity)
VALUES 
('Alex Jacobson',6.50,14)
,('Alex Jacobson',11.00,20)
,('Alex Jacobson',22.00,18)
,('Alex Jacobson',13.00,75)
,('Andrea Ghibaudi',300,1)
,('Darren Poynton', 40.00,9)
,('Umberto Torrielli',17.50, 4);

-- create final table 
-------------------------------------
CREATE TABLE IF NOT EXISTS EXPENSE
(
    employee_id TINYINT
    ,unit_price DECIMAL(8, 2)
    ,quantity TINYINT
)
COMMENT 'Final Expense Table';

-- Insert into final table
------------------------------------
INSERT INTO EXPENSE
SELECT 
    emp.employee_id
    ,ex1.unit_price
    ,ex1.quantity
FROM 
    EXPENSE_1 AS ex1
LEFT JOIN   
    EMPLOYEE AS emp 
    ON ex1.employee_name = CONCAT(emp.first_name,' ',emp.last_name);

-- SHOW results from EXPENSE 
------------------------------------
SELECT * FROM EXPENSE;

-- DROP Staging table as no longer needed
------------------------------------
DROP TABLE IF EXISTS EXPENSE_1;


