--create_employees.sql
--Use the schema
use memory.default;

--Create Employee Table
create table EMPLOYEE(
employee_id TINYINT
,first_name VARCHAR
,last_name VARCHAR
,job_title VARCHAR
,manager_id TINYINT
);

--Insert Data into Employee Table
Insert into EMPLOYEE
Values (1, 'Ian', 'James','CEO',4);
Insert into EMPLOYEE
Values (2, 'Umberto', 'Torrielli','CSO',1);
Insert into EMPLOYEE
Values (3, 'Alex', 'Jacobson','MD EMEA',2);
Insert into EMPLOYEE
Values (4, 'Darren', 'Poynton','CFO',2);
Insert into EMPLOYEE
Values (5, 'Tim', 'Beard','MD APAC',2);
Insert into EMPLOYEE
Values (6, 'Gemma', 'Dodd','COS',1);
Insert into EMPLOYEE
Values (7, 'Lisa', 'Platten','CHR',6);
Insert into EMPLOYEE
Values (8, 'Stefano', 'Camisaca','GM Activation',2);
Insert into EMPLOYEE
Values (9, 'Andrea', 'Ghibaudi','MD NAM',2);

