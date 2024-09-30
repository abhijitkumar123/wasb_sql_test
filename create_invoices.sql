CREATE TABLE SUPPLIER (
    supplier_id TINYINT,
    name VARCHAR
);

INSERT INTO SUPPLIER VALUES (1, 'Catering Plus');
INSERT INTO SUPPLIER VALUES (2, 'Dave''s Discos');
INSERT INTO SUPPLIER VALUES (3, 'Entertainment tonight');
INSERT INTO SUPPLIER VALUES (4, 'Ice Ice Baby');
INSERT INTO SUPPLIER VALUES (5, 'Party Animals');

CREATE TABLE INVOICE (
supplier_id TINYINT,
invoice_amount DECIMAL(8, 2),
due_date DATE);

INSERT INTO INVOICE VALUES (5, 6000, last_day_of_month(now() + interval '3' month));
INSERT INTO INVOICE VALUES (5, 6000, last_day_of_month(now() + interval '3' month));
INSERT INTO INVOICE VALUES (1, 2000, last_day_of_month(now() + interval '2' month));
INSERT INTO INVOICE VALUES (1, 1500, last_day_of_month(now() + interval '3' month));
INSERT INTO INVOICE VALUES (2, 500, last_day_of_month(now() + interval '1' month));
INSERT INTO INVOICE VALUES (3, 6000, last_day_of_month(now() + interval '3' month));
INSERT INTO INVOICE VALUES (3, 4000, last_day_of_month(now() + interval '6' month));
