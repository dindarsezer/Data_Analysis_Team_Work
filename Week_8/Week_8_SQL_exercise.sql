---- 1. List all the cities in the Texas and the numbers of customers in each city.----

SELECT * FROM sale.customer

SELECT 
	city, 
	COUNT(customer_id) Number_of_Customers
FROM sale.customer
WHERE state = 'TX'
GROUP BY city;


---- 2. List all the cities in the California which has more than 5 customer, by showing the cities which have more customers first.----

SELECT * FROM sale.customer

SELECT 
	city, 
	COUNT(customer_id) Number_of_Customers
FROM sale.customer
WHERE state = 'CA' 
GROUP BY city
HAVING COUNT(customer_id) > 5
ORDER BY COUNT(customer_id) DESC;



---- 3. List the top 10 most expensive products ----

SELECT * FROM product.product

SELECT TOP 10 
	product_id,
	product_name, 
	list_price
FROM product.product
ORDER BY list_price DESC;



---- 4. List store_id, product name and list price and the quantity of the products which are located in the store id 2 and the quantity is greater than 25----

SELECT * FROM sale.store

SELECT * FROM product.product

SELECT * FROM sale.order_item

SELECT * FROM sale.orders

SELECT 
	A.store_id, 
	D.product_name, 
	C.list_price, 
	SUM(C.quantity) AS SumQuantity
FROM sale.store A
INNER JOIN sale.orders B ON A.store_id = B.store_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
INNER JOIN product.product D ON C.product_id = D.product_id
WHERE A.store_id = 2
GROUP BY A.store_id, D.product_name, C.list_price
HAVING SUM(C.quantity) > 25
ORDER BY SumQuantity


SELECT 
	A.store_id, 
	D.product_name, 
	C.list_price, 
	SUM(C.quantity) AS SumQuantity
FROM sale.store A
LEFT JOIN sale.orders B ON A.store_id = B.store_id
LEFT JOIN sale.order_item C ON B.order_id = C.order_id
LEFT JOIN product.product D ON C.product_id = D.product_id
WHERE A.store_id = 2
GROUP BY A.store_id, D.product_name, C.list_price
HAVING SUM(C.quantity) > 25
ORDER BY SumQuantity



---- 5. Find the sales order of the customers who lives in Boulder order by order date ----

SELECT * FROM sale.customer

SELECT * FROM sale.orders

SELECT * FROM sale.order_item

SELECT 
	A.first_name + ' ' + A.last_name, 
	A.city,
	B.order_date, 
	B.order_id
FROM sale.customer A
LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
WHERE A.city = 'Boulder' AND B.order_date IS NOT NULL
GROUP BY A.first_name + ' ' + A.last_name, A.city, B.order_date, B.order_id
ORDER BY B.order_date;



---- 6. Get the sales by staffs and years using the AVG() aggregate function.

SELECT * FROM sale.staff

SELECT * FROM sale.orders

SELECT * FROM sale.order_item

SELECT 
	A.first_name + ' ' + A.last_name, 
	YEAR(B.order_date) Year,
	AVG(C.list_price * (1-C.discount) * C.quantity) Avg_Sales
FROM sale.staff A
INNER JOIN sale.orders B ON A.staff_id = B.staff_id
INNER JOIN sale.order_item C ON B.order_id = C.order_id
GROUP BY A.first_name + ' ' + A.last_name, YEAR(B.order_date)
ORDER BY A.first_name + ' ' + A.last_name, YEAR(B.order_date)



---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----

SELECT 
	b.[brand_name], 
	p.product_name, 
	COUNT(o.[quantity]) [Sales Quantitiy of Product]
FROM [product].[brand] b
INNER JOIN [product].[product] p
	ON b.brand_id = p.brand_id
INNER JOIN [sale].[order_item] o
	ON p.product_id = o.product_id
GROUP BY b.brand_name, p.product_name
ORDER BY [Sales Quantitiy of Product] DESC;


