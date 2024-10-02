USE memory.default;

DROP TABLE IF EXISTS employee; -- may want to do this for clean insert.

CREATE TABLE IF NOT EXISTS employee ( 
employee_id TINYINT, 
first_name VARCHAR, 
last_name VARCHAR, 
job_title VARCHAR, 
manager_id TINYINT
); 

DESCRIBE employee;-- check datatypes

-- This is just to get the data in for testing as pure SQL. Use the CREATE TABLE WITH (file location) option or AS SUBQUERY.
-- Could also mount the files to container or git clone the repo to the container.
-- Normally parse files with python programmatically (to clean/validate, etc) and load via trino library and e.g. pandas.

INSERT INTO employee VALUES
(1,'Ian','James','CEO',4),
(2,'Umberto','Torrielli','CSO',1),
(3,'Alex','Jacobson','MD EMEA',2),
(4,'Darren','Poynton','CFO',2),
(5,'Tim','Beard','MD APAC',2),
(6,'Gemma','Dodd','COS',1),
(7,'Lisa','Platten','CHR',6),
(8,'Stefano','Camisaca','GM Activation',2),
(9,'Andrea','Ghibaudi','MD NAM',2);

SELECT * FROM employee;



