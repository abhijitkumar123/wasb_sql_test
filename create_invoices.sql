-- Create Invoice table:
CREATE TABLE INVOICE (
  supplier_id TINYINT,
  invoice_amount DECIMAL(8, 2),
  due_date DATE
);

-- Create supplier table:
CREATE TABLE SUPPLIER (
  supplier_id TINYINT,
  name VARCHAR
);

-- Insert data to Invoices table:
INSERT INTO INVOICE (supplier_id, invoice_amount, due_date ) VALUES
(1,  ‘6000.00’, ‘31-01-2025’),
(2,  ‘2000.00’, ‘31-12-2024’),
(2,  ‘1500.00’, ‘31-01-2025’),
(3,  ‘500.00’, ‘29-11-2024’),
(4,  ‘6000.00', ‘31-01-2025’),
(5,  ‘4000.00', ‘30-04-2025’),



--Tests would be the same as 'create_employees.sql'