USE memory.default;

DROP TABLE IF EXISTS expense; -- may want to do this for clean insert.
DROP TABLE IF EXISTS temp; -- may want to do this for clean insert.

/*
CREATE TABLE IF NOT EXISTS expense (
employee_id TINYINT, 
unit_price DECIMAL(8, 2), 
quantity TINYINT
);
*/

-- can inherit dtypes from temp
CREATE TABLE IF NOT EXISTS temp (
fstname VARCHAR,
lstname VARCHAR, 
unit_price DECIMAL(8, 2), 
quantity TINYINT
);

--DESCRIBE expense;-- check datatypes

-- Need to do this programatically - not INSERT like this in SQL directly.
-- Just doing it to get the data in. 
-- Also cross reference employee_id as a SELECT FROM employee table WHERE NAME. So you'd need to stage extraction.
-- Also files are key: value so different parse routine in e.g. python... into intermediary processing table like this.

INSERT INTO temp VALUES
('Alex','Jacobson',6.50,14),
('Alex','Jacobson',11.00,20),
('Alex','Jacobson',22.00,18),
('Alex','Jacobson',13.00,75),
('Andrea','Ghibaudi',300,1),
('Darren','Poynton',40.00,9),
('Umberto','Torrielli',17.50,4);

CREATE TABLE expense AS
-- vs INSERT INTO expense (employee_id, unit_price, quantity) -- if created prior
SELECT 
    e.employee_id,
    t.unit_price,
    t.quantity
FROM 
    temp t
JOIN 
    employee e
ON 
    t.fstname = e.first_name AND t.lstname = e.last_name;

-- or use subquery (prob less efficient for large data)
/*
CREATE TABLE expense AS
SELECT 
    (SELECT e.employee_id
     FROM employee e
     WHERE e.first_name = t.fstname AND e.last_name = t.lstname) AS employee_id,
    t.unit_price,
    t.quantity
FROM 
    temp t;
*/


DESCRIBE expense;-- check datatypes
DROP table temp;

SELECT * FROM expense;