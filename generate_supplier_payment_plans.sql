WITH RECURSIVE dates_master(min_date,max_date) AS (
select
min(last_day_of_month(current_date+interval '1'month)) as min_date,
max(due_date) as max_date 
from invoice
UNION ALL
select
last_day_of_MONTH(date_add('Month',1,min_date))as dates, 
max_date from
dates_master
WHERE min_date < max_date
)
select
	 s.SUPPLIER_ID ,
s.name SUPPLIER_NAME,
PAYMENT_AMOUNT,
BALANCE_OUTSTANDING,
PAYMENT_DATE
from

(select
	 i.supplier_id as SUPPLIER_ID ,
	  sum(i.invoice_amount / DATE_DIFF('month', last_day_of_month(current_date), i.due_date)) AS PAYMENT_AMOUNT ,
sum(invoice_amount) - (sum(i.invoice_amount / DATE_DIFF('month', last_day_of_month(current_date), i.due_date)))* DATE_DIFF('MONTH', last_day_of_month(current_date), min_date) BALANCE_OUTSTANDING ,
min_date as PAYMENT_DATE
from
 dates_master  join invoice i
on dates_master.min_date <= i.due_date 
group by i.supplier_id,
min_date,
DATE_DIFF('MONTH', last_day_of_month(current_date), min_date)
order by i.supplier_id,
min_date)final
join supplier s on s.supplier_id =final.SUPPLIER_ID
order by 1,5
;
