USE memory.default;

-- may want to do this for clean insert
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS supplier; 
DROP TABLE IF EXISTS temp_sup;
DROP TABLE IF EXISTS temp_inv;
DROP TABLE IF EXISTS inv_preproc;

CREATE TABLE IF NOT EXISTS invoice (
supplier_id TINYINT,
invoice_amount DECIMAL(8, 2),
due_date DATE
);

CREATE TABLE supplier (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE IF NOT EXISTS temp_inv (
name VARCHAR,
invoice_amount DECIMAL(8, 2),
due_date TINYINT
);

-- similar to before, would need to parse, clean and create intermediary table data programmatically from file.
INSERT INTO temp_inv (name, invoice_amount, due_date) VALUES
('Party Animals',6000,3),
('Catering Plus',2000,2),
('Catering Plus',1500,3),
('Dave''s Discos',500,1),
('Entertainment tonight',6000,3),
('Ice Ice Baby',4000,6);


-- create distinct supplier list
CREATE TABLE temp_sup (unique_name) AS
SELECT DISTINCT name
FROM temp_inv;


-- create supplier lookup table with id by sort alphanumeric
INSERT INTO supplier (supplier_id, name)
SELECT
    CAST(ROW_NUMBER() OVER (ORDER BY unique_name) AS TINYINT) AS supplier_id,
    unique_name
FROM temp_sup;

DROP TABLE temp_sup;


-- stage the INT date for calculation
CREATE TABLE inv_preproc AS
SELECT 
    s.supplier_id,
    t.invoice_amount,
    t.due_date
FROM 
    temp_inv t
JOIN 
    supplier s
ON 
    t.name = s.name;

DROP TABLE temp_inv;


-- do the date calculation as the end of the month prior to the due date (now + N months), i.e. always within due date but end of previous month.
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
SELECT 
    supplier_id,
    invoice_amount,
	date_add('day', -1, date_trunc('month', date_add('month', due_date, current_date))) AS due_date
FROM 
    inv_preproc;
	
DROP TABLE inv_preproc;

SELECT * FROM invoice;











