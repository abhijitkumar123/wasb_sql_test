USE memory.default;

DROP TABLE IF EXISTS pay_plan;

-- intermediate table
CREATE TABLE pay_plan AS
SELECT 
	supplier_id,
	(SELECT name FROM supplier as ns WHERE ns.supplier_id = invoice.supplier_id) AS supplier_name,
	invoice_amount,
	due_date
FROM 
    invoice;
	
-- report (bit different) - this will group invoices by date and by supplier and sums only matching 'end-of months' for the same suppliers, which seems logical
-- not quite sure what the requirement was getting at so maybe this not what's wanted

SELECT 
    supplier_id,
    supplier_name,
    SUM(invoice_amount) AS total_invoice_amount,
    due_date
FROM 
    pay_plan
GROUP BY 
    due_date, supplier_id, supplier_name
ORDER BY 
    due_date, supplier_id;

