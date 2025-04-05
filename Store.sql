
CREATE DATABASE IF NOT EXISTS stcvdsh;
USE stcvdsh;

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
    VID INT PRIMARY KEY AUTO_INCREMENT,
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
    VID INT PRIMARY KEY,
    PreviousOwner VARCHAR(100),
    FOREIGN KEY (VID) REFERENCES Vehicle(VID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE VehicleImage (
    ImageID INT PRIMARY KEY AUTO_INCREMENT,
    VID INT NOT NULL,
    ImageURL VARCHAR(255) NOT NULL UNIQUE,
    FOREIGN KEY (VID) REFERENCES Vehicle(VID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE TestDrive (
    TestDriveID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    VID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Feedback TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (VID) REFERENCES Vehicle(VID)
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
    VID INT NOT NULL UNIQUE, 
    SalespersonID INT, 
    SaleDate DATE NOT NULL,
    BasePrice DECIMAL(10, 2) CHECK (BasePrice > 0),
    DiscountPrice DECIMAL(10, 2) CHECK (DiscountPrice >= 0),
    FinalPrice DECIMAL(10, 2) CHECK (FinalPrice > 0),
    Status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (VID) REFERENCES Vehicle(VID)
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
    T_VID INT PRIMARY KEY AUTO_INCREMENT,
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
   SalesOptionID INT PRIMARY KEY AUTO_INCREMENT,
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
('123 Main St', 'NSW', '2000'),
('456 Park Ave', 'VIC', '3000'),
('789 Queen St', 'QLD', '4000'),
('101 King Rd', 'WA', '6000'),
('202 Elizabeth Dr', 'SA', '5000'),
('303 George St', 'TAS', '7000'),
('404 Flinders Ln', 'ACT', '2600'),
('505 Collins St', 'VIC', '3000'),
('606 Pitt St', 'NSW', '2000'),
('707 Adelaide St', 'QLD', '4000'),
('808 Murray St', 'WA', '6000'),
('909 North Tce', 'SA', '5000'),
('110 Brisbane St', 'TAS', '7000'),
('211 Canberra Ave', 'ACT', '2600'),
('312 Melbourne Rd', 'VIC', '3000');

INSERT INTO Customer (FirstName, LastName, C_Mobile, C_Email, AddressID, LicenseNumber) VALUES
('John', 'Smith', '0411222333', 'john.smith@email.com', 1, 'DL123456'),
('Sarah', 'Johnson', '0422333444', 'sarah.j@email.com', 2, 'DL234567'),
('Michael', 'Williams', '0433444555', 'michael.w@email.com', 3, 'DL345678'),
('Emma', 'Brown', '0444555666', 'emma.b@email.com', 4, 'DL456789'),
('David', 'Jones', '0455666777', 'david.j@email.com', 5, 'DL567890'),
('Jessica', 'Miller', '0466777888', 'jessica.m@email.com', 6, 'DL678901'),
('Daniel', 'Davis', '0477888999', 'daniel.d@email.com', 7, 'DL789012'),
('Lisa', 'Wilson', '0488999000', 'lisa.w@email.com', 8, 'DL890123'),
('Matthew', 'Taylor', '0499000111', 'matthew.t@email.com', 9, 'DL901234'),
('Jennifer', 'Anderson', '0400111222', 'jennifer.a@email.com', 10, 'DL012345'),
('Robert', 'Thomas', '0411333444', 'robert.t@email.com', 11, 'DL123789'),
('Elizabeth', 'White', '0422444555', 'elizabeth.w@email.com', 12, 'DL234890'),
('Christopher', 'Harris', '0433555666', 'chris.h@email.com', 13, 'DL345901'),
('Ashley', 'Martin', '0444666777', 'ashley.m@email.com', 14, 'DL456012'),
('Andrew', 'Thompson', '0455777888', 'andrew.t@email.com', 15, 'DL567123');

INSERT INTO Vehicle (Make, Model, BuildYear, Odometer, Colour, Transmission, ListedPrice, Description, VehicleType) VALUES
('Toyota', 'Corolla', 2022, 5000, 'White', 'Automatic', 25990.00, 'Nearly new Toyota Corolla with low kilometers', 'Sedan'),
('Honda', 'Civic', 2021, 15000, 'Silver', 'Automatic', 22490.00, 'Popular Honda Civic in excellent condition', 'Sedan'),
('Mazda', 'CX-5', 2020, 35000, 'Blue', 'Automatic', 28990.00, 'Family friendly SUV with plenty of features', 'SUV'),
('Ford', 'Ranger', 2019, 45000, 'Black', 'Manual', 32490.00, 'Rugged ute perfect for work or play', 'Ute'),
('Hyundai', 'i30', 2022, 8000, 'Red', 'Automatic', 24990.00, 'Economic hatchback with modern features', 'Hatchback'),
('Kia', 'Sportage', 2021, 25000, 'Grey', 'Automatic', 29990.00, 'Stylish mid-size SUV with plenty of space', 'SUV'),
('Volkswagen', 'Golf', 2020, 30000, 'Black', 'Automatic', 26490.00, 'German engineering in a compact package', 'Hatchback'),
('Subaru', 'Forester', 2019, 40000, 'Green', 'Automatic', 27990.00, 'Reliable SUV with all-wheel drive', 'SUV'),
('Nissan', 'Navara', 2022, 10000, 'Orange', 'Automatic', 38990.00, 'Powerful ute with towing capacity', 'Ute'),
('Mitsubishi', 'Outlander', 2021, 20000, 'White', 'Automatic', 31490.00, 'Spacious 7-seater family SUV', 'SUV'),
('BMW', '3 Series', 2020, 25000, 'Blue', 'Automatic', 48990.00, 'Luxury sedan with premium features', 'Sedan'),
('Mercedes-Benz', 'C-Class', 2019, 35000, 'Silver', 'Automatic', 45990.00, 'Elegant German luxury vehicle', 'Sedan'),
('Audi', 'Q5', 2022, 12000, 'Black', 'Automatic', 62990.00, 'Premium SUV with cutting-edge technology', 'SUV'),
('Tesla', 'Model 3', 2021, 18000, 'White', 'Automatic', 59990.00, 'Electric vehicle with impressive range', 'Sedan'),
('Lexus', 'NX', 2020, 22000, 'Grey', 'Automatic', 52490.00, 'Refined luxury SUV with hybrid option', 'SUV'),
('Toyota', 'HiLux', 2019, 50000, 'White', 'Manual', 35990.00, 'Durable workhorse with proven reliability', 'Ute'),
('Mazda', 'CX-3', 2022, 7500, 'Red', 'Automatic', 26490.00, 'Compact SUV with sleek design', 'SUV'),
('Honda', 'HR-V', 2021, 14000, 'Black', 'Automatic', 27990.00, 'Versatile small SUV with magic seats', 'SUV'),
('Ford', 'Mustang', 2020, 20000, 'Yellow', 'Automatic', 58990.00, 'Iconic sports car with powerful engine', 'Coupe'),
('Hyundai', 'Tucson', 2019, 42000, 'Silver', 'Automatic', 26990.00, 'Practical mid-size SUV with good value', 'SUV');

INSERT INTO PreOwnedVehicle (VID, PreviousOwner) VALUES
(3, 'Jane Wilson'),
(4, 'Robert Brown'),
(7, 'Marcus Lee'),
(8, 'Patricia Garcia'),
(11, 'Thomas White'),
(12, 'Stephanie Clark'),
(15, 'Kevin Rodriguez'),
(16, 'Laura Martinez'),
(19, 'Richard Wright'),
(20, 'Mary Scott');

INSERT INTO VehicleImage (VID, ImageURL) VALUES
(1, 'https://images.example.com/toyota-corolla-1.jpg'),
(1, 'https://images.example.com/toyota-corolla-2.jpg'),
(2, 'https://images.example.com/honda-civic-1.jpg'),
(2, 'https://images.example.com/honda-civic-2.jpg'),
(3, 'https://images.example.com/mazda-cx5-1.jpg'),
(4, 'https://images.example.com/ford-ranger-1.jpg'),
(5, 'https://images.example.com/hyundai-i30-1.jpg'),
(6, 'https://images.example.com/kia-sportage-1.jpg'),
(7, 'https://images.example.com/vw-golf-1.jpg'),
(8, 'https://images.example.com/subaru-forester-1.jpg'),
(9, 'https://images.example.com/nissan-navara-1.jpg'),
(10, 'https://images.example.com/mitsubishi-outlander-1.jpg'),
(11, 'https://images.example.com/bmw-3series-1.jpg'),
(12, 'https://images.example.com/mercedes-cclass-1.jpg'),
(13, 'https://images.example.com/audi-q5-1.jpg'),
(14, 'https://images.example.com/tesla-model3-1.jpg'),
(15, 'https://images.example.com/lexus-nx-1.jpg'),
(16, 'https://images.example.com/toyota-hilux-1.jpg'),
(17, 'https://images.example.com/mazda-cx3-1.jpg'),
(18, 'https://images.example.com/honda-hrv-1.jpg'),
(19, 'https://images.example.com/ford-mustang-1.jpg'),
(20, 'https://images.example.com/hyundai-tucson-1.jpg');

INSERT INTO Salesperson (FullName, Email, Mobile, GrossSalary, CommissionRate) VALUES
('Alex Turner', 'alex.t@cardealer.com', '0412345678', 65000.00, 2.50),
('Olivia Parker', 'olivia.p@cardealer.com', '0423456789', 68000.00, 3.00),
('William Chen', 'william.c@cardealer.com', '0434567890', 62000.00, 2.75),
('Sophia Kim', 'sophia.k@cardealer.com', '0445678901', 70000.00, 3.25),
('James Wilson', 'james.w@cardealer.com', '0456789012', 65000.00, 2.50),
('Emily Johnson', 'emily.j@cardealer.com', '0467890123', 72000.00, 3.50);

INSERT INTO TestDrive (CustomerID, VID, Date, Time, Feedback) VALUES
(1, 3, '2025-03-10', '10:00:00', 'Smooth ride, but looking for something with better fuel economy'),
(2, 5, '2025-03-11', '11:30:00', 'Love the handling and features. Considering purchase'),
(3, 8, '2025-03-12', '13:00:00', 'Great family vehicle, but concerned about the age'),
(4, 10, '2025-03-13', '14:30:00', 'Perfect size for my needs, liked the 7 seats'),
(5, 13, '2025-03-14', '15:00:00', 'Impressive luxury features but out of my budget'),
(6, 15, '2025-03-15', '10:00:00', 'Nice vehicle but looking for something more fuel efficient'),
(7, 17, '2025-03-16', '11:30:00', 'Good compact SUV, considering this model'),
(8, 19, '2025-03-17', '13:00:00', 'Too powerful for my needs, but fun to drive'),
(9, 2, '2025-03-18', '14:30:00', 'Good value for money, like the features'),
(10, 4, '2025-03-19', '15:00:00', 'Need something for work, this might be suitable'),
(11, 6, '2025-03-20', '10:00:00', 'Good family SUV, considering purchase'),
(12, 9, '2025-03-21', '11:30:00', 'Like the towing capacity, might be good for my business'),
(13, 11, '2025-03-22', '13:00:00', 'Love the luxury feel, thinking about buying'),
(14, 14, '2025-03-23', '14:30:00', 'Interested in electric vehicles, impressed with range'),
(15, 16, '2025-03-24', '15:00:00', 'Need a reliable ute for work, this seems sturdy');

INSERT INTO Sales (CustomerID, VID, SalespersonID, SaleDate, BasePrice, DiscountPrice, FinalPrice, Status) VALUES
(1, 1, 1, '2025-03-15', 25990.00, 1000.00, 24990.00, 'Completed'),
(2, 2, 2, '2025-03-16', 22490.00, 500.00, 21990.00, 'Completed'),
(3, 7, 3, '2025-03-17', 26490.00, 1500.00, 24990.00, 'Completed'),
(4, 9, 4, '2025-03-18', 38990.00, 2000.00, 36990.00, 'Completed'),
(5, 11, 5, '2025-03-19', 48990.00, 3000.00, 45990.00, 'Completed'),
(6, 14, 6, '2025-03-20', 59990.00, 4000.00, 55990.00, 'Completed'),
(7, 16, 1, '2025-03-21', 35990.00, 1500.00, 34490.00, 'Completed'),
(8, 18, 2, '2025-03-22', 27990.00, 1000.00, 26990.00, 'Completed'),
(9, 20, 3, '2025-03-23', 26990.00, 1500.00, 25490.00, 'Completed'),
(10, 3, 4, '2025-03-24', 28990.00, 1000.00, 27990.00, 'Pending'),
(11, 5, 5, '2025-03-25', 24990.00, 500.00, 24490.00, 'Pending'),
(12, 12, 6, '2025-03-26', 45990.00, 2000.00, 43990.00, 'Processing');

INSERT INTO Payment (SaleID, Amount, Date, PaymentMethod) VALUES
(1, 24990.00, '2025-03-15', 'Card'),
(2, 21990.00, '2025-03-16', 'Finance'),
(3, 24990.00, '2025-03-17', 'Cash'),
(4, 36990.00, '2025-03-18', 'Finance'),
(5, 45990.00, '2025-03-19', 'Finance'),
(6, 55990.00, '2025-03-20', 'Card'),
(7, 34490.00, '2025-03-21', 'Finance'),
(8, 26990.00, '2025-03-22', 'Cash'),
(9, 25490.00, '2025-03-23', 'Card');

INSERT INTO BankingFinance (PaymentID, BankName, ApplyDate, LoanTerms, InterestRate, LoanAmount, Remark) VALUES
(2, 'Commonwealth Bank', '2025-03-16', 36, 4.99, 21990.00, 'Approved on the spot'),
(4, 'ANZ Bank', '2025-03-18', 48, 5.25, 36990.00, 'Fast approval process'),
(5, 'Westpac', '2025-03-19', 48, 4.75, 45990.00, 'Premium customer rate'),
(7, 'NAB', '2025-03-21', 36, 5.50, 34490.00, 'Standard approval');

INSERT INTO TradeIn (SaleID, T_Make, T_Model, T_Year, T_Odometer, T_Colour, T_Transmission, T_MechCon, T_BodyCon) VALUES
(1, 'Toyota', 'Camry', 2015, 120000, 'White', 'Automatic', 'Good', 'Fair'),
(3, 'Volkswagen', 'Polo', 2014, 100000, 'Blue', 'Manual', 'Fair', 'Good'),
(5, 'Mazda', '6', 2016, 95000, 'Red', 'Automatic', 'Good', 'Good'),
(6, 'Hyundai', 'Sonata', 2015, 110000, 'Silver', 'Automatic', 'Fair', 'Fair'),
(8, 'Toyota', 'Yaris', 2013, 130000, 'Grey', 'Automatic', 'Fair', 'Poor');

INSERT INTO AftermarketOption (Name, Description) VALUES
('Window Tinting', 'Premium window tinting for UV protection and privacy'),
('Extended Warranty', '3-year extended warranty coverage for peace of mind'),
('Paint Protection', 'Ceramic coating for long-lasting paint protection'),
('Floor Mats', 'All-weather rubber floor mats for protection'),
('Roof Rack', 'Sturdy roof rack system for additional cargo'),
('Dash Camera', 'High-definition front and rear dash cameras'),
('Seat Covers', 'Premium leather seat covers for comfort and protection'),
('Sound System Upgrade', 'Enhanced audio system with subwoofer');

INSERT INTO SalesOption (OptionID, SaleID, Cost) VALUES
(1, 1, 450.00),
(2, 1, 1200.00),
(3, 2, 850.00),
(4, 3, 250.00),
(5, 4, 650.00),
(6, 5, 550.00),
(7, 6, 950.00),
(8, 7, 1500.00),
(2, 8, 1200.00),
(3, 9, 850.00);

INSERT INTO CashPayment (PaymentID, Amount) VALUES
(3, 24990.00),
(8, 26990.00);