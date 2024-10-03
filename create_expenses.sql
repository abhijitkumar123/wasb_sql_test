USE memory.default;

CREATE TABLE expense (
    employee_id TINYINT,
    item VARCHAR,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);

INSERT INTO expense (employee_id, item, unit_price, quantity)
VALUES
(1, 'I had too much fun and needed something to eat',150.75, 3),
(2, 'So Many Drinks!', 120.50, 2),
(3, 'So Many Drinks!', 500.00, 1);
