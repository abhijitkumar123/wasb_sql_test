-- Table Structure: employee_id | first_name | last_name,job_title | manager_id

-- Create Our Table, employee_id & manager_id TINYINT, for the others just putting in a varchar assumption 
CREATE TABLE EMPLOYEE (
    employee_id TINYINT,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    job_title VARCHAR(100),
    manager_id TINYINT,
)


-- Bulk insert our data, skipping the column headings row 1. Tablock for  performance, will lock the table during the bulk load op
BULK INSERT EMPLOYEE
FROM 'C:\Users\fredd\wasb_sql_test\hr\employee_index.csv'
WITH
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',   
    TABLOCK
)

SELECT * FROM EMPLOYEE
