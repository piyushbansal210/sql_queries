-- =====================================================
-- ST CAR DEALERSHIP DATABASE STRUCTURE & SAMPLE QUERIES
-- =====================================================

-- CREATED BY: Piyush Bansal
-- DATE: 05/04/2025
-- DESCRIPTION:
-- This SQL script creates a normalized relational database for a car dealership.
-- It includes realistic data and demonstrates common SQL tasks like joins, views,
-- and aggregations for analysis purposes.

-- =====================================================
-- DATABASE INITIALIZATION
-- =====================================================

CREATE DATABASE IF NOT EXISTS ST;
USE ST;

-- ========================================
-- DROP TABLES IN REVERSE ORDER OF CREATION
-- ========================================

DROP TABLE IF EXISTS SalesOption;
DROP TABLE IF EXISTS AftermarketOption;
DROP TABLE IF EXISTS BankingFinance;
DROP TABLE IF EXISTS CashPayment;
DROP TABLE IF EXISTS TradeIn;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS TestDrive;
DROP TABLE IF EXISTS VehicleImage;
DROP TABLE IF EXISTS PreOwnedVehicle;
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS Salesperson;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Address;


-- ======================
-- CREATE TABLES
-- ======================

CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    Street VARCHAR(255) NOT NULL,
    State VARCHAR(100) NOT NULL,
    Postcode VARCHAR(10) NOT NULL
);



CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    C_Mobile VARCHAR(15) UNIQUE NOT NULL,
    C_Email VARCHAR(100) UNIQUE NOT NULL,
    AddressID INT NOT NULL,
    LicenseNumber VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Vehicle (
    VIN INT PRIMARY KEY AUTO_INCREMENT,
    Make VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    BuildYear INT CHECK (BuildYear > 1885 AND BuildYear <= 2025),
    Odometer INT CHECK (Odometer >= 0),
    Colour VARCHAR(50),
    Transmission VARCHAR(50),
    ListedPrice DECIMAL(10, 2) CHECK (ListedPrice > 0),
    Description TEXT,
    VehicleType VARCHAR(50) NOT NULL
);

