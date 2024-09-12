USE memory.default;

CREATE TABLE IF NOT EXISTS RAW_INVOICE (
    company_name VARCHAR,
    invoice_items VARCHAR,
    invoice_amount DECIMAL(8, 2),
    due_date_months INTEGER
);
TRUNCATE TABLE RAW_INVOICE;

INSERT INTO RAW_INVOICE (company_name, invoice_items, invoice_amount, due_date_months)
VALUES
    ('Party Animals', 'Zebra, Lion, Giraffe, Hippo', 6000, 3),
    ('Catering Plus', 'Champagne, Whiskey, Vodka, Gin, Rum, Beer, Wine.', 2000, 2),
    ('Catering Plus', 'Pizzas, Burgers, Hotdogs, Cauliflour Wings, Caviar', 1500, 3),
    ('Dave''s Discos', 'Dave, Dave Equipment', 500, 1),
    ('Entertainment tonight', 'Portable Lazer tag, go carts, virtual darts, virtual shooting, puppies.', 6000, 3),
    ('Ice Ice Baby', 'Ice Luge, Lifesize ice sculpture of Umberto', 4000, 6);

CREATE TABLE IF NOT EXISTS SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE IF NOT EXISTS INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

TRUNCATE TABLE SUPPLIER;
TRUNCATE TABLE INVOICE;

-- Populate SUPPLIER table based on unique company names in RAW_INVOICE
INSERT INTO SUPPLIER (supplier_id, name)
SELECT 
    CAST(ROW_NUMBER() OVER (ORDER BY company_name) AS TINYINT) AS supplier_id,
    company_name AS name
FROM (SELECT DISTINCT company_name FROM RAW_INVOICE) AS unique_suppliers;

INSERT INTO INVOICE (supplier_id, invoice_amount, due_date)
SELECT 
    s.supplier_id,
    r.invoice_amount,
    LAST_DAY_OF_MONTH(DATE_ADD('MONTH', r.due_date_months, CURRENT_DATE)) AS due_date
FROM RAW_INVOICE r
JOIN SUPPLIER s ON r.company_name = s.name;


-- Verify the data in INVOICE table
SELECT 
    s.supplier_id,
    s.name AS supplier_name,
    i.invoice_amount,
    i.due_date
FROM INVOICE i
JOIN SUPPLIER s ON i.supplier_id = s.supplier_id
ORDER BY s.supplier_id, i.due_date;
