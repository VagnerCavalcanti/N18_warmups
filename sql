-- Return to Window Functions!
-- BASIC SYNTAX
-- SELECT <aggregator> OVER(PARTITION BY <col1> ORDER BY <col2>)
-- PARTITION BY (like GROUP BY) a column to do the aggregation within particular category in <col1>
-- Choose what order to apply the aggregator over (if it's a type of RANK)
-- Example SELECT SUM(sales) OVER(PARTITION BY department)
-- Feel free to google RANK examples too.



-- Return a list of all customers, RANKED in order from highest to lowest total spendings
-- WITHIN the country they live in.
-- HINT: find a way to join the order_details, products, and customers tables


-- Return the same list as before, but with only the top 3 customers in each country.

WITH customer_info as (
	SELECT 
	customer_id,
	country
from customers
		),
product_info as (
	SELECT
	order_id,
	product_id,
	unit_price,
	quantity,
	discount
FROM order_details
		),
price_product as (
	SELECT 
	customer_id,
	country,
	order_id,
	product_id,
	unit_price * quantity as product_price
FROM 
	customer_info,
	product_info
		)
SELECT 
	customer_id,
	country,
	RANK () OVER (PARTITION BY product_price ORDER BY country DESC)
FROM price_product