CREATE TABLE PreOwnedVehicle (
    VIN INT PRIMARY KEY,
    Purchase_Date DATE NOT NULL,
    M_Warranty INT NOT NULL,
    InsuranceHistory VARCHAR(50) NOT NULL,
    ServiceHistory varchar(50) NOT NULL,
    PreviousOwner VARCHAR(100),
    FOREIGN KEY (VIN) REFERENCES Vehicle(VIN)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE VehicleImage (
    ImageID INT PRIMARY KEY AUTO_INCREMENT,
    VIN INT NOT NULL,
    ImageURL VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (VIN) REFERENCES Vehicle(VIN)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE TestDrive (
    TestDriveID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    VIN INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Feedback TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (VIN) REFERENCES Vehicle(VIN)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Salesperson (
    SalespersonID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Mobile VARCHAR(15) UNIQUE NOT NULL,
    GrossSalary DECIMAL(10, 2) CHECK (GrossSalary > 0),
    CommissionRate DECIMAL(5, 2) CHECK (CommissionRate > 0 AND CommissionRate < 10)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    VIN INT NOT NULL UNIQUE, 
    SalespersonID INT, 
    SaleDate DATE NOT NULL,
    BasePrice DECIMAL(10, 2) CHECK (BasePrice > 0),
    DiscountPrice DECIMAL(10, 2) CHECK (DiscountPrice >= 0),
    FinalPrice DECIMAL(10, 2) CHECK (FinalPrice > 0),
    Status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (VIN) REFERENCES Vehicle(VIN)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (SalespersonID) REFERENCES Salesperson(SalespersonID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    SaleID INT NOT NULL UNIQUE,
    Amount DECIMAL(10, 2) CHECK (Amount > 0),
    Date DATE NOT NULL,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE CashPayment (
    PaymentID INT PRIMARY KEY,
    Amount DECIMAL(10, 2) CHECK (Amount > 0),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE BankingFinance (
    FinanceID INT PRIMARY KEY AUTO_INCREMENT,
    PaymentID INT UNIQUE NOT NULL,
    BankName VARCHAR(100),
    ApplyDate DATE NOT NULL,
    LoanTerms INT CHECK (LoanTerms BETWEEN 12 AND 50),
	InterestRate DECIMAL(5, 2) CHECK (InterestRate > 0 AND InterestRate <= 20),
    LoanAmount DECIMAL(10, 2),
    Remark VARCHAR(255) DEFAULT 'No Remarks',
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE TradeIn (
    T_VIN INT PRIMARY KEY AUTO_INCREMENT,
    SaleID INT UNIQUE,
    T_Make VARCHAR(50),
    T_Model VARCHAR(50),
    T_Year INT CHECK (T_Year > 1885 AND T_Year <= 2025),
    T_Odometer INT CHECK (T_Odometer >= 0),
    T_Colour VARCHAR(50),
    T_Transmission VARCHAR(50),
    T_MechCon ENUM('Poor', 'Fair', 'Good', 'Excellent') DEFAULT 'Good',
    T_BodyCon ENUM('Poor', 'Fair', 'Good', 'Excellent') DEFAULT 'Good',
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

CREATE TABLE AftermarketOption (
   OptionID INT PRIMARY KEY AUTO_INCREMENT,
   Name VARCHAR(100) UNIQUE NOT NULL,
   Description TEXT NOT NULL
);

CREATE TABLE SalesOption (
   OptionID INT NOT NULL,
   SaleID INT NOT NULL,
   Cost DECIMAL(10, 2) CHECK (Cost > 0),
   FOREIGN KEY (OptionID) REFERENCES AftermarketOption(OptionID)
       ON DELETE CASCADE
       ON UPDATE CASCADE,
   FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
       ON DELETE CASCADE
       ON UPDATE CASCADE
);




INSERT INTO Address (Street, State, Postcode) VALUES
('123 King St', 'NSW', '2000'),
('456 Queen St', 'VIC', '3000'),
('789 George St', 'NSW', '2001'),
('321 Collins St', 'VIC', '3001'),
('100 Pitt St', 'QLD', '4000'),
('12 York St', 'NSW', '2002'),
('88 River Rd', 'QLD', '4001'),
('50 Swanston St', 'VIC', '3002'),
('22 Smith St', 'SA', '5000'),
('9 Harbour Rd', 'WA', '6000');


INSERT INTO Customer (FirstName, LastName, C_Mobile, C_Email, AddressID, LicenseNumber) VALUES
('Aiden', 'Morris', '0412345678', 'aiden.morris@gmail.com', 1, 'NSW456'),
('Chloe', 'Reynolds', '0423456789', 'chloe.reynolds@hotmail.com', 2, 'VIC987'),
('Liam', 'Nguyen', '0434567890', 'liam.nguyen@gmail.com', 3, 'NSW321'),
('Zara', 'Ahmed', '0445678901', 'zara.ahmed@outlook.com', 4, 'VIC741'),
('Benjamin', 'Patel', '0456789012', 'ben.patel@gmail.com', 5, 'QLD963'),
('Isla', 'Thompson', '0467890123', 'isla.t@icloud.com', 6, 'NSW852'),
('Jack', 'O’Connor', '0478901234', 'jack.oconnor@yahoo.com', 7, 'QLD357'),
('Harper', 'Singh', '0489012345', 'harper.singh@gmail.com', 8, 'VIC159'),
('Elijah', 'Wong', '0490123456', 'elijah.wong@live.com', 9, 'SA258T'),
('Ava', 'Taylor', '0401234567', 'ava.taylor@gmail.com', 10, 'WA1472');


INSERT INTO Vehicle (Make, Model, BuildYear, Odometer, Colour, Transmission, ListedPrice, Description, VehicleType) VALUES
('Toyota', 'Corolla', 2020, 25000, 'White', 'Automatic', 23000.00, 'Reliable and fuel efficient.', 'Sedan'),
('Ford', 'Ranger', 2018, 75000, 'Black', 'Manual', 29000.00, 'Perfect for off-road and work.', 'Ute'),
('Mazda', 'CX-5', 2021, 18000, 'Blue', 'Automatic', 31000.00, 'Stylish SUV with modern features.', 'SUV'),
('Hyundai', 'i30', 2019, 42000, 'Red', 'Automatic', 21000.00, 'Compact and budget-friendly.', 'Hatchback'),
('Honda', 'Civic', 2022, 5000, 'Grey', 'Manual', 28000.00, 'Sporty and efficient.', 'Sedan'),
('Nissan', 'X-Trail', 2020, 32000, 'Silver', 'Automatic', 27000.00, 'Mid-size family SUV.', 'SUV'),
('Volkswagen', 'Golf', 2017, 66000, 'White', 'Manual', 19000.00, 'Classic compact car.', 'Hatchback'),
('Kia', 'Sportage', 2022, 12000, 'Black', 'Automatic', 33000.00, 'Stylish and practical.', 'SUV'),
('Subaru', 'Outback', 2021, 24000, 'Green', 'Automatic', 35000.00, 'All-terrain capable.', 'Wagon'),
('Mitsubishi', 'Lancer', 2016, 85000, 'Blue', 'Manual', 17000.00, 'Affordable performance.', 'Sedan');


INSERT INTO PreOwnedVehicle (VIN, Purchase_Date, M_Warranty, InsuranceHistory, ServiceHistory, PreviousOwner) VALUES
(1, '2022-05-15', 24, 'Yes', 'Full', 'Chris Jordan'),
(2, '2021-11-20', 12, 'No', 'None', 'Sam Lee'),
(3, '2023-03-10', 36, 'Yes', 'Full', 'Amy Clarke'),
(4, '2020-10-05', 18, 'Yes', 'Partial', 'Tom Hardy'),
(5, '2023-06-22', 24, 'No', 'Full', 'Rachel Adams'),
(6, '2021-09-01', 12, 'Yes', 'None', 'Derek King'),
(7, '2020-12-11', 24, 'No', 'Partial', 'Nina Brock'),
(8, '2022-08-25', 36, 'Yes', 'Full', 'Mike Ross'),
(9, '2021-03-03', 18, 'No', 'Full', 'Sarah Paul'),
(10, '2019-07-18', 12, 'Yes', 'None', 'Raj Kapoor');

INSERT INTO VehicleImage (VIN, ImageURL) VALUES
(1, 'https://media.drive.com.au/obj/tx_q:70,rs:auto:960:540:1/driveau/upload/vehicles/used/toyota/corolla/2020/11074c09-8c56-5624-924c-abc199950000'),
(2, 'https://carsguide-res.cloudinary.com/image/upload/f_auto,fl_lossy,q_auto,t_default/v1/editorial/segment_review/hero_image/2018-Ford-Ranger-XLS-4x4-auto-ute-grey-marcus-craft-1200x800-(1).jpg'),
(3, 'https://autotraderau-res.cloudinary.com/t_cg_listing_grid_c/inventory/2025-04-02/16568693553471/14205744/2021_mazda_cx_5_Used_1.jpg'),
(4, 'https://images.carexpert.com.au/resize/700/-/vehicles/source-g/0/0/002fc835.jpg'),
(5, 'https://editorial.pxcrush.net/carsales/general/editorial/honda-civic-e_hev-lx-22.jpg?width=1024&height=682'),
(6, 'https://carsales.pxcrush.net/carsales/cars/dealer/bqgqezzqi8gg92ecanlko34bw.jpg?pxc_method=fitfill&pxc_bgtype=self&pxc_size=720,480'),
(7, 'https://autotraderau-res.cloudinary.com/t_listing_grid_c/inventory/2025-03-26/42255679492471/14243635/2017_volkswagen_golf_Used_1.jpg'),
(8, 'https://images.carexpert.com.au/resize/3000/-/app/uploads/2022/01/2022-Kia-Sportage-S-2.0D-AWD-15.jpg'),
(9, 'https://carsguide-res.cloudinary.com/image/upload/c_fit,h_810,w_1215,f_auto,t_cg_base/v1/editorial/2021-Subaru-Outback-sport-wagon-grey-1200x800-(3).jpg'),
(10, 'https://carsales.pxcrush.net/carsales/cars/private/6ixa904xa40b0sy591aad52st.jpg?pxc_method=fitfill&pxc_bgtype=self&pxc_size=720,480');

INSERT INTO Salesperson (FullName, Email, Mobile, GrossSalary, CommissionRate) VALUES
('Alice Green', 'alice@dealership.com', '0411000001', 60000.00, 4.5),
('Bob White', 'bob@dealership.com', '0411000002', 58000.00, 5.0),
('Charlie Black', 'charlie@dealership.com', '0411000003', 62000.00, 4.8),
('Diana Grey', 'diana@dealership.com', '0411000004', 59000.00, 4.2),
('Edward Young', 'edward@dealership.com', '0411000005', 64000.00, 4.9),
('Fiona Wood', 'fiona@dealership.com', '0411000006', 60500.00, 4.6),
('George Hill', 'george@dealership.com', '0411000007', 63000.00, 4.7),
('Hannah Scott', 'hannah@dealership.com', '0411000008', 61500.00, 4.4),
('Isaac Stone', 'isaac@dealership.com', '0411000009', 59900.00, 5.0),
('Jasmine Reed', 'jasmine@dealership.com', '0411000010', 62500.00, 4.3);


INSERT INTO TestDrive (CustomerID, VIN, Date, Time, Feedback) VALUES
(1, 1, '2024-01-05', '10:00:00', 'Smooth and quiet ride.'),
(2, 2, '2024-02-10', '14:30:00', 'Powerful and tough.'),
(3, 3, '2024-03-15', '11:15:00', 'Very comfortable SUV.'),
(4, 4, '2024-03-20', '15:00:00', 'Good city car.'),
(5, 5, '2024-04-01', '09:45:00', 'Sporty feel and good controls.'),
(6, 6, '2024-04-03', '10:30:00', 'Nice drive overall.'),
(7, 7, '2024-04-04', '11:00:00', 'A little worn out.'),
(8, 8, '2024-04-05', '13:15:00', 'Luxury SUV feel.'),
(9, 9, '2024-04-06', '14:00:00', 'Loved the interior.'),
(10, 10, '2024-04-07', '15:30:00', 'Surprisingly powerful.');

INSERT INTO Sales (CustomerID, VIN, SalespersonID, SaleDate, BasePrice, DiscountPrice, FinalPrice, Status) VALUES
(1, 1, 1, '2024-01-10', 23000.00, 1000.00, 22000.00, 'Completed'),
(2, 2, 2, '2024-02-15', 29000.00, 1500.00, 27500.00, 'Completed'),
(3, 3, 3, '2024-03-18', 31000.00, 2000.00, 29000.00, 'Completed'),
(4, 4, 4, '2024-04-01', 21000.00, 500.00, 20500.00, 'Pending'),
(5, 5, 5, '2024-04-05', 28000.00, 0.00, 28000.00, 'Completed'),
(6, 6, 6, '2024-04-07', 27000.00, 1000.00, 26000.00, 'Pending'),
(7, 7, 7, '2024-04-10', 19000.00, 500.00, 18500.00, 'Completed'),
(8, 8, 8, '2024-04-12', 33000.00, 3000.00, 30000.00, 'Completed'),
(9, 9, 9, '2024-04-15', 35000.00, 2500.00, 32500.00, 'Completed'),
(10, 10, 10, '2024-04-18', 17000.00, 1000.00, 16000.00, 'Pending');

INSERT INTO Payment (SaleID, Amount, Date, PaymentMethod) VALUES
(1, 22000.00, '2024-01-12', 'Banking'),
(2, 27500.00, '2024-02-18', 'Cash'),
(3, 29000.00, '2024-03-20', 'Banking'),
(4, 20500.00, '2024-04-02', 'Banking'),
(5, 28000.00, '2024-04-06', 'Cash'),
(6, 26000.00, '2024-04-08', 'Banking'),
(7, 18500.00, '2024-04-11', 'Cash'),
(8, 30000.00, '2024-04-13', 'Banking'),
(9, 32500.00, '2024-04-16', 'Cash'),
(10, 16000.00, '2024-04-19', 'Banking');

INSERT INTO BankingFinance (PaymentID, BankName, ApplyDate, LoanTerms, InterestRate, LoanAmount) VALUES
(1, 'Westpac', '2024-01-08', 36, 4.5, 22000.00),
(3, 'Commonwealth', '2024-03-10', 48, 3.9, 29000.00),
(4, 'ANZ', '2024-04-01', 24, 5.2, 20500.00),
(6, 'NAB', '2024-04-07', 36, 4.7, 26000.00),
(8, 'BOQ', '2024-04-12', 50, 4.2, 30000.00);

INSERT INTO TradeIn (SaleID, T_Make, T_Model, T_Year, T_Odometer, T_Colour, T_Transmission) VALUES
(1, 'Suzuki', 'Swift', 2015, 85000, 'Silver', 'Automatic'),
(2, 'Nissan', 'X-Trail', 2014, 95000, 'White', 'Manual'),
(3, 'Ford', 'Fiesta', 2013, 105000, 'Red', 'Automatic'),
(4, 'Mazda', '2', 2016, 72000, 'Grey', 'Manual'),
(5, 'Toyota', 'Yaris', 2015, 88000, 'Black', 'Automatic'),
(6, 'Kia', 'Rio', 2017, 64000, 'Blue', 'Manual'),
(7, 'Hyundai', 'Accent', 2018, 55000, 'White', 'Automatic'),
(8, 'Holden', 'Commodore', 2012, 120000, 'Green', 'Manual'),
(9, 'Volkswagen', 'Polo', 2019, 40000, 'Red', 'Automatic'),
(10, 'Honda', 'Jazz', 2016, 70000, 'Silver', 'Manual');

INSERT INTO AftermarketOption (Name, Description) VALUES
('Window Tint', 'All window dark tinting'),
('Tow Bar', 'Tow bar installation'),
('Roof Racks', 'Roof storage racks'),
('Dash Cam', 'HD front and rear dash camera'),
('Seat Covers', 'Custom waterproof seat covers'),
('GPS Tracker', 'Real-time vehicle tracking'),
('Premium Sound', 'Upgraded sound system'),
('Floor Mats', 'Heavy-duty rubber mats'),
('Paint Protection', 'Scratch-resistant coating'),
('Reverse Camera', 'Rear view parking camera');

INSERT INTO SalesOption (OptionID, SaleID, Cost) VALUES
(1, 1, 350.00),
(2, 2, 500.00),
(3, 3, 450.00),
(4, 4, 300.00),
(5, 5, 200.00),
(6, 6, 250.00),
(7, 7, 400.00),
(8, 8, 100.00),
(9, 9, 375.00),
(10, 10, 225.00);

INSERT INTO CashPayment (PaymentID, Amount) VALUES
(2, 27500.00),
(5, 28000.00),
(7, 18500.00),
(9, 32500.00),
(10, 16000.00);

-- ========================================
-- SOME QUERUIES
-- ========================================

-- QUESTION: LIST ALL VEHICLE SALES WITH CUSTOMER NAME, VEHICLE MODEL, AND SALESPERSON DETAILS
SELECT 
    s.SaleID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    v.Make,
    v.Model,
    s.SaleDate,
    s.FinalPrice,
    sp.FullName AS Salesperson
FROM Sales s
JOIN Customer c ON s.CustomerID = c.CustomerID
JOIN Vehicle v ON s.VIN = v.VIN
LEFT JOIN Salesperson sp ON s.SalespersonID = sp.SalespersonID;


-- QUESTION: CALCULATE TOTAL SALES AND TOTAL REVENUE GENERATED BY EACH SALESPERSON
SELECT 
    sp.FullName AS Salesperson,
    COUNT(s.SaleID) AS TotalSales,
    SUM(s.FinalPrice) AS TotalRevenue
FROM Sales s
JOIN Salesperson sp ON s.SalespersonID = sp.SalespersonID
GROUP BY sp.FullName
ORDER BY TotalRevenue DESC;


-- QUESTION: SHOW ALL SALES THAT INCLUDED AFTERMARKET OPTIONS AND THEIR COST
SELECT 
    s.SaleID,
    a.Name AS OptionName,
    so.Cost,
    s.FinalPrice
FROM SalesOption so
JOIN AftermarketOption a ON so.OptionID = a.OptionID
JOIN Sales s ON so.SaleID = s.SaleID;


-- QUESTION: CREATE A VIEW OF VEHICLE SALES FROM THE LAST 6 MONTHS INCLUDING VEHICLE INFO
CREATE VIEW RecentSalesView AS
SELECT 
    s.SaleID,
    s.SaleDate,
    v.Make,
    v.Model,
    v.BuildYear,
    s.FinalPrice
FROM Sales s
JOIN Vehicle v ON s.VIN = v.VIN
WHERE s.SaleDate > DATE_SUB(CURDATE(), INTERVAL 6 MONTH);


-- QUESTION: LIST ALL VEHICLES THAT HAVE NOT BEEN SOLD YET
SELECT 
    v.VIN,
    v.Make,
    v.Model,
    v.ListedPrice
FROM Vehicle v
WHERE v.VIN NOT IN (SELECT VIN FROM Sales);


-- QUESTION: FIND THE AVERAGE FINAL SALE PRICE FOR EACH VEHICLE TYPE
SELECT 
    v.VehicleType,
    ROUND(AVG(s.FinalPrice), 2) AS AveragePrice
FROM Sales s
JOIN Vehicle v ON s.VIN = v.VIN
GROUP BY v.VehicleType;


-- QUESTION: DISPLAY LOAN DETAILS AND ESTIMATED INTEREST FOR FINANCED VEHICLES
SELECT 
    bf.BankName,
    p.Date AS PaymentDate,
    bf.LoanAmount,
    bf.InterestRate,
    ROUND(bf.LoanAmount * bf.InterestRate / 100, 2) AS EstimatedInterest
FROM BankingFinance bf
JOIN Payment p ON bf.PaymentID = p.PaymentID;



