--------------------------------N18_warmups
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
	unit_price * quantity * (1-od.discount) as product_price
FROM 
	customer_info,
	product_info
		)
SELECT 
	customer_id,
	country,
	RANK () OVER (PARTITION BY product_price ORDER BY country DESC)
FROM price_product

-- Return the same list as before, but with only the top 3 customers in each country.

--ADD
SELECT *
FROM top_customers
WHERE rank <= 3

--------------------------------N19_warmups
-- Get a list of the 3 long-standing customers for each country

WITH long_customers as (
	SELECT 
	customer_id,
	order_date,
	ship_country,
	RANK () OVER (PARTITION BY ship_country ORDER BY order_date)
FROM orders
ORDER BY ship_country, order_date
	)

SELECT
	DISTINCT (customer_id), --I tried to fix the duplicate customer but did not work. I have to calculate the age like you.
	order_date,
	ship_country,
	rank
FROM long_customers
WHERE rank <= 3
ORDER BY ship_country

northwind-# limit 10;
 customer_id | order_date | ship_country | rank
-------------+------------+--------------+------
 RANCH       | 1997-02-17 | Argentina    |    2
 OCEAN       | 1997-01-09 | Argentina    |    1
 CACTU       | 1997-04-29 | Argentina    |    3
 ERNSH       | 1996-11-11 | Austria      |    3
 ERNSH       | 1996-07-23 | Austria      |    2
 ERNSH       | 1996-07-17 | Austria      |    1
 SUPRD       | 1996-09-10 | Belgium      |    2
 SUPRD       | 1996-07-09 | Belgium      |    1
 SUPRD       | 1997-02-26 | Belgium      |    3
 WELLI       | 1996-07-15 | Brazil       |    3
(10 rows)


-- Modify the previous query to get the 3 newest customers in each each country.

WITH long_customers as (
	SELECT 
	customer_id,
	order_date,
	ship_country,
	RANK () OVER (PARTITION BY ship_country ORDER BY order_date DESC)
FROM orders
ORDER BY ship_country
	)

SELECT *
FROM long_customers
WHERE rank <= 3;

 customer_id | order_date | ship_country | rank
-------------+------------+--------------+------
 CACTU       | 1998-04-28 | Argentina    |    1
 RANCH       | 1998-04-13 | Argentina    |    2
 OCEAN       | 1998-03-30 | Argentina    |    3
 ERNSH       | 1998-05-05 | Austria      |    1
 PICCO       | 1998-04-27 | Austria      |    2
 ERNSH       | 1998-04-13 | Austria      |    3
 SUPRD       | 1998-04-21 | Belgium      |    1
 SUPRD       | 1998-04-20 | Belgium      |    2
 MAISD       | 1998-04-07 | Belgium      |    3
 QUEEN       | 1998-05-04 | Brazil       |    1
 RICAR       | 1998-04-29 | Brazil       |    2
 HANAR       | 1998-04-27 | Brazil       |    3
 BOTTM       | 1998-04-24 | Canada       |    1
 BOTTM       | 1998-04-23 | Canada       |    2
 
-- Get the 3 most frequently ordered products in each city
-- FOR SIMPLICITY, we're interpreting "most frequent" as 
-- "highest number of total units ordered within a country"
-- hint: do something with the quanity column

WITH order_quantity as (
	SELECT 
	product_id,
	quantity
FROM order_details
	),
order_city as (
	SELECT 
	order_id,
	ship_city
FROM orders
	),
rank_by_city as (
	SELECT 
	order_id,
	product_id,
	ship_city,
	quantity,
	RANK () OVER (PARTITION BY ship_city ORDER BY quantity DESC)
FROM order_quantity, order_city
	)

SELECT *
FROM rank_by_city
WHERE rank <= 3;

 order_id | product_id |    ship_city    | quantity | rank
----------+------------+-----------------+----------+------
    11036 |         64 | Aachen          |      130 |    1
    11036 |         39 | Aachen          |      130 |    1
    10797 |         64 | Aachen          |      130 |    1
    10797 |         39 | Aachen          |      130 |    1
    10825 |         39 | Aachen          |      130 |    1
    10825 |         64 | Aachen          |      130 |    1
    11067 |         39 | Aachen          |      130 |    1
    11067 |         64 | Aachen          |      130 |    1
    10363 |         39 | Aachen          |      130 |    1
    10363 |         64 | Aachen          |      130 |    1
    10391 |         64 | Aachen          |      130 |    1
    10391 |         39 | Aachen          |      130 |    1
    10401 |         64 | Albuquerque     |      130 |    1
    10401 |         39 | Albuquerque     |      130 |    1
    10272 |         64 | Albuquerque     |      130 |    1
    10272 |         39 | Albuquerque     |      130 |    1
    10316 |         64 | Albuquerque     |      130 |    1
    10316 |         39 | Albuquerque     |      130 |    1
    10564 |         64 | Albuquerque     |      130 |    1
    10564 |         39 | Albuquerque     |      130 |    1
    10346 |         64 | Albuquerque     |      130 |    1