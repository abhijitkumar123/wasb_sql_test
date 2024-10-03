USE memory.default;

CREATE TABLE supplier (
    supplier_id TINYINT,
    name VARCHAR
);

CREATE TABLE invoice (
    invoice_id TINYINT,
    supplier_id TINYINT,
    invoice_item VARCHAR,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
);

INSERT INTO supplier (supplier_id, name) VALUES
(1, 'Catering Plus'),
(2, 'Event Lights Co.');

INSERT INTO invoice (invoice_id, supplier_id, invoice_item, invoice_amount, due_date) VALUES
(1, 1, 'Catering for Event A', 1500.00, DATE '2024-10-31'),
(2, 2, 'Lighting for Event B', 750.00, DATE '2024-11-30');

