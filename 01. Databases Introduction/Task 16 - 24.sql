-- 16
CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns(
	Id INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Towns PRIMARY KEY (Id)
);


CREATE TABLE Addresses (
	Id INT IDENTITY, 
	AddressText VARCHAR(255) NOT NULL, 
	TownId INT FOREIGN KEY REFERENCES Towns(Id),
	CONSTRAINT PK_Addresses PRIMARY KEY (Id)
)


CREATE TABLE Departments (
	Id INT IDENTITY, 
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Departments PRIMARY KEY (Id)
)

CREATE TABLE Employees (
	Id INT IDENTITY, 
	FirstName VARCHAR(255) NOT NULL, 
	MiddleName VARCHAR(255) NOT NULL, 
	LastName VARCHAR(255) NOT NULL, 
	JobTitle VARCHAR(255) NOT NULL, 
	DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL, 
	HireDate DATE NOT NULL, 
	Salary INT NOT NULL, 
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
	CONSTRAINT PK_Employees PRIMARY KEY (Id),
	CONSTRAINT CHK_Employees_HireDate CHECK (HireDate <= GETDATE())
)

-- 18
INSERT INTO Towns ([Name])
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO Departments ([Name])
VALUES
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO Addresses (AddressText, TownId)
VALUES
('Studentski grad bl 23', 1),
('Lazur bl 14', 4),
('Vazrajdane bl 3', 3),
('Kuchuk Parij bl 13', 2);

INSERT INTO Employees (FirstName, MiddleName, LastName, JobTitle, DepartmentId, HireDate, Salary, AddressId)
VALUES 
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013.02.01', 3500.00, 1),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004.03.02', 4000.00, 3),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016.08.28', 525.25, 2),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007.12.09', 3000.00, 4),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016.08.28', 599.88, 1);

-- 19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

-- 20
SELECT * FROM Towns
ORDER BY [Name] ASC;

SELECT * FROM Departments
ORDER BY [Name] ASC;

SELECT * FROM Employees
ORDER BY Salary DESC;

-- 21
SELECT [Name] FROM Towns
ORDER BY [Name] ASC;

SELECT [Name] FROM Departments
ORDER BY [Name] ASC;

SELECT FirstName, LastName, JobTitle, Salary FROM Employees
ORDER BY Salary DESC;

--22
UPDATE Employees
SET Salary = Salary * 1.1

SELECT Salary FROM Employees

--23
USE Hotel
GO

UPDATE Payments
SET TaxRate = Taxrate * 0.97

SELECT TaxRate FROM Payments




