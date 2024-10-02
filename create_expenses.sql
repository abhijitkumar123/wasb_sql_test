 -- This SQL file was generated from 02_create_expenses_SQL.py on 2024-10-01 20:25:53 
 
 -- SQL to create the EXPENSE table
CREATE TABLE IF NOT EXISTS EXPENSE (
    employee_id TINYINT,
    unit_price DECIMAL(8, 2),
    quantity TINYINT
);

-- Insert data from duh_i_think_i_got_too_many.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 13.00, 75
FROM EMPLOYEE emp
WHERE emp.first_name = 'Alex' AND emp.last_name = 'Jacobson';;

-- Insert data from i_got_lost_on_the_way_home_and_now_im_in_mexico.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 300.00, 1
FROM EMPLOYEE emp
WHERE emp.first_name = 'Andrea' AND emp.last_name = 'Ghibaudi';;

-- Insert data from drinkss.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 22.00, 18
FROM EMPLOYEE emp
WHERE emp.first_name = 'Alex' AND emp.last_name = 'Jacobson';;

-- Insert data from ubers.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 40.00, 9
FROM EMPLOYEE emp
WHERE emp.first_name = 'Darren' AND emp.last_name = 'Poynton';;

-- Insert data from we_stopped_for_a_kebabs.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 17.50, 4
FROM EMPLOYEE emp
WHERE emp.first_name = 'Umberto' AND emp.last_name = 'Torrielli';;

-- Insert data from drinks.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 11.00, 20
FROM EMPLOYEE emp
WHERE emp.first_name = 'Alex' AND emp.last_name = 'Jacobson';;

-- Insert data from drinkies.txt
INSERT INTO EXPENSE (employee_id, unit_price, quantity)
SELECT emp.employee_id, 6.50, 14
FROM EMPLOYEE emp
WHERE emp.first_name = 'Alex' AND emp.last_name = 'Jacobson';;

