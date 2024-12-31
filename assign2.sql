-- 1. returns one row for each category
SELECT category_name, 
	COUNT(book_id) AS books_count,  -- totals books
	MAX(mrp) AS most_expensive_good  -- finds the most expensive book
FROM books_categories bc JOIN books_inventory bi
	ON bc.category_id = bi.category_id  -- join so can have category_name and book_id
GROUP BY category_name
ORDER BY books_count DESC;  -- sort by no. books in each category (most to least)

-- 2. returns one row for each reader that has orders
SELECT email_address, 
	SUM(item_price * quantity) AS item_price_total,  -- calculates the price for multiple same items
	SUM(discount_amount * quantity) AS discount_amount_total  -- calculates total discount
FROM readers r 
	JOIN readers_orders ro  -- join readers_orders to be able to match with 
		ON r.reader_id = ro.reader_id
    JOIN readers_order_items roi  -- readers_orders_items
		ON ro.order_id = roi.order_id
GROUP BY email_address
ORDER BY item_price_total ASC;

-- 3. returns one row for each reader that has orders
SELECT email_address, 
	COUNT(DISTINCT roi.order_id) AS order_count,  -- totals orders of each customer
    SUM((item_price - discount_amount) * quantity) AS order_total  
		-- calculates order total for each customer
FROM readers r
	JOIN readers_orders ro  -- join readers_orders to be able to match with 
		ON r.reader_id = ro.reader_id
    JOIN readers_order_items roi  -- readers_orders_items
		ON ro.order_id = roi.order_id                                      
GROUP BY email_address
HAVING COUNT(DISTINCT roi.order_id) > 1  -- only shows customers with more than one order
ORDER BY order_total DESC;

-- 4. modify above so only counts/totals line items w/item_price val > 400
SELECT email_address, 
	COUNT(DISTINCT roi.order_id) AS order_count,  -- totals orders of each customer
    SUM((item_price - discount_amount) * quantity) AS order_total  
		-- calculates order total for each customer
FROM readers r
	JOIN readers_orders ro  -- join readers_orders to be able to match with 
		ON r.reader_id = ro.reader_id
    JOIN readers_order_items roi  -- readers_orders_items
		ON ro.order_id = roi.order_id
WHERE item_price > 400
GROUP BY email_address
HAVING COUNT(DISTINCT roi.order_id) > 1  -- only shows customers with more than one order
ORDER BY order_total DESC;

-- 5. what is the total amount ordered for each book?
SELECT title, 
	SUM((item_price - discount_amount) * quantity) AS book_total -- sums total for each book sold
FROM books_inventory bi JOIN readers_order_items roi
	ON bi.book_id = roi.book_id
GROUP BY title WITH ROLLUP; -- totals all totals

-- 6. which readers have ordered more than one book?
SELECT email_address,
	COUNT(DISTINCT book_id) AS number_of_books -- totals different books bought
FROM readers r
	JOIN readers_orders ro  -- join readers_orders to be able to match with 
		ON r.reader_id = ro.reader_id
    JOIN readers_order_items roi  -- readers_orders_items
		ON ro.order_id = roi.order_id
GROUP BY email_address
HAVING COUNT(DISTINCT book_id) > 1  -- only show if bought more than 1 book
ORDER BY email_address ASC;

-- 7. what is the toal quantity purchased for each book wit/in each category?
SELECT IF (GROUPING(category_name) = 1, 'Grand Total', category_name) 
		AS category_name,  -- if category name column is null --> put 'Grand Total'
	IF (GROUPING(title) = 1, 'Category Total', title) 
		AS book_name,  -- if book name column is null --> put 'Category Total'
	SUM(quantity) AS qty_purchased  -- totals number of books bought
FROM books_categories bc
	JOIN books_inventory bi
		ON bc.category_id = bi.category_id
	JOIN readers_order_items roi
		ON bi.book_id = roi.book_id
GROUP BY category_name, title WITH ROLLUP;  -- totals categories

-- 8. uses aggregate window function to get total amt of each order
SELECT order_id,
	SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY item_id) 
		AS item_amount,  -- totals order total for each item in order
    SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY order_id) 
		AS order_amount  -- total of whole order
FROM readers_order_items
ORDER BY order_id ASC;

-- 9. modify above so column that contains total amt for each order contains a 
	-- cummulative total by item amount
SELECT order_id,
	SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY item_id) 
		AS item_amount,  -- totals order total for each item in order
    SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY order_id) 
		AS order_amount,  -- total of whole order
    AVG((item_price - discount_amount) * quantity) OVER(PARTITION BY order_id) 
		AS avg_order_amount -- averages item_amount
FROM readers_order_items
ORDER BY order_id, item_amount ASC;

-- 10. uses aggregate window functions to calculate the order total for each
	-- reader and the order total for each reader by date
SELECT r.reader_id, ro.order_date, 
	SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY roi.item_id) 
		AS item_total,  -- total for each order item
	SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY r.reader_id) 
		AS readers_total,  -- sum of order totals
	SUM((item_price - discount_amount) * quantity) OVER(PARTITION BY r.reader_id) 
		AS readers_total_by_date  -- sum of order totals by date
FROM readers r
	JOIN readers_orders ro  -- join readers_orders to be able to match with 
		ON r.reader_id = ro.reader_id
    JOIN readers_order_items roi  -- readers_orders_items
		ON ro.order_id = roi.order_id    
ORDER BY r.reader_id ASC;
