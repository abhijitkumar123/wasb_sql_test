--Create Expense Table
create table EXPENSE(
employee_id TINYINT
,unit_price DECIMAL(8, 2)
,quantity TINYINT
);


--Insert data into Expense Table
Insert into EXPENSE
values(3,6.50,14),(3,11.00,20),(3,22.00,18),(3,13.00,75),(9,300.00,1),(4,40.00,9),(2,17.50,4);
