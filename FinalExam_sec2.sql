-- section 2 of final
-- brooklyn dressel

-- question 3
-- stored procedure with error handling
-- deletes row w/ invoice_id = 12 from invoices table
--   first deletes all line items for that invoice from
--   invoice_line_items table
DROP PROCEDURE IF EXISTS fm6391_question3;
DELIMITER //
CREATE PROCEDURE fm6391_question3 ()
BEGIN
	-- message for debugging
	DECLARE message VARCHAR(255);
    -- exception handlers
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;

START TRANSACTION;
DELETE FROM invoice_line_items
WHERE invoice_id = 12;

DELETE FROM invoices
WHERE invoice_id = 12;

-- commit or rollback
IF sql_error = TRUE THEN
    SET message = 'Rollback executed due to SQL error';
    SELECT message;
ELSE
    SET message = 'Commit successful';
    SELECT message;
END IF;

END //
DELIMITER ;
CALL fm6391_question3();


-- question 4
-- stored procedure with error handling
-- creates cursor for result set with
	-- vendor_id, vendor_name, invoice_number, balance_due
    -- returns invoices w/ balance due >= 0
DROP PROCEDURE IF EXISTS fm6391_question4;
DELIMITER //
CREATE PROCEDURE fm6391_question4 ()
BEGIN
	-- message for debugging
	DECLARE message VARCHAR(255);
    
    -- cursor vars
    DECLARE no_records INT DEFAULT FALSE;
    DECLARE final_str VARCHAR(10000) DEFAULT "";
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);
    DECLARE i_num VARCHAR(50);
    DECLARE i_tot DECIMAL(9,2);
    DECLARE pay_tot DECIMAL(9,2);
    -- declare cursor
    DECLARE vendor_cursor CURSOR 
		FOR SELECT v.vendor_id, v.vendor_name, i.invoice_number, 
			i.invoice_total, i.payment_total
        FROM invoices i JOIN vendors v
			ON i.vendor_id = v.vendor_id;
    
    -- exception handlers
    DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET no_records = TRUE;

OPEN vendor_cursor;
WHILE no_records = FALSE DO
	FETCH vendor_cursor INTO v_id, v_name, i_num,
		i_tot, pay_tot;
	SET final_str = CONCAT(final_str, v_id, '|', v_name, '|',
			i_num, '|', i_tot - pay_tot, '// ');
END WHILE;
CLOSE vendor_cursor;

-- output
SELECT final_str;

END //
DELIMITER ;
CALL fm6391_question4();
