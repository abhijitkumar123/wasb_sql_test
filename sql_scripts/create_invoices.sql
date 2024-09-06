CREATE TABLE IF NOT EXISTS memory.default.invoices (
    supplier_id TINYINT,
    invoice_amount DECIMAL(8, 2),
    due_date DATE
)