-- 7
CREATE TABLE People(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	[Name] VARCHAR(200) NOT NULL,
	Picture VARBINARY(2000),
	Height FLOAT(2),
	[Weight] FLOAT(2),
	Gender CHAR(1) NOT NULL CHECK (Gender IN ('m','f')),
	Birthdate DATE NOT NULL,
	Biography VARCHAR(MAX),
)

INSERT INTO People
VALUES 
('Ivan', NULL, NULL, NULL, 'f', '10.10.1990', NULL),
('Petkan', NULL, NULL, NULL, 'm', '2.27.1990', NULL),
('Kaval', NULL, NULL, NULL, 'm', '2.23.1990', NULL),
('Koran', NULL, NULL, NULL, 'f', '6.14.1990', NULL),
('Lion', NULL, NULL, NULL, 'm', '1.10.1990', NULL)


INSERT INTO People
VALUES 
('Peter', NULL, 189, 87, 'f', '10.10.1990', NULL)


SELECT * FROM People
