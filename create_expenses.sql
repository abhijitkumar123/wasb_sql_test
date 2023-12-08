CREATE TABLE IF NOT EXISTS EXPENSE (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);
	
INSERT INTO EXPENSE VALUES
(3, 6.5, 14),
(3, 11, 20),
(3, 22, 18),
(3, 13, 75),
(9, 300, 1),
(4, 40, 9),
(2, 17.5, 4);