SELECT	distinct brand_name, product_name, sum(quantity) sale_qua
FROM	product.product A, sale.order_item B,product.brand C
where A.product_id=B.product_id
and A.brand_id=C.brand_id
group by
		brand_name, product_name
order by
		2 desc



---- 8. What are the categories that each brand has?----

SELECT 
	b.[brand_name], 
	c.[category_name]
FROM [product].[brand] b
INNER JOIN [product].[product] p
	ON b.brand_id = p.brand_id
INNER JOIN [product].[category] c
	ON p.category_id = c.category_id
GROUP BY b.brand_name, c.category_name
ORDER BY b.[brand_name]



SELECT 
	b.[brand_name], 
	COUNT(DISTINCT c.category_id) AS Num_Categories
FROM [product].[brand] b
INNER JOIN [product].[product] p
	ON b.brand_id = p.brand_id
INNER JOIN [product].[category] c
	ON p.category_id = c.category_id
GROUP BY b.brand_name



---- 9. Select the avg prices according to brands and categories----

SELECT 
	b.[brand_name], 
	c.[category_name], 
	AVG(p.[list_price]) AS [Avg Price]
FROM [product].[brand] b
INNER JOIN [product].[product] p
	ON b.brand_id = p.brand_id
INNER JOIN [product].[category] c
	ON p.category_id = c.category_id
GROUP BY b.brand_name, c.category_name
ORDER BY b.brand_name



---- 10. Select the annual amount of product produced according to brands----

SELECT 
	p.[model_year],
	b.[brand_name], 
	COUNT(p.[product_name]) AS Annual_Amount
FROM [product].[brand] b
INNER JOIN [product].[product] p
	ON b.brand_id = p.brand_id
GROUP BY p.[model_year],b.[brand_name]
ORDER BY p.[model_year]



SELECT 
	b.[brand_name],
	p.[model_year],	 
	COUNT(p.[product_name]) AS Annual_Amount
FROM [product].[brand] b
INNER JOIN [product].[product] p
	ON b.brand_id = p.brand_id
GROUP BY b.[brand_name], p.[model_year]
ORDER BY b.[brand_name], p.[model_year]



---- 11. Select the store which has the most sales quantity in 2018.----

SELECT TOP 1 
	s.[store_name], 
	SUM(i.[quantity])
FROM [sale].[store] s
INNER JOIN [sale].[orders] o
	ON s.store_id = o.store_id
INNER JOIN [sale].[order_item] i
	ON o.order_id = i.order_id
WHERE  DATENAME(YEAR, o.[order_date]) = '2018' -- year(o.[order_date])
GROUP BY s.[store_name] 
ORDER BY SUM(i.[quantity]) DESC;



---- 12 Select the store which has the most sales amount in 2018.----

SELECT * FROM [sale].[order_item]

SELECT TOP 1 
	s.[store_name], 
	SUM(i.list_price * (1 - i.discount) * i.quantity) AS sales_amount_2018
FROM [sale].[store] s
INNER JOIN [sale].[orders] o
	ON s.store_id = o.store_id
INNER JOIN [sale].[order_item] i
	ON o.order_id = i.order_id
WHERE  DATENAME(YEAR, o.[order_date]) = '2018' -- year(o.[order_date])
GROUP BY s.[store_name] 
ORDER BY SUM(i.[list_price]) DESC;



---- 13. Select the personnel which has the most sales amount in 2019.----

SELECT TOP 1 
	s.first_name + ' ' + s.last_name,
	SUM(i.list_price * (1 - i.discount) * i.quantity) AS sales_amount_2019
FROM [sale].[staff] s
INNER JOIN [sale].[orders] o
	ON s.store_id = o.store_id
INNER JOIN [sale].[order_item] i
	ON o.order_id = i.order_id
WHERE  DATENAME(YEAR, o.[order_date]) = '2018' -- year(o.[order_date])
GROUP BY s.first_name + ' ' + s.last_name 
ORDER BY SUM(i.[list_price]) DESC;
