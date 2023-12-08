CREATE TABLE IF NOT EXISTS SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE IF NOT EXISTS INVOICE (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);


CREATE TABLE INVOICESTAGING
(
	CompanyName VARCHAR,
	InvoiceItems VARCHAR,
	InvoiceAmount VARCHAR,
	DueDate VARCHAR
);


INSERT INTO InvoiceStaging VALUES
    ('Party Animals', 'Zebra, Lion, Giraffe, Hippo', '6000', '3 months from now'),
    ('Catering Plus', 'Champagne, Whiskey, Vodka, Gin, Rum, Beer, Wine.', '2000', '2 months from now'),
    ('Catering Plus', 'Pizzas, Burgers, Hotdogs, Cauliflour Wings, Caviar', '1500', '3 months from now'),
    ('Dave''s Discos', 'Dave, Dave Equipment', '500', '1 month from now'),
    ('Entertainment tonight', 'Portable Lazer tag, go carts, virtual darts, virtual shooting, puppies.', '6000', '3 months from now'),
    ('Ice Ice Baby', 'Ice Luge, Lifesize ice sculpture of Umberto', '4000', '6 months from now');
	

INSERT INTO SUPPLIER
SELECT
    row_number() OVER (ORDER BY CompanyName) AS supplier_id,
    CompanyName AS name
FROM
    InvoiceStaging
GROUP BY
    CompanyName
ORDER BY
    CompanyName ASC;

INSERT INTO INVOICE
SELECT
    S.supplier_id,
    CAST(I.InvoiceAmount AS DECIMAL(8, 2)) AS InvoiceAmount,
    DATE_ADD('DAY', -1, DATE_ADD('MONTH', CAST(SUBSTRING(CAST(I.DueDate AS VARCHAR) FROM 1 FOR 1) AS BIGINT), DATE_TRUNC('MONTH', current_date))) AS DueDate
FROM
    SUPPLIER S
INNER JOIN
    InvoiceStaging I ON S.name = I.CompanyName;

DROP TABLE InvoiceStaging;
