-- Create SUPPLIER table for the fields supplier_id & name as given in Readme file  --
CREATE TABLE supplier (
    supplier_id TINYINT,
    name VARCHAR
);

-- Create INVOICE table for entering supplier invoice info as given in Readme file --
CREATE TABLE invoice (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

-- First creating a suuplier ID & Suuplier Name info in SUPPLIER TABLE --
INSERT INTO supplier (supplier_id, name)
VALUES
    (1, 'Catering Plus'),
    (2, 'Dave''s Discos'),
    (3, 'Entertainment Tonight'),
    (4, 'Ice Ice Baby'),
    (5, 'Party Animals');

-- Now inserting the invoice details for "Catering Plus" as given in invoice_due files --
-- date_trunc('month', current_date + INTERVAL '2' month) --> Given gives same nth day after 2 months. Ex: 2 November
-- + INTERVAL '1' month - INTERVAL '1' day -> to get a last day of that month, Ex: 30th Nov
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
VALUES
    (1, 2000, date_trunc('month', current_date + INTERVAL '2' month)
                  + INTERVAL '1' month - INTERVAL '1' day);

INSERT INTO invoice (supplier_id, invoice_amount, due_date)
VALUES
    (1, 1500, date_trunc('month', current_date + INTERVAL '3' month)
                  + INTERVAL '1' month - INTERVAL '1' day);

-- Now inserting the invoice details for "Dave's Discos" as given in invoice_due files --
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
VALUES
    (2, 500, date_trunc('month', current_date + INTERVAL '1' month)
                 + INTERVAL '1' month - INTERVAL '1' day);

-- Now inserting the invoice details for "Entertainment Tonight" as given in invoice_due files --
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
VALUES
    (3, 6000, date_trunc('month', current_date + INTERVAL '3' month)
                  + INTERVAL '1' month - INTERVAL '1' day);

-- Now inserting the invoice details for "Ice Ice Baby" as given in invoice_due files --
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
VALUES
    (4, 4000, date_trunc('month', current_date + INTERVAL '6' month)
                  + INTERVAL '1' month - INTERVAL '1' day);

-- Now inserting the invoice details for "Party Animals" as given in invoice_due files --
INSERT INTO invoice (supplier_id, invoice_amount, due_date)
VALUES
    (5, 6000, date_trunc('month', current_date + INTERVAL '3' month)
                  + INTERVAL '1' month - INTERVAL '1' day);
