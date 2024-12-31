-- insert reader id 8
INSERT INTO readers
VALUES ('8', 'b_dressel@horizon.edu', '0123456789abcde', 'Brooklyn', 'Dressel', '12', '12');
INSERT INTO readers_addresses
VALUES ('12', '8', '123 1st St', NULL , 'Hayward', 'CA', '94544', '012-345-6789', '0');

-- 1. stored preddure called test, two SQL statemends coded as 
--    a transaction to delete the row w/ reader_id = 8

DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	-- set up error handlers
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;

	START TRANSACTION;
    
    -- delete addresses
    DELETE FROM readers_addresses
    WHERE reader_id = 8;
    
    -- remove readers row
    DELETE FROM readers
    WHERE reader_id = 8;
    
    -- error handling
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END //
DELIMITER ;

CALL test();


-- 2. calls a stored procedure, test, and inserts new row into 
--    readers_orders

DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test
(
	OUT order_id INT
)
BEGIN
	-- set up error handlers
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;

	START TRANSACTION;
    
    -- start provided code
    INSERT INTO readers_orders
	VALUES (DEFAULT, 3, NOW(), '10.00', '0.00', NULL, 4,
		'American Express', '378282246310005', '04/2016', 4);
        
	SELECT LAST_INSERT_ID() INTO order_id;
	INSERT INTO readers_order_items 
    VALUES
		(DEFAULT, order_id, 6, '415.00', '161.85', 1);
	INSERT INTO readers_order_items 
	VALUES
		(DEFAULT, order_id, 1, '699.00', '209.70', 1);
	-- end provided code

    -- error handling
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END //
DELIMITER ;

CALL test(@order_id_param);


-- 3. stored procedure, test, transaction that combines two readers.  
--    locks row w/ reader_id = 6, update reader_orders to combine w/reader_id=3.
--    reader_addresses table assigns selected to reader_id=3
--    deletes selected reader from readers table.


--  replace row w/ reader_id=6
INSERT INTO readers
VALUES ('6', 'frankwilson@sbcglobal.net', '3ebfa301dc59196f18593c45e519287a23297589', 'Frank Lee', 'Wilson', '8', '8');
INSERT INTO readers_orders
VALUES (DEFAULT, '6', '2018-04-01 23:11:12', '902.00', '70.00', '2018-04-03 10:21:35', '8', 'MasterCard', '5555555555554444', '04/2019', '8');
INSERT INTO readers_addresses
VALUES (DEFAULT, '6', '23 Mountain View St.', '', 'Denver', 'CO', '80208', '303-912-3852', '0');

-- reset row w/reader_id=3
INSERT INTO readers
VALUES ('3', 'christineb@solarone.com', 'ed19f5c0833094026a2f1e9e6f08a35d26037066', 'Christine', 'Brown', '4', '4');
INSERT INTO readers_orders
VALUES (DEFAULT, '3', '2024-12-06 12:26:12', '10.00', '0.00', NULL, '4', 'American Express', '378282246310005', '04/2016', '4');
INSERT INTO readers_addresses
VALUES (DEFAULT, '3', '19270 NW Cornell Rd.', '', 'Beaverton', 'OR', '97006', '503-654-1291', '0');



DROP PROCEDURE IF EXISTS test;
DELIMITER //

CREATE PROCEDURE test()
BEGIN
	-- set up error handlers
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;

	START TRANSACTION;
    
    -- lock row for reader_id=6
    SELECT * FROM readers WHERE reader_id = 6 FOR UPDATE NOWAIT;
    
    -- set input's readers orders to 3
    UPDATE readers_orders
    SET reader_id = 3
    WHERE reader_id = 6;
    
    -- set input's addresses to 3
    UPDATE readers_addresses 
    SET reader_id = 3
    WHERE reader_id = 6;
    
    -- delete row w/reader_id = selected row
    DELETE FROM readers
    WHERE reader_id = 6;
    
    -- error handling
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END //
DELIMITER ;
CALL test();
SELECT * FROM readers;
SELECT * FROM readers_orders;
SELECT * FROM readers_addresses;

