USE memory.default;

CREATE TABLE IF NOT EXISTS EXPENSE (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);

TRUNCATE TABLE EXPENSE;

CREATE TABLE IF NOT EXISTS RAW_EXPENSES (
    employee_name VARCHAR(100),
    items VARCHAR(255),
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);

TRUNCATE TABLE RAW_EXPENSES;

INSERT INTO RAW_EXPENSES (employee_name, items, unit_price, quantity) VALUES
('Alex Jacobson', 'Drinks, lots of drinks', 6.50, 14),
('Alex Jacobson', 'More Drinks', 11.00, 20),
('Alex Jacobson', 'So Many Drinks!', 22.00, 18),
('Alex Jacobson', 'I bought everyone in the bar a drink!', 13.00, 75),
('Andrea Ghibaudi', 'Flights from Mexico back to New York', 300.00, 1),
('Darren Poynton', 'Ubers to get us all home', 40.00, 9),
('Umberto Torrielli', 'I had too much fun and needed something to eat', 17.50, 4);


INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT 
    e.employee_id,
    re.unit_price,
    re.quantity
FROM 
    RAW_EXPENSES re
JOIN 
    EMPLOYEE e ON CONCAT(e.first_name, ' ', e.last_name) = re.employee_name;

SELECT * FROM EXPENSE;