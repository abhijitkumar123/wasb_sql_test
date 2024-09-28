--==============================
-- DROP TABLES IF EXISTS ALREADY
DROP TABLE IF EXISTS INVOICE;
DROP TABLE IF EXISTS INVOICE_1;
DROP TABLE IF EXISTS SUPPLIER;
--==============================
-- Create INVOICE TABLE
CREATE TABLE IF NOT EXISTS INVOICE
(
    supplier_id TINYINT
    ,invoice_amount DECIMAL(8,2)
    ,due_date DATE
);
--==============================
-- Create SUPPLIER TABLE
CREATE TABLE IF NOT EXISTS SUPPLIER
(
    supplier_id TINYINT
    ,name VARCHAR
);

--==============================
-- Values into Supplier
INSERT INTO SUPPLIER (supplier_id, name)
VALUES
(1,'Catering Plus')
,(2,'Daves Discos')
,(3,'Entertainment tonight')
,(4,'Ice Ice Baby')
,(5,'Party Animals');

--==============================
-- CREATE STAGING TABLE FOR INVOICE
CREATE TABLE IF NOT EXISTS INVOICE_1
(
    supplier_name VARCHAR
    ,invoice_amount DECIMAL(8,2)
    ,due_date DATE
);
--==============================
-- Values into Staging invoice_1 table
INSERT INTO INVOICE_1 (supplier_name, invoice_amount, due_date)
VALUES
('Party Animals',6000.00,CAST('2024-12-31' AS DATE))
,('Catering Plus',2000.00,CAST('2024-11-30' AS DATE))
,('Catering Plus',1500.00,CAST('2024-12-31' AS DATE))
,('Daves Discos',500.00,CAST('2024-10-31' AS DATE))
,('Entertainment tonight',6000.00,CAST('2024-12-31' AS DATE))
,('Ice Ice Baby',4000.00,CAST('2025-03-31' AS DATE));
--==============================
-- Add values into INVOICE table 
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
SELECT 
    sup.supplier_id
    ,in1.invoice_amount
    ,in1.due_date
FROM 
    INVOICE_1 AS in1
LEFT JOIN 
    SUPPLIER AS sup
    ON sup.name = in1.supplier_name;
--==============================
--CHECK DATA COMES THROUGH
SELECT * FROM INVOICE;
--==============================
--DROP STAGING INVOICE_1 TABLE
DROP TABLE IF EXISTS INVOICE_1;

--==============================
--SHOW TABLES 
SHOW TABLES;