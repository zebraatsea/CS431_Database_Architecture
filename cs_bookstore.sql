/********************************************************
* This script creates the database named cs_bookstore 
*********************************************************/

DROP DATABASE IF EXISTS cs_bookstore;
CREATE DATABASE cs_bookstore;
USE cs_bookstore;

-- create the tables for the database
CREATE TABLE books_categories (
  category_id        INT            PRIMARY KEY   AUTO_INCREMENT,
  category_name      VARCHAR(255)   NOT NULL      UNIQUE
);

CREATE TABLE books_inventory (
  book_id       INT            PRIMARY KEY   AUTO_INCREMENT,
  category_id        INT            NOT NULL,
  isbn_code       VARCHAR(40)    NOT NULL      UNIQUE,
  title       VARCHAR(255)   NOT NULL,
  book_description        TEXT           NOT NULL,
  mrp        DECIMAL(10,2)  NOT NULL,
  discount_percent   DECIMAL(10,2)  NOT NULL      DEFAULT 0.00,
  date_added         DATETIME                     DEFAULT NULL,
  CONSTRAINT inventory_fk_categories
    FOREIGN KEY (category_id)
    REFERENCES books_categories (category_id)
);

CREATE TABLE readers (
  reader_id           INT            PRIMARY KEY   AUTO_INCREMENT,
  email_address         VARCHAR(255)   NOT NULL      UNIQUE,
  password              VARCHAR(60)    NOT NULL,
  first_name            VARCHAR(60)    NOT NULL,
  last_name             VARCHAR(60)    NOT NULL,
  shipping_address_id   INT                          DEFAULT NULL,
  billing_address_id    INT                          DEFAULT NULL
);

CREATE TABLE readers_addresses (
  address_id         INT            PRIMARY KEY   AUTO_INCREMENT,
  reader_id         INT            NOT NULL,
  line1              VARCHAR(60)    NOT NULL,
  line2              VARCHAR(60)                  DEFAULT NULL,
  city               VARCHAR(40)    NOT NULL,
  state              VARCHAR(2)     NOT NULL,
  zip_code           VARCHAR(10)    NOT NULL,
  phone              VARCHAR(12)    NOT NULL,
  disabled           INT     NOT NULL      DEFAULT 0,
  CONSTRAINT addresses_fk_readers
    FOREIGN KEY (reader_id)
    REFERENCES readers (reader_id)
);

CREATE TABLE readers_orders (
  order_id           INT            PRIMARY KEY  AUTO_INCREMENT,
  reader_id         INT            NOT NULL,
  order_date         DATETIME       NOT NULL,
  ship_amount        DECIMAL(10,2)  NOT NULL,
  tax_amount         DECIMAL(10,2)  NOT NULL,
  ship_date          DATETIME                    DEFAULT NULL,
  ship_address_id    INT            NOT NULL,
  card_type          VARCHAR(50)    NOT NULL,
  card_number        CHAR(16)       NOT NULL,
  card_expires       CHAR(7)        NOT NULL,
  billing_address_id  INT           NOT NULL,
  CONSTRAINT orders_fk_readers
    FOREIGN KEY (reader_id)
    REFERENCES readers (reader_id)
);

CREATE TABLE readers_order_items (
  item_id            INT            PRIMARY KEY  AUTO_INCREMENT,
  order_id           INT            NOT NULL,
  book_id   INT            NOT NULL,
  item_price         DECIMAL(10,2)  NOT NULL,
  discount_amount    DECIMAL(10,2)  NOT NULL,
  quantity           INT            NOT NULL,
  CONSTRAINT order_items_fk_orders
    FOREIGN KEY (order_id)
    REFERENCES readers_orders (order_id), 
  CONSTRAINT order_items_fk_goods
    FOREIGN KEY (book_id)
    REFERENCES books_inventory (book_id)
);

CREATE TABLE administrators (
  admin_id           INT            PRIMARY KEY   AUTO_INCREMENT,
  email_address      VARCHAR(255)   NOT NULL,
  password           VARCHAR(255)   NOT NULL,
  first_name         VARCHAR(255)   NOT NULL,
  last_name          VARCHAR(255)   NOT NULL
);

-- Insert data into the tables
INSERT INTO books_categories (category_id, category_name) VALUES
(1, 'Programming'),
(2, 'Architecture'),
(3, 'MachineLearning'), 
(4, 'Robotics');

INSERT INTO books_inventory VALUES
(1, 1, 5460002701,'Python', 'Basics of Python', '699.00', '30.00', '2017-10-30 09:32:40'),
(2, 1, 9150007202,'Java Script', 'JS for Dummies', '1199.00', '30.00', '2017-12-05 16:33:13'),
(3, 1, 72590002403, 'C++ Advanced', 'Advanced programming Topics in C++', '2517.00', '50.00', '2018-02-04 11:04:31'),
(4, 2, 72590001365,'Computer Architecture', 'Database Management System Architecture', '39.99', '8.00', '2018-06-01 11:12:59'),
(5, 2, 43190005605,'Database Architecture','Quantitative Approach to Architecture', '50.00', '0.00', '2018-07-30 13:58:35'),
(6, 2, 81590001202,'Computer Organization', 'Computer Organization with design',  '199.00', '39.00', '2018-07-30 14:12:41'),
(7, 3, 68390006501,'Machine Learning Basics','Mathematics for Machine Learning',  '179.99', '30.00', '2018-06-01 11:29:35'),
(8, 3, 74590000704,'ML for Dummies','The Hundred-Page Machine Learning Book',  '104.99', '15.00', '2018-07-30 14:18:33'),
(9, 4, 52590007130,'Robotics Programming','Learn Robotics Programming',  '34.99', '10.00', '2018-07-30 12:46:40'),
(10, 4,12590001503, 'Robotics for Dummies','Robotics for Beginners',  '34.99', '5.00', '2018-07-30 13:14:15');

INSERT INTO readers  VALUES
(1, 'allan.sherwood@yahoo.com', '650215acec746f0e32bdfff387439eefc1358737', 'Allan', 'Sherwood', 1, 2),
(2, 'barryz@gmail.com', '3f563468d42a448cb1e56924529f6e7bbe529cc7', 'Barry', 'Zimmer', 3, 3),
(3, 'christineb@solarone.com', 'ed19f5c0833094026a2f1e9e6f08a35d26037066', 'Christine', 'Brown', 4, 4),
(4, 'david.goldstein@hotmail.com', 'b444ac06613fc8d63795be9ad0beaf55011936ac', 'David', 'Goldstein', 5, 6),
(5, 'erinv@gmail.com', '109f4b3c50d7b0df729d299bc6f8e9ef9066971f', 'Erin', 'Valentino', 7, 7),
(6, 'frankwilson@sbcglobal.net', '3ebfa301dc59196f18593c45e519287a23297589', 'Frank Lee', 'Wilson', 8, 8),
(7, 'gary_hernandez@yahoo.com', '1ff2b3704aede04eecb51e50ca698efd50a1379b', 'Gary', 'Hernandez', 9, 10),
(8, 'heatheresway@mac.com', '911ddc3b8f9a13b5499b6bc4638a2b4f3f68bf23', 'Heather', 'Esway', 11, 12);

INSERT INTO readers_addresses  VALUES
(1, 1, '100 East Ridgewood Ave.', '', 'Paramus', 'NJ', '07652', '201-653-4472', 0),
(2, 1, '21 Rosewood Rd.', '', 'Woodcliff Lake', 'NJ', '07677', '201-653-4472', 0),
(3, 2, '16285 Wendell St.', '', 'Omaha', 'NE', '68135', '402-896-2576', 0),
(4, 3, '19270 NW Cornell Rd.', '', 'Beaverton', 'OR', '97006', '503-654-1291', 0),
(5, 4, '186 Vermont St.', 'Apt. 2', 'San Francisco', 'CA', '94110', '415-292-6651', 0),
(6, 4, '1374 46th Ave.', '', 'San Francisco', 'CA', '94129', '415-292-6651', 0),
(7, 5, '6982 Palm Ave.', '', 'Fresno', 'CA', '93711', '559-431-2398', 0),
(8, 6, '23 Mountain View St.', '', 'Denver', 'CO', '80208', '303-912-3852', 0),
(9, 7, '7361 N. 41st St.', 'Apt. B', 'New York', 'NY', '10012', '212-335-2093', 0),
(10, 7, '3829 Broadway Ave.', 'Suite 2', 'New York', 'NY', '10012', '212-239-1208', 0),
(11, 8, '2381 Buena Vista St.', '', 'Los Angeles', 'CA', '90023', '213-772-5033', 0),
(12, 8, '291 W. Hollywood Blvd.', '', 'Los Angeles', 'CA', '90024', '213-391-2938', 0);

INSERT INTO readers_orders VALUES
(1, 1, '2018-03-28 09:40:28', '1199.00', '30.00', '2018-03-30 15:32:51', 1, 'Visa', '4111111111111111', '04/2020', 2),
(2, 2, '2018-03-28 11:23:20', '39.99', '8.00', '2018-03-29 12:52:14', 3, 'Visa', '4012888888881881', '08/2019', 3),
(3, 1, '2018-03-29 09:44:58', '2517.00', '50.00', '2018-03-31 9:11:41', 1, 'Visa', '4111111111111111', '04/2017', 2),
(4, 3, '2018-03-30 15:22:31', '199.00', '30.00', '2018-04-03 16:32:21', 4, 'American Express', '378282246310005', '04/2016', 4),
(5, 4, '2018-03-31 05:43:11', '2398.00', '0.00', '2018-04-02 14:21:12', 5, 'Visa', '4111111111111111', '04/2019', 6),
(6, 5, '2018-03-31 18:37:22', '50.00', '0.00', NULL, 7, 'Discover', '6011111111111117', '04/2019', 7),
(7, 6, '2018-04-01 23:11:12', '902.00', '70.00', '2018-04-03 10:21:35', 8, 'MasterCard', '5555555555554444', '04/2019', 8),
(8, 7, '2018-04-02 11:26:38', '24.99', '5.00', NULL, 9, 'Visa', '4012888888881881', '04/2019', 10),
(9, 4, '2018-04-03 12:22:31', '699.00', '30.00', NULL, 5, 'Visa', '4111111111111111', '04/2019', 6);

INSERT INTO readers_order_items VALUES
(1, 1, 2, '1199.00', '30.00', 1),
(2, 2, 4, '39.99', '8.00', 1),
(3, 3, 3, '2517.00', '50.00', 1),
(4, 3, 6, '199.00', '30.00', 1),
(5, 4, 2, '1199.00', '30.00', 2),
(6, 5, 5, '50.00', '0.00', 1),
(7, 6, 5, '50.00', '0.00', 1),
(8, 7, 1, '699.00', '30.00', 1),
(9, 7, 7, '179.00', '30.00', 1),
(10, 7, 9, '34.00', '10.00', 1),
(11, 8, 10,'24.99', '5.00', 1),
(12, 9, 1, '699.00', '30.00', 1);

INSERT INTO administrators (admin_id, email_address, password, first_name, last_name) VALUES
(1, 'admin@music_store.com', '6a718fbd768c2378b511f8249b54897f940e9022', 'Admin', 'User'),
(2, 'joel@music_store.com', '971e95957d3b74d70d79c20c94e9cd91b85f7aae', 'Indira', 'Yellapragada'),
(3, 'mike@music_store.com', '3f2975c819cefc686282456aeae3a137bf896ee8', 'Joel', 'Murach');

-- drop user if it already exists
DROP USER IF EXISTS managers@localhost;

-- Create a user named manager
CREATE USER managers@localhost 
IDENTIFIED BY 'pa55word';

-- Grant privileges to that user
GRANT SELECT, INSERT, UPDATE, DELETE
ON mgr.*
TO managers@localhost;