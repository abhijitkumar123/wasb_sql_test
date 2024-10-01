 -- This SQL file was generated from 03_create_invoices_SQL.py on 2024-10-01 20:27:39 
 
 
CREATE TABLE IF NOT EXISTS INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

CREATE TABLE IF NOT EXISTS STAGING_SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE IF NOT EXISTS SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);



/* Insert data from: brilliant_bottles.txt */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES (1, 2000.00, DATE '2024-11-30');


/* Insert supplier: Catering Plus */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES (1, 'Catering Plus');


/* Insert data from: awesome_animals.txt */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES (5, 6000.00, DATE '2024-12-31');


/* Insert supplier: Party Animals */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES (5, 'Party Animals');


/* Insert data from: fantastic_ice_sculptures.txt */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES (4, 4000.00, DATE '2025-03-31');


/* Insert supplier: Ice Ice Baby */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES (4, 'Ice Ice Baby');


/* Insert data from: excellent_entertainment.txt */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES (3, 6000.00, DATE '2024-12-31');


/* Insert supplier: Entertainment tonight */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES (3, 'Entertainment tonight');


/* Insert data from: disco_dj.txt */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES (2, 500.00, DATE '2024-10-31');


/* Insert supplier: Dave''s Discos */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES (2, 'Dave''s Discos');


/* Insert data from: crazy_catering.txt */
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
VALUES (1, 1500.00, DATE '2024-12-31');


/* Insert supplier: Catering Plus */
INSERT INTO STAGING_SUPPLIER (supplier_id, name)
VALUES (1, 'Catering Plus');


-- Insert distinct suppliers into the final SUPPLIER table
INSERT INTO SUPPLIER (supplier_id, name)
SELECT DISTINCT supplier_id, name
FROM staging_supplier;

-- Drop staging_supplier table to clean up
DROP TABLE IF EXISTS staging_supplier;

