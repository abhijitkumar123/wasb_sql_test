/*-------------------------------
TASK:2 - CREATING EXPENSE TABLE
-------------------------------*/
CREATE TABLE EXPENSE(
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);


/*-------------------------------
CREATING EMPLOYEE RECEIPTS TABLE
-------------------------------*/
CREATE TABLE EXPENSE_RECEIPTS(
    receipt_id TINYINT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    items VARCHAR(255),
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);


/*---------------------------------------
INSERTING VALUES TO EXPENSE RECEIPT TABLE
----------------------------------------*/
INSERT INTO EXPENSE_RECEIPTS VALUES
    (1, 'Alex', 'Jacobson', 'Drinks', 6.50, 14),
    (2, 'Alex', 'Jacobson', 'Drinks', 11.00, 20),
    (3, 'Alex', 'Jacobson', 'Drinks', 22.00, 18),
    (4, 'Alex', 'Jacobson', 'Drinks', 13.00, 75),
    (5, 'Andrea', 'Ghibaudi', 'Flight', 300.00, 1),
    (6, 'Darren', 'Poynton', 'Uber', 40.00, 9),
    (7, 'Umberto', 'Torrielli', 'Kebabs', 17.50, 4);


/*-------------------------------
INSERTING VALUES TO EXPENSE TABLE
-------------------------------*/
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT
    e.employee_id,
    er.unit_price,
    er.quantity
FROM
    EXPENSE_RECEIPTS er
JOIN
    EMPLOYEE e ON er.first_name = e.first_name AND er.last_name = e.last_name;