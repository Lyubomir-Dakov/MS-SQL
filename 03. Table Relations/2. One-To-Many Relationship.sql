USE TableRelations
GO

-- 2. One-To-Many Relationship
CREATE TABLE Manufacturers (
	ManufacturerID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	EstablishedOn DATE NOT NULL,
	CONSTRAINT PK_Manufacturer PRIMARY KEY (ManufacturerID)
)

CREATE TABLE Models (
	ModelID INT,
	[Name] VARCHAR(255) NOT NULL,
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID) NOT NULL,
	CONSTRAINT PK_Model PRIMARY KEY (ModelID)
)

INSERT INTO Manufacturers ([Name], EstablishedOn)
VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966');

INSERT INTO Models (ModelID, [Name], ManufacturerID)
VALUES
(101 ,'X1', 1),
(102 ,'i6', 1),
(103 ,'Model S', 2),
(104 ,'Model X', 2),
(105 ,'Model 3', 2),
(106 ,'Nova', 3);
