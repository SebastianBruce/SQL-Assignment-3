-- SQL Assignment 3
-- Sebastian, Yoko, Jason, Allison
-- 03-22-2024

-- Q1
-- Write an INSERT statement that adds this row to the Categories table:
-- category_name: Brass
-- Code the INSERT statement so MySQL automatically generates the category_id column.
INSERT INTO categories (category_name)
VALUES('Brass');

-- Q2
-- Write an UPDATE statement that modifies the row you just added to the Categories table. This 
-- statement should change the product_name column to “Woodwinds”, and it should use the 
-- category_id column to identify the row.
UPDATE categories
SET category_name = 'Woodwinds'
WHERE category_id = 5;

-- Q3
-- Write a DELETE statement that deletes the row you added to the Categories table in exercise 1. This 
-- statement should use the category_id column to identify the row.
DELETE FROM categories
WHERE category_id = 5;

-- Q4
-- Write an INSERT statement that adds this row to the Products table:
-- product_id: The next automatically generated ID 
-- category_id: 4
-- product_code: dgx_640
-- product_name: Yamaha DGX 640 88-Key Digital Piano
-- description: Long description to come.
-- list_price: 799.99
-- discount_percent: 0
-- date_added: Today’s date/time.
-- Use a column list for this statement.
INSERT INTO products (product_id, category_id, product_code, product_name, description, list_price, 
discount_percent, date_added)
VALUES (DEFAULT, 4, 'dgx_640', 'Yamaha DGX 640 88-Key Digital Piano', 'Long description to 
come.', 799.99, 0, NOW());

-- Q5
-- Write an UPDATE statement that modifies the product you added in exercise 4. This statement 
-- should change the discount_percent column from 0% to 35%.
UPDATE products
SET discount_percent = 35
WHERE product_id = 11;

-- Q6
-- Write a DELETE statement that deletes the Keyboards category. When you execute this statement, it 
-- will produce an error since the category has related rows in the Products table. To fix that, precede the
-- DELETE statement with another DELETE statement that deletes all products in this category. 
-- (Remember that to code two or more statements in a script, you must end each statement with a 
-- semicolon.)
DELETE FROM products
WHERE category_id =
(SELECT category_id
FROM categories
WHERE category_name = 'Keyboards');
DELETE FROM categories
WHERE category_name = 'Keyboards';

-- Q7
-- Write an INSERT statement that adds this row to the Customers table:
-- email_address: rick@raven.com
-- password: (empty string)
-- first_name: Rick
-- last_name: Raven
-- Use a column list for this statement.
INSERT INTO customers
(email_address, password, first_name, last_name)
VALUES
('rick@raven.com', '', 'Rick', 'Raven');

-- Q8
-- Write an UPDATE statement that modifies the Customers table. Change the password column to 
-- “secret” for the customer with an email address of rick@raven.com.
UPDATE customers
SET password = 'secret'
WHERE email_address = 'rick@raven.com';

-- Q9
-- Write an UPDATE statement that modifies the Customers table. Change the password column to 
-- “reset” for every customer in the table. If you get an error due to safe-update mode, you can add a 
-- LIMIT clause to update the first 100 rows of the table. (This should update all rows in the table.)
UPDATE customers
SET password = 'reset';

-- Q10
-- Open the script named create_my_guitar_shop.sql that’s in the mgs_ex_starts directory. Then, run 
-- this script. That should restore the data that’s in the database.
/*
 There is no SQL query to execute for Q10. Executed my_guitar_shop.sql
*/

-- Q11
-- Write a SELECT statement that returns these columns:
-- The count of the number of orders in the Orders table
-- The sum of the tax_amount columns in the Orders table
SELECT
COUNT(*) AS number_of_orders,
SUM(tax_amount) AS total_tax_amount
FROM orders;

-- Q12
-- Write a SELECT statement that returns one row for each category that has products with these 
-- columns:
-- The category_name column from the Categories table
-- The count of the products in the Products table
-- The list price of the most expensive product in the Products table
-- Sort the result set so the category with the most products appears first.
SELECT
c.category_name, 
COUNT(p.product_id) AS count_of_products, 
MAX(p.list_price) AS most_expensive_product
FROM categories AS c
LEFT JOIN products AS p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY count_of_products DESC;

-- Q13
-- Write a SELECT statement that returns one row for each customer that has orders with these 
-- columns:
-- The email_address column from the Customers table
-- The sum of the item price in the Order_Items table multiplied by the quantity in the 
-- Order_Items table
-- The sum of the discount amount column in the Order_Items table multiplied by the 
-- quantity in the Order_Items table
-- Sort the result set in descending sequence by the item price total for each customer
SELECT
c.email_address,
SUM(oi.item_price * oi.quantity) AS total_item_price,
SUM(oi.discount_amount * oi.quantity) AS total_discount_amount
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_item_price DESC;

-- Q14
-- Write a SELECT statement that returns one row for each customer that has orders with these 
-- columns:
-- The email_address column from the Customers table
-- A count of the number of orders
-- The total amount for each order (Hint: First, subtract the discount amount from the price.
-- Then, multiply by the quantity.)
-- Return only those rows where the customer has more than 1 order.
-- Sort the result set in descending sequence by the sum of the line item amounts.
SELECT
c.email_address, 
COUNT(DISTINCT oi.order_id) AS count_of_orders, 
SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_amount
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
HAVING count_of_orders > 1
ORDER BY total_amount DESC;

-- Q15
-- Modify the solution to exercise 4 so it only counts and totals line items that have an item_price value 
-- that’s greater than 400.
SELECT
c.email_address,
COUNT(DISTINCT oi.order_id) AS count_of_orders,
SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_amount 
FROM customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON o.order_id = oi.order_id
WHERE oi.item_price > 400 
GROUP BY c.customer_id
HAVING count_of_orders > 1
ORDER BY total_amount DESC;

-- Q16
-- Write a SELECT statement that answers this question: What is the total amount ordered for each 
-- product? Return these columns:
-- The product_name column from the Products table
-- The total amount for each product in the Order_Items table (Hint: You can calculate the 
-- total amount by subtracting the discount amount from the item price and then multiplying
-- it by the quantity)
-- Use the WITH ROLLUP operator to include a row that gives the grand total.
SELECT p.product_name as product, SUM((item_price - discount_amount) * quantity) AS sold
FROM products p LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY product WITH ROLLUP;

-- Q17
-- Write a SELECT statement that answers this question: Which customers have ordered more than one 
-- product? Return these columns:
-- The email_address column from the Customers table
-- The count of distinct products from the customer’s orders
-- Sort the result set in ascending sequence by the email_address column.
SELECT
c.email_address,
COUNT(DISTINCT oi.product_id) AS count_of_products
FROM
customers AS c
INNER JOIN orders AS o ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
HAVING count_of_products > 1
ORDER BY c.email_address ASC;

-- Q18
-- Write a SELECT statement that answers this question: What is the total quantity purchased for each 
-- product within each category? Return these columns:
-- The category_name column from the category table
-- The product_name column from the products table
-- The total quantity purchased for each product with orders in the Order_Items table
-- Use the WITH ROLLUP operator to include rows that give a summary for each category name as 
-- well as a row that gives the grand total.
-- Use the IF and GROUPING functions to replace null values in the category_name and product_name 
-- columns with literal values if they’re for summary rows. 
SELECT
IF(GROUPING(c.category_name) = 1, 'ALL', c.category_name) AS category_name,
IF(GROUPING(p.product_name) = 1, 'TOTAL', p.product_name) AS product_name,
SUM(oi.quantity) AS total_purchased_quantity
FROM
categories AS c
INNER JOIN products AS p ON c.category_id = p.category_id
INNER JOIN order_items AS oi ON p.product_id = oi.product_id
GROUP BY c.category_name, p.product_name WITH ROLLUP;