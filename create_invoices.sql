CREATE TABLE IF NOT EXISTS memory.default.supplier (
    supplier_id TINYINT,
    name VARCHAR
);


INSERT INTO memory.default.supplier(supplier_id, name)
     SELECT ROW_NUMBER() OVER (ORDER BY name) AS supplier_id,
            name
       FROM (
             VALUES ('Party Animals'),
                    ('Catering Plus'),
                    ('Dave''s Discos'),
                    ('Entertainment tonight'),
                    ('Ice Ice Baby')
            ) AS companies(name);


CREATE TABLE IF NOT EXISTS memory.default.invoices_due (
    name VARCHAR(255),
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);


INSERT INTO memory.default.invoices_due
     VALUES ('Party Animals', 6000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 3, CURRENT_DATE))),
            ('Catering Plus', 2000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 2, CURRENT_DATE))),
            ('Catering Plus', 1500, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 3, CURRENT_DATE))),
            ('Dave''s Discos', 500, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 1, CURRENT_DATE))),
            ('Entertainment tonight', 6000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 3, CURRENT_DATE))),
            ('Ice Ice Baby', 4000, LAST_DAY_OF_MONTH(DATE_ADD('MONTH', 6, CURRENT_DATE)));


CREATE TABLE IF NOT EXISTS memory.default.invoice (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);


INSERT INTO memory.default.invoice (supplier_id, invoice_amount, due_date)
     SELECT s.supplier_id,
            id.invoice_amount,
            id.due_date
       FROM memory.default.supplier s
 INNER JOIN memory.default.invoices_due id
         ON id.name = s.name;


DROP TABLE IF EXISTS memory.default.invoices_due;
