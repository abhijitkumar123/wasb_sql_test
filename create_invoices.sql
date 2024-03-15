/*-------------------------------
TASK:3 - CREATING SUPPLIER TABLE
-------------------------------*/
CREATE TABLE SUPPLIER(
    supplier_id TINYINT,
    name VARCHAR(255)
);


/*----------------------------------
INSERTING VALUES INTO SUPPLIER TABLE
----------------------------------*/
INSERT INTO SUPPLIER(supplier_id, name)
SELECT
    ROW_NUMBER() OVER (ORDER BY name) AS supplier_id,
    name
FROM (
    VALUES
    ('Party Animals'),
    ('Catering Plus'),
    ('Dave''s Discos'),
    ('Entertainment tonight'),
    ('Ice Ice Baby')
) AS companies(name);


/*--------------------------
CREATING INVOICES DUE TABLE
--------------------------*/
CREATE TABLE INVOICES_DUE(
name VARCHAR(255),
invoice_amount DECIMAL(8, 2),
due_date DATE
);


/*-----------------------------------
INSERTING VALUES TO INVOICE DUE TABLE
-----------------------------------*/
INSERT INTO INVOICES_DUE VALUES
    ('Party Animals', 6000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 3, CURRENT_DATE))),
    ('Catering Plus', 2000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 2, CURRENT_DATE))),
    ('Catering Plus', 1500, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 3, CURRENT_DATE))),
    ('Dave''s Discos', 500, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 1, CURRENT_DATE))),
    ('Entertainment tonight', 6000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 3, CURRENT_DATE))),
    ('Ice Ice Baby', 4000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 6, CURRENT_DATE)));


/*--------------------
CREATING INVOICE TABLE
---------------------*/
CREATE TABLE INVOICE(
supplier_id TINYINT,
invoice_amount DECIMAL(8, 2),
due_date DATE);


/*-------------------------------
INSERTING VALUES TO INVOICE TABLE
-------------------------------*/
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
SELECT
    s.supplier_id,
    d.invoice_amount,
    d.due_date
FROM
    memory.default.supplier s
JOIN
    memory.default.invoices_due d on d.name=s.name;