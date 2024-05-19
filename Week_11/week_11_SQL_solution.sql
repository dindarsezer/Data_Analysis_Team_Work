----- DS DE WEEKLY AGENDA WEEK-11 RDB&SQL QUESTIONS-3-----

-----1
-----. Report cumulative total turnover by months in each year in pivot table format.

SELECT * 
FROM
	(
	SELECT	distinct YEAR (A.order_date) ord_year, MONTH(A.order_date) ord_month, 
	SUM(quantity*list_price) OVER (PARTITION BY YEAR (A.order_date) ORDER BY YEAR (A.order_date), MONTH(A.order_date)) turnover
	FROM	sale.orders A, sale.order_item B
	WHERE	A.order_id = B.order_id
	) A
PIVOT
	(
	MAX(turnover)
	FOR ord_year
	IN ([2018], [2019],[2020])
	)
PIVOT_TA

---- . What percentage of customers purchasing a product have purchased the same product again?----


SELECT	soi.product_id,
		CAST(1.0*(COUNT(so.customer_id) - COUNT(DISTINCT so.customer_id))/COUNT(so.customer_id) AS DECIMAL(3,2)) per_of_cust_pur
FROM	sale.order_item soi, sale.orders so
		WHERE	soi.order_id = so.order_id		
GROUP BY soi.product_id;


---Alternative solution
with T1 as
(
select  product_id,
sum(case when  counts >=2 then 1 else 0 end) as customer_counts ,
count(customer_id) as totl_customer
from
(
select  distinct  b.product_id,  a.customer_id,
count(a.customer_id) over( partition by b.product_id, a.customer_id ) as counts
from sale.orders a, sale.order_item b
where  a.order_id = b.order_id) as X
group by product_id )
select product_id, cast(1.0*customer_counts/totl_customer as numeric(3,2)) per_of_cust_pur
from T1;



