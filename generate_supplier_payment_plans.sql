WITH PAYMENTS AS (SELECT
I.supplier_id,
S.name AS supplier_name,
SUM(I.invoice_amount) AS total_outstanding,
DUE_DATE AS payment_date,
(SUM(I.invoice_amount) / (DATE_DIFF('day', CURRENT_DATE, DUE_DATE) / 30 + 1)) AS payment_amount, 
(DATE_DIFF('day', CURRENT_DATE, DUE_DATE) / 30 + 1) AS payment_months
FROM
INVOICE I
JOIN 
SUPPLIER S ON I.supplier_id = S.supplier_id
WHERE
DUE_DATE > CURRENT_DATE  
GROUP BY
I.supplier_id, S.name, DUE_DATE),

numbers AS (
SELECT
row_number() OVER () AS num
FROM   
INFORMATION_SCHEMA.COLUMNS  
),

months AS (   
SELECT num 
FROM numbers
WHERE num <= (SELECT MAX(payment_months) FROM payments)
),

total_out AS (  
SELECT SUM(I.invoice_amount) AS Total_Outstanding,I.supplier_id
FROM INVOICE I GROUP BY I.supplier_id  
),

sched AS (
SELECT  
p.supplier_id,
p.supplier_name,
p.payment_amount AS payment,  
t.Total_Outstanding,
(SUM(p.payment_amount) OVER (PARTITION BY p.supplier_id ORDER BY m.num))AS total_payments, 
DATE_TRUNC('MONTH', CURRENT_DATE + INTERVAL '1' MONTH * (m.num - 1)) + INTERVAL '1' MONTH - INTERVAL '1' DAY AS payment_date
FROM payments p  
JOIN months m ON m.num <= p.payment_months
JOIN total_out t ON t.supplier_id = p.supplier_id   
)

SELECT supplier_id, supplier_name,  SUM(payment) AS payment_amount, (Total_Outstanding - total_payments) AS balance_outstanding,payment_date  
FROM sched
GROUP BY supplier_id, supplier_name, payment_date,Total_Outstanding,total_payments  
ORDER BY supplier_id;
