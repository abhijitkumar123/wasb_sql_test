-- Create EMPLOYEE table for the fields employee_id, unit_price, quantity as given in Readme file  --
CREATE TABLE expense (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
                     );


-- Insert the expense receipt details for Alex Jacobson (Ref Emp ID: 3 from Employee table) --
INSERT INTO expense (employee_id, unit_price, quantity)
VALUES
    (3, 6.50, 14),
    (3, 11.00, 20),
    (3, 22.00, 18),
    (3, 13.00, 75);

-- Insert the expense receipt details for Andrea Ghibaudi (Ref Emp ID: 9 from Employee table) --
INSERT INTO expense (employee_id, unit_price, quantity)
VALUES
    (9, 300.00, 1);

-- Insert the expense receipt details for Darren Poynton (Ref Emp ID: 4 from Employee table) --
INSERT INTO expense (employee_id, unit_price, quantity)
VALUES
    (4, 40.00, 9);

-- Insert the expense receipt details for Umberto Torrielli (Ref Emp ID: 2 from Employee table) --
INSERT INTO expense (employee_id, unit_price, quantity)
VALUES
    (2, 17.50, 4);