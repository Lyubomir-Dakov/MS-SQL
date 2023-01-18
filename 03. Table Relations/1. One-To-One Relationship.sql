CREATE DATABASE TableRelations;

USE TableRelations
GO

-- 1. One-To-One Relationship
CREATE TABLE Persons (
	PersonID INT IDENTITY, 
	FirstName VARCHAR(255) NOT NULL,
	Salary INT NOT NULL,
	CONSTRAINT PK_Person PRIMARY KEY (PersonID)
)

CREATE TABLE Passports (
	PassportID INT,
	PassportNumber VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Passport PRIMARY KEY (PassportID)
)

ALTER TABLE Persons
ADD PassportID INT FOREIGN KEY REFERENCES Passports(PassportID) NOT NULL;

INSERT INTO Passports (PassportID, PassportNumber)
VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2');

INSERT INTO Persons (FirstName, Salary, PassportID)
VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);

