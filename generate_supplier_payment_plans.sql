WITH dates AS (
        SELECT supplier_id,
               due_date,
               months,
               total_months,
               last_day_of_month(date_add('MONTH', months, current_date)) AS payment_date
          FROM (
                SELECT supplier_id,
                       due_date,
                       total_months,
                       SEQUENCE(0, total_months - 1) AS months_array
                  FROM (
                        SELECT supplier_id,
                               due_date,
                               date_diff('month', LAST_DAY_OF_MONTH(CURRENT_DATE), due_date) AS total_months
                          FROM memory.default.invoice
                       )
               )
    CROSS JOIN UNNEST(months_array) AS t(months)
)
   SELECT a.supplier_id,
          s.name AS supplier_name,
          a.payment_amount,
          b.total_amount - sum(a.payment_amount) OVER (PARTITION BY a.supplier_id ORDER BY a.payment_date) AS balance_outstanding,
          a.payment_date
     FROM (
             SELECT supplier_id,
                    payment_date,
                    sum(payment_amount) AS payment_amount
               FROM (
                        SELECT i.supplier_id,
                               d.payment_date,
                               i.invoice_amount,
                               i.invoice_amount / d.total_months AS payment_amount,
                               d.months,
                               d.total_months
                          FROM memory.default.invoice i
                     LEFT JOIN dates d
                            ON d.supplier_id = i.supplier_id
                           AND d.due_date = i.due_date
                    )
           GROUP BY supplier_id, payment_date
          ) AS a
LEFT JOIN (
             SELECT supplier_id,
                    sum(invoice_amount) AS total_amount
               FROM memory.default.invoice i
           GROUP BY supplier_id
          ) b
       ON a.supplier_id = b.supplier_id
LEFT JOIN memory.default.supplier AS s
       ON a.supplier_id = s.supplier_id
 ORDER BY supplier_id,
          payment_date;
