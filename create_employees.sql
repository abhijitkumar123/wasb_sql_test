 -- This SQL file was generated from 01_create_employees_SQL.py on 2024-10-01 20:25:34 
 
 -- Create Employee Table: 
CREATE TABLE IF NOT EXISTS EMPLOYEE (
    employee_id TINYINT,
    first_name VARCHAR,
    last_name VARCHAR,
    job_title VARCHAR,
    manager_id TINYINT
);


-- Insert 1 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (1, 'Ian', 'James', 'CEO', 4);
-- Insert 2 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (2, 'Umberto', 'Torrielli', 'CSO', 1);
-- Insert 3 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (3, 'Alex', 'Jacobson', 'MD EMEA', 2);
-- Insert 4 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (4, 'Darren', 'Poynton', 'CFO', 2);
-- Insert 5 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (5, 'Tim', 'Beard', 'MD APAC', 2);
-- Insert 6 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (6, 'Gemma', 'Dodd', 'COS', 1);
-- Insert 7 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (7, 'Lisa', 'Platten', 'CHR', 6);
-- Insert 8 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (8, 'Stefano', 'Camisaca', 'GM Activation', 2);
-- Insert 9 record from CSV 
INSERT INTO EMPLOYEE (employee_id, first_name, last_name,job_title, manager_id) VALUES (9, 'Andrea', 'Ghibaudi', 'MD NAM', 2);
