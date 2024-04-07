CREATE TABLE IF NOT EXISTS memory.default.expense_receipts (
    employee VARCHAR(255),
    items VARCHAR(255),
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);


INSERT INTO memory.default.expense_receipts (employee, items, unit_price, quantity)
     VALUES ('Alex Jacobson', 'I bought everyone in the bar a drink!', 13.00, 75),
            ('Alex Jacobson', 'So Many Drinks!', 22.00, 18),
            ('Darren Poynton', 'Ubers to get us all home', 40.00, 9),
            ('Andrea Ghibaudi', 'Flights from Mexico back to New York', 300, 1),
            ('Umberto Torrielli', 'I had too much fun and needed something to eat', 17.50, 4),
            ('Alex Jacobson', 'More Drinks', 11.00, 20),
            ('Alex Jacobson', 'Drinks, lots of drinks', 6.50, 14);


CREATE TABLE IF NOT EXISTS memory.default.expense (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);


INSERT INTO memory.default.expense (employee_id, unit_price, quantity)
     SELECT e.employee_id,
            er.unit_price,
            er.quantity
       FROM memory.default.expense_receipts AS er
 INNER JOIN memory.default.employee AS e
         ON lower(er.employee) = lower(concat_ws(' ', e.first_name, e.last_name));


DROP TABLE IF EXISTS memory.default.expense_receipts;
