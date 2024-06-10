-- Calculate the total months difference between the current date and the due date for each invoice
WITH INVOICE_MONTHS AS (
    SELECT 
        I.SUPPLIER_ID,
        I.DUE_DATE,
        I.INVOICE_AMOUNT,
        DATE_DIFF('MONTH', LAST_DAY_OF_MONTH(CURRENT_DATE), I.DUE_DATE) AS TOTAL_MONTHS
    FROM 
        MEMORY.DEFAULT.INVOICE I
),
-- Generate the payment dates and corresponding months for each invoice
DATES AS (
    SELECT 
        IM.SUPPLIER_ID,
        IM.DUE_DATE,
        IM.INVOICE_AMOUNT,
        IM.TOTAL_MONTHS,
        D.MONTHS,
        LAST_DAY_OF_MONTH(DATE_ADD('MONTH', D.MONTHS, CURRENT_DATE)) AS PAYMENT_DATE
    FROM 
        INVOICE_MONTHS IM
    CROSS JOIN UNNEST(SEQUENCE(0, IM.TOTAL_MONTHS - 1)) AS D(MONTHS)
),
-- Aggregate the monthly payment amounts for each supplier and payment date
PAYMENTS AS (
    SELECT 
        D.SUPPLIER_ID,
        D.PAYMENT_DATE,
        SUM(D.INVOICE_AMOUNT / D.TOTAL_MONTHS) AS PAYMENT_AMOUNT
    FROM 
        DATES D
    GROUP BY 
        D.SUPPLIER_ID, D.PAYMENT_DATE
),
-- Calculate the total invoice amount for each supplier
SUPPLIER_TOTALS AS (
    SELECT 
        I.SUPPLIER_ID,
        SUM(I.INVOICE_AMOUNT) AS TOTAL_AMOUNT
    FROM 
        MEMORY.DEFAULT.INVOICE I
    GROUP BY 
        I.SUPPLIER_ID
)
-- Final query to get supplier name, payment amount, balance outstanding, and payment date
SELECT 
    P.SUPPLIER_ID,
    S.NAME AS SUPPLIER_NAME,
    P.PAYMENT_AMOUNT,
    ST.TOTAL_AMOUNT - SUM(P.PAYMENT_AMOUNT) OVER (PARTITION BY P.SUPPLIER_ID ORDER BY P.PAYMENT_DATE) AS BALANCE_OUTSTANDING,
    P.PAYMENT_DATE
FROM 
    PAYMENTS P
LEFT JOIN 
    SUPPLIER_TOTALS ST ON P.SUPPLIER_ID = ST.SUPPLIER_ID
LEFT JOIN 
    MEMORY.DEFAULT.SUPPLIER S ON P.SUPPLIER_ID = S.SUPPLIER_ID
ORDER BY 
    P.SUPPLIER_ID, P.PAYMENT_DATE;
