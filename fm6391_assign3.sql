CREATE TABLE Drivers (
    Driver_ID INT PRIMARY KEY,
    First_name VARCHAR(50) NOT NULL,
    Last_name VARCHAR(50) NOT NULL,
    Address VARCHAR(255),
    Hours_worked INT,
    Joining_date_time DATETIME,
    Date_of_birth DATE,
    Rating DECIMAL(2, 1) DEFAULT 5
);

CREATE TABLE Users (
    User_ID INT PRIMARY KEY,
    First_name VARCHAR(50) NOT NULL,
    Last_name VARCHAR(50),
    Contact_number VARCHAR(20),
    Address VARCHAR(255),
    Last_login DATETIME,
    Email_address VARCHAR(100)
);

CREATE TABLE Rides (
    Ride_ID INT PRIMARY KEY,
    User_ID INT,
    Driver_ID INT,
    Start_date_time DATETIME,
    End_date_time DATETIME,
    Distance_travelled DECIMAL(5, 2),
    Stars INT,
    Status ENUM('INITIATED', 'ACCEPTED', 'IN TRANSIT', 'COMPLETED'),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Driver_ID) REFERENCES Drivers(Driver_ID)
);

CREATE TABLE Payments (
    Payment_ID INT PRIMARY KEY,
    Ride_ID INT,
    Amount DECIMAL(8, 2),
    Payment_date_time DATETIME,
    Tip DECIMAL(5, 2),
    Paid_by ENUM('CASH', 'CARD', 'CHEQUE'),
    Card_number VARCHAR(20),
    Cardholder_name VARCHAR(50),
    Card_expiry_date DATE,
    Cheque_number VARCHAR(20),
    Bank_name VARCHAR(50),
    Account_holder VARCHAR(50),
    FOREIGN KEY (Ride_ID) REFERENCES Rides(Ride_ID)
);