-- 15 Hotel Database

CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees (
	Id INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	Title VARCHAR(255) NOT NULL,
	Notes VARCHAR(MAX)
)

CREATE TABLE Customers (
	AccountNumber INT IDENTITY PRIMARY KEY,
	FirstName VARCHAR(255) NOT NULL,
	LastName VARCHAR(255) NOT NULL,
	PhoneNumber VARCHAR(255) NOT NULL,
	EmergencyName VARCHAR(255),
	EmergencyNumber VARCHAR(255),
	Notes VARCHAR(255)
)

CREATE TABLE RoomStatus (
	RoomStatus BIT,
	Notes VARCHAR(MAX)
)

CREATE TABLE RoomTypes (
	RoomType VARCHAR(6),
	Notes VARCHAR(MAX),
	CONSTRAINT CHK_RoomTypes_RoomType CHECK (RoomType IN ('small', 'medium', 'large')),
)

CREATE TABLE BedTypes (
	BedType VARCHAR(6),
	Notes VARCHAR(MAX),
	CONSTRAINT CHK_BedTypes_BedType CHECK (BedType IN ('small', 'medium','large'))
)

CREATE TABLE Rooms (
	RoomNumber INT IDENTITY PRIMARY KEY,
	RoomType VARCHAR(6) NOT NULL,
	BedType VARCHAR(6) NOT NULL, 
	Rate INT, 
	RoomStatus BIT NOT NULL, 
	Notes VARCHAR(MAX),
	CONSTRAINT CHK_Rooms_RoomType CHECK (RoomType IN ('small', 'medium', 'large')),
	CONSTRAINT CHK_Rooms_BedType CHECK (BedType IN ('small', 'medium','large'))
)

CREATE TABLE Payments (
	Id INT IDENTITY PRIMARY KEY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL,
	PaymentDate DATE NOT NULL, 
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL, 
	FirstDateOccupied DATE NOT NULL,
	LastDateOccupied DATE NOT NULL, 
	TotalDays AS DATEDIFF(DAY, FirstDateOccupied, LastDateOccupied), 
	AmountCharged INT NOT NULL, 
	TaxRate DECIMAL(5, 2) DEFAULT 0.10, 
	TaxAmount AS AmountCharged * TaxRate, 
	PaymentTotal AS AmountCharged * (1 + TaxRate), 
	Notes VARCHAR(MAX),
	CONSTRAINT CHK_PaymentDate CHECK (PaymentDate <= FirstDateOccupied)
)

CREATE TABLE Occupancies (
	Id INT IDENTITY PRIMARY KEY,
	EmployeeId INT FOREIGN KEY REFERENCES Employees(Id) NOT NULL, 
	DateOccupied DATE NOT NULL, 
	AccountNumber INT FOREIGN KEY REFERENCES Customers(AccountNumber) NOT NULL, 
	RoomNumber INT FOREIGN KEY REFERENCES Rooms(RoomNumber) NOT NULL, 
	RateApplied INT, 
	PhoneCharge INT, 
	Notes VARCHAR(MAX)
)

INSERT INTO Employees
VALUES
('Ivan', 'Petrov', 'Consultant', 'Good worker'),
('Petar', 'Vasilev', 'Manager', NULL),
('Maria', 'Tosheva', 'Consultant', 'Good girl')

INSERT INTO Customers
VALUES
('Klient', 'Edno', '+(359)888 123 456', NULL, NULL, NULL),
('Klient', 'Dve', '+(359)888 125 456', NULL, NULL, NULL),
('Klient', 'Tri', '+(359)888 127 456', NULL, NULL, NULL)

INSERT INTO RoomStatus 
VALUES
(1, 'Room is available'),
(0, 'Room is not available'),
(1, 'Room is available')

INSERT INTO RoomTypes
VALUES
('small', NULL),
('medium', NULL),
('large', NULL)

INSERT INTO BedTypes
VALUES
('small', NULL),
('medium', NULL),
('large', NULL)

INSERT INTO Rooms
VALUES
('medium', 'large', 7, 3, NULL),
('small', 'medium', 6, 5, NULL),
('small', 'small', 2, 4, NULL)

INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, AmountCharged, Notes)
VALUES
(1, '2021.12.23', 1, '2021.12.28', '2022.01.07', 760, 'Very nice room'),
(2, '2022.12.12', 2, '2022.12.28', '2023.01.02', 540, 'Very nice room'),
(3, '2022.12.27', 3, '2023.01.13', '2023.01.20', 400, 'Very nice room')


INSERT INTO Occupancies
VALUES
(1, '2021.12.28', 1, 1, 7, NULL, NULL),
(2, '2022.12.28', 2, 2, 7, NULL, NULL),
(3, '2023.01.13', 3, 3, 7, NULL, NULL)

DELETE FROM Occupancies
SELECT * FROM Occupancies
