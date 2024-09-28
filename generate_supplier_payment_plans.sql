--==============================================
-- Calcuate the total balances for each supplier
--==============================================
WITH balances_outstanding AS 
(
    SELECT 
        supp.supplier_id
        ,supp.name   AS supplier_name
        ,SUM(inv.invoice_amount) AS balance_outstanding  -- shows total bill owed
        ,COUNT(inv.invoice_amount) AS number_of_invoices -- number of invoices this bill has come from 
    FROM 
        INVOICE    AS inv
    INNER JOIN 
        SUPPLIER     AS supp
        ON inv.supplier_id = supp.supplier_id
    GROUP BY
        supp.supplier_id
        ,supp.name
)
-- SELECT * FROM balances_outstanding;
--==============================================
-- Break into monthly payments before the invoice due dates
--==============================================
, monthly_payments AS 
(
    SELECT 
        sup.name            AS supplier_name 
        ,sup.supplier_id
        ,bo.balance_outstanding
        ,ABS(ROUND(bo.balance_outstanding / CEILING(DATE_DIFF('day',MAX(inv.due_date), last_day_of_month(CURRENT_DATE))/30),2)) AS monthly_payment -- divides the total balance based on the number of months between latest payment date and final due date
        ,last_day_of_month(CURRENT_DATE)  AS payment_date
    FROM 
        INVOICE     AS inv
    LEFT JOIN 
        SUPPLIER    AS sup
        ON inv.supplier_id = sup.supplier_id 
    INNER JOIN 
        balances_outstanding AS bo
        ON sup.supplier_id = bo.supplier_id
    GROUP BY 
        sup.name            
        ,sup.supplier_id
        ,bo.balance_outstanding
)
--SELECT * FROM monthly_payments;
--==============================================
-- Generate payment plans with multiple months
--==============================================
,payment_plans AS 
(
    SELECT
        mp.supplier_id
        ,mp.supplier_name
        ,mp.monthly_payment AS payment_amount
        ,GREATEST(mp.balance_outstanding - (mp.monthly_payment * (n - 1)), 0) AS balance_outstanding -- is meant to find the largest payment possible between the months 
        ,DATE_ADD('DAY',-1,DATE_ADD('MONTH',1,DATE_TRUNC('MONTH', DATE_ADD('MONTH', n - 1, CURRENT_DATE))))  AS payment_date  -- shows in which SExl can make payment from the earliest point
    FROM
        monthly_payments mp,
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6) AS nums
    WHERE
        mp.balance_outstanding > 0
        AND GREATEST(mp.balance_outstanding - (mp.monthly_payment * (n - 1)), 0) > 0
    ORDER BY
        mp.supplier_id, payment_date
)
SELECT 
    supplier_id
    ,supplier_name
    ,payment_amount
    ,balance_outstanding
    ,payment_date
FROM 
    payment_plans 
ORDER BY 
    supplier_id
    , payment_date;