-- section 1 of final exam
-- brooklyn dressel

-- question 1
-- select statement that returns account_number, account_description, 
--   and invoice_id
-- returns account_number less than or equal to 200
-- returns each account_number that has never been used
SELECT gla.account_number, gla.account_description, ili.invoice_id
FROM general_ledger_accounts gla 
	LEFT JOIN invoice_line_items ili
		ON gla.account_number = ili.account_number
WHERE gla.account_number <= 200
	AND ili.invoice_id IS NULL;



-- question 2
-- select invoice_id, invoice_sequence, line_item_amount
-- returns for each w/ more than one line item
-- uses subquerey
SELECT invoice_id, invoice_sequence, line_item_amount
FROM invoice_line_items
WHERE invoice_id IN (
	SELECT invoice_id
	FROM invoice_line_items
    GROUP BY invoice_id
    HAVING COUNT(DISTINCT invoice_sequence) > 1 );