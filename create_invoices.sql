--Create Invoice Table

create table INVOICE(
supplier_id TINYINT
,invoice_amount DECIMAL(8, 2)
,due_date DATE
);


--Insert data into Invoice Table
Insert into INVOICE
values(5,6000.00,last_day_of_month(current_date + interval '3' month)),(1,2000.00,last_day_of_month(current_date + interval '2' month)),(1,1500.00,last_day_of_month(current_date + interval '3' month)),
(2,500.00,last_day_of_month(current_date + interval '1' month)),(3,6000.00,last_day_of_month(current_date + interval '3' month)),(4,4000.00,last_day_of_month(current_date + interval '6' month));


--Create Supplier Table
create table SUPPLIER(
supplier_id TINYINT
,name VARCHAR
);


--Insert data into Supplier Table
Insert into SUPPLIER
values (1,'Catering Plus'),(2,'Dave''s Discos'),(3,'Entertainment tonight'),(4,'Ice Ice Baby'),(5,'Party Animals');
