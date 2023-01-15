-- 14. Car Rental Database
CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories (
	Id INT IDENTITY PRIMARY KEY, 
	CategoryName VARCHAR(100) NOT NULL, 
	DailyRate INT, 
	WeeklyRate INT, 
	MonthlyRate INT, 
	WeekendRate INT
)

CREATE TABLE Cars (
	Id INT IDENTITY PRIMARY KEY, 
	PlateNumber VARCHAR(100) NOT NULL, 
	Manufacturer VARCHAR(100) NOT NULL, 
	Model VARCHAR(100) NOT NULL, 
	CarYear INT NOT NULL, 
	CategoryId INT FOREIGN KEY REFERENCES Categories (Id) NOT NULL, 
	Doors INT, 
	Picture VARBINARY(MAX), 
	Condition VARCHAR, 
	Available BIT,
)

CREATE TABLE Employees (
	Id INT IDENTITY PRIMARY KEY, 
	FirstName VARCHAR(100) NOT NULL, 
	LastName VARCHAR(100) NOT NULL, 
	Title VARCHAR(100) NOT NULL, 
	Notes VARCHAR(MAX)
)

CREATE TABLE Customers (
	Id INT IDENTITY PRIMARY KEY, 
	DriverLicenceNumber CHAR(10) NOT NULL, 
	FullName VARCHAR(255) NOT NULL, 
	[Address] VARCHAR(255), 
	City VARCHAR(100), 
	ZIPCode INT, 
	Notes VARCHAR(MAX)
)

CREATE TABLE RentalOrders (
	Id INT IDENTITY PRIMARY KEY, 
	EmployeeId INT FOREIGN KEY REFERENCES Employees (Id) NOT NULL, 
	CustomerId INT FOREIGN KEY REFERENCES Customers (Id) NOT NULL, 
	CarId INT FOREIGN KEY REFERENCES Cars (Id) NOT NULL, 
	TankLevel INT, 
	KilometrageStart INT, 
	KilometrageEnd INT, 
	TotalKilometrage INT, 
	StartDate DATE, 
	EndDate DATE, 
	TotalDays INT, 
	RateApplied DECIMAL, 
	TaxRate DECIMAL, 
	OrderStatus BIT, 
	Notes VARCHAR(MAX)
);

INSERT INTO Categories (CategoryName)
VALUES
('Sedan'),
('Coupe'),
('SUV')

INSERT INTO Cars (PlateNumber, Manufacturer, Model, CarYear, CategoryId)
VALUES
('ABC-123', 'BMW', 'M5', 2021, 1),
('XYZ-123', 'Jeep', 'Wrangler', 2005, 3),
('MNO-123', 'Mercedes', 'SLS GT R', 2014, 2)
			
INSERT INTO Employees (FirstName, LastName, Title)
VALUES
('Ivan', 'Petrov', 'Engeneer'),
('Maria', 'Korava', 'Manager'),
('Mongo', 'Vod', 'Consultant')

INSERT INTO Customers (DriverLicenceNumber, FullName)
VALUES
('1234567890', 'Gosho Stoyanov'),
('7834527890', 'Katerina Kusha'),
('5434567780', 'Mongo Tapir')

INSERT INTO RentalOrders (EmployeeId, CustomerId, CarId)
VALUES
(2, 3, 1),
(1, 1, 2),
(3, 2, 3)

SELECT * FROM Categories;
SELECT * FROM Cars;
SELECT * FROM Employees;
SELECT * FROM Customers;
SELECT * FROM RentalOrders;
				