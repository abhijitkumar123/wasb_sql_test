-- Expense Table definition
CREATE TABLE memory.default.expense (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
)
;


-- Inserting data from drinkies
INSERT INTO memory.default.expense VALUES
(3, 6.50, 14),
(3, 11, 20),
(3, 22, 18),
(3, 13, 75),
(9, 300, 1),
(4, 40, 9),
(2, 17.50, 4)
;