-- Supplier Table definition
CREATE TABLE memory.default.supplier (
    supplier_id TINYINT,
    name varchar
)
;

-- Invoice Table with Foreign Key referencing Supplier Table
-- CREATE TABLE memory.default.invoice (
--     supplier_id TINYINT,
--     invoice_ammount DECIMAL(8, 2),
--     due_date DATE,
--     FOREIGN KEY (supplier_id) REFERENCES memory.default.supplier(supplier_id)
-- )
-- ;
-- This is because Trino is primarily a query engine that interacts with external data sources 
-- (e.g., Hive, MySQL, PostgreSQL, etc.), and it relies on those data sources to manage and 
-- enforce constraints like primary keys and foreign keys.

CREATE TABLE memory.default.invoice (
    supplier_id TINYINT,
    invoice_ammount DECIMAL(8, 2),
    due_date DATE
)
;



-- Insert data into supplier
INSERT INTO memory.default.supplier VALUES
(1, 'Party Animals'),
(2, 'Catering Plus'),
(3, 'Dave Discos'),
(4, 'Entertainment tonight'),
(5, 'Ice Ice Baby')
;


-- Insert data into invoice
INSERT INTO memory.default.invoice VALUES
(1, 6000, DATE '2024-12-31'),
(2, 2000, DATE  '2024-11-30'),
(2, 1500, DATE  '2024-12-31'),
(3, 500, DATE  '2024-10-30'),
(4, 6000, DATE  '2024-12-31'),
(5, 4000, DATE  '2025-03-31')
;