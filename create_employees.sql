USE memory.default;

CREATE TABLE employee (
    employee_id TINYINT,
    first_name VARCHAR,
    last_name VARCHAR,
    job_title VARCHAR,
    manager_id TINYINT
);

INSERT INTO employee (employee_id, first_name, last_name, job_title, manager_id) VALUES
(1, 'Ian', 'James', 'CEO', 4),
(2, 'Umberto', 'Torrielli', 'CSO', 1),
(3, 'Alex', 'Jacobson', 'MD EMEA', 2),
(4, 'Darren', 'Poynton', 'CFO', 2),
(5, 'Tim', 'Beard', 'MD APAC', 2),
(6, 'Gemma', 'Dodd', 'COS', 1),
(7, 'Lisa', 'Platten', 'CHR', 6),
(8, 'Stefano', 'Camisaca', 'GM Activation', 2),
(9, 'Andrea', 'Ghibaudi', 'MD NAM', 2);

-- Second approach
--docker run --name=sexi-silverbullet -d \
--  -v hr/employee_index.csv:/data \
--  trinodb/trino
--
--docker exec -it sexi-silverbullet /bin/sh
--echo 'connector.name=hive-hadoop2
--hive.metastore=file
--hive.metastore.catalog.dir=/data' > /etc/catalog/csv.properties


--CREATE TABLE csv.default.employee (
--    employee_id TINYINT,
--    first_name VARCHAR,
--    last_name VARCHAR,
--    manager_id TINYINT,
--    job_title VARCHAR
--)
--WITH (
--    format = 'CSV',
--    external_location = 'file:///data/employee_index.csv'
--);
