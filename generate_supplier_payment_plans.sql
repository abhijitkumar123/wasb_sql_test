-- #############################################################################################
-- # Created By: Milind Keer
-- # Created on: 01/10/2024
-- # Description: Create a SQL query to report the supplier_id, supplier_name, payment_amount, balance_outstanding, payment_date for each of our suppliers/invoices in SExI.
-- supplier_name is the SUPPLIER.name of the SUPPLIER.supplier_id.
-- payment_amount should be the sum of all appropriate uniform monthly payments to fully pay the SUPPLIER for any INVOICE before the INVOICE.due_date. If a supplier has multiple invoices, the aggregate monthly payments may be uneven.
-- balance_outstanding is the total balance outstanding across ALL INVOICEs for the SUPPLIER.supplier_id.
-- date should be the last day of the month for any payment for any invoice.
-- SUPPLIERs with multiple invoices should receive 1 payment per month.
-- payments start at the end of this month.
-- #############################################################################################

WITH InvoicePayments AS (
    SELECT 
    s.supplier_id, 
    s.name AS supplier_name,
    SUM(i.invoice_amount) AS invoice_amount,  -- Aggregate invoice amounts
    MAX(i.due_date) AS max_due_date,               -- Get the latest due date
    1500 AS monthly_payment,                         -- Fixed monthly payment of £1500
    CEIL(SUM(i.invoice_amount) / 1500) AS total_months -- Calculate total months needed for payment
    FROM 
        supplier s
    JOIN 
        invoice i ON s.supplier_id = i.supplier_id
    GROUP BY 
        s.supplier_id, 
        s.name

),
PaymentSchedule AS (
    -- Generate a sequence of months for each supplier/invoice, casting total_months as bigint
    SELECT 
        supplier_id,
        supplier_name,
        invoice_amount,
        monthly_payment,
        month_offset
    FROM 
        InvoicePayments
    -- Create a sequence for the number of months it will take to pay off the invoice
    CROSS JOIN UNNEST(SEQUENCE(0, CAST(total_months AS bigint) - 1)) AS t(month_offset)
),
Payments AS (
    -- Calculate the cumulative payments and remaining balance for each supplier per month
    SELECT 
        supplier_id,
        supplier_name,
        month_offset,
        invoice_amount,
        LAST_DAY_OF_MONTH(DATE_ADD('month', month_offset, current_date)) AS payment_date,
        -- Calculate the remaining balance after payments up to this point
        GREATEST(invoice_amount - (month_offset * 1500), 0) AS balance_outstanding,
        -- Set payment amount as £1500 unless the remaining balance is less than £1500
        CASE 
            WHEN invoice_amount - (month_offset * 1500) >= 1500 THEN 1500
            ELSE invoice_amount - (month_offset * 1500)
        END AS payment_amount,
        -- Check if it’s the last payment (where balance should be zero after payment)
        CEIL(invoice_amount / 1500) - 1 = month_offset AS is_last_payment
    FROM 
        PaymentSchedule
)
-- Filter out rows where the balance is zero and no payment is needed
SELECT 
    supplier_id,
    supplier_name,
    payment_amount,
    -- Set balance_outstanding to zero for the last payment
    CASE 
        WHEN is_last_payment THEN 0 
        ELSE balance_outstanding 
    END AS balance_outstanding,
    payment_date
FROM 
    Payments
WHERE 
    payment_amount > 0 -- Make sure we don’t show zero payments
ORDER BY 
    supplier_id, payment_date, balance_outstanding DESC;
