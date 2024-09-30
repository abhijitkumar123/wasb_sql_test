
SELECT s.supplier_id,
       s.name                AS supplier_name,
       SUM(i.invoice_amount) AS payment_amount,
       SUM(i.invoice_amount) AS balance_outstanding,
       i.due_date            AS payment_date
FROM   supplier s
       JOIN invoice i
         ON s.supplier_id = i.supplier_id
GROUP  BY s.supplier_id,
          s.name,
          i.due_date
ORDER  BY payment_date;
