Create table if not exists supplier (
    supplier_id TINYINT,
    name VARCHAR
);


INSERT INTO supplier VALUES

(1,'Catering Plus'),
(2,'Daves Discos'),
(3,'Entertainment tonight'),
(4,'Ice Ice Baby'),
(5,'Party Animals')

;


Create table if not exists invoice (

    supplier_id TINYINT,
    invoice_ammount DECIMAL(8, 2),
    due_date DATE


);


INSERT INTO invoice VALUES

(5,6000,date_add('month',3,last_day_of_month(current_date))),
(1,2000,date_add('month',2,last_day_of_month(current_date))),
(1,1500,date_add('month',3,last_day_of_month(current_date))),
(2,500,date_add('month',1,last_day_of_month(current_date))),
(3,6000,date_add('month',3,last_day_of_month(current_date))),
(4,4000,date_add('month',6,last_day_of_month(current_date)))
;