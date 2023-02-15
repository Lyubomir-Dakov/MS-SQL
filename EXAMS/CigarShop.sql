CREATE DATABASE CigarShop

USE CigarShop

CREATE TABLE Sizes (
	Id INT PRIMARY KEY IDENTITY,
	[Length] INT CHECK([Length] BETWEEN 10 AND 25) NOT NULL,
	RingRange DECIMAL(2, 1) CHECK(RingRange BETWEEN 1.5 AND 7.5) NOT NULL
)

CREATE TABLE Tastes (
	Id INT PRIMARY KEY IDENTITY,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)

CREATE TABLE Brands (
	Id INT PRIMARY KEY IDENTITY,
	BrandName VARCHAR(30) UNIQUE NOT NULL,
	BrandDescription VARCHAR(MAX)
)

CREATE TABLE Cigars (
	Id INT IDENTITY PRIMARY KEY,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT FOREIGN KEY REFERENCES Brands(Id) NOT NULL,
	TastId INT FOREIGN KEY REFERENCES Tastes(Id) NOT NULL,
	SizeId INT FOREIGN KEY REFERENCES Sizes(Id) NOT NULL,
	PriceForSingleCigar DECIMAL(18,2) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL,
)

CREATE TABLE Addresses (
	Id INT PRIMARY KEY IDENTITY,
	Town VARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Streat NVARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL
)

CREATE TABLE Clients (
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL
)

CREATE TABLE ClientsCigars(
	ClientId INT FOREIGN KEY REFERENCES Clients(Id),
	CigarId INT FOREIGN KEY REFERENCES Cigars(Id),
	PRIMARY KEY (ClientId, CigarId)
)


-- 2. Insert
INSERT INTO Cigars (CigarName, BrandId, TastId, SizeId, PriceForSingleCigar, ImageURL)
VALUES
	('COHIBA ROBUSTO', 9, 1, 5, 15.50, 'cohiba-robusto-stick_18.jpg'),
	('COHIBA SIGLO I', 9, 1, 10, 410.00, 'cohiba-siglo-i-stick_12.jpg'),
	('HOYO DE MONTERREY LE HOYO DU MAIRE', 14, 5, 11, 7.50, 'hoyo-du-maire-stick_17.jpg'),
	('HOYO DE MONTERREY LE HOYO DE SAN JUAN', 14, 4, 15, 32.00, 'hoyo-de-san-juan-stick_20.jpg'),
	('TRINIDAD COLONIALES', 2, 3, 8, 85.21, 'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses (Town, Country, Streat, ZIP)
VALUES
	('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000),
	('Athens', 'Greece', '4342 McDonald Avenue', 10435),
	('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)

-- 3. Update
UPDATE Cigars
SET PriceForSingleCigar = PriceForSingleCigar * 1.2
WHERE TastId = 1

UPDATE Brands
SET BrandDescription = 'New description'
WHERE BrandDescription IS NULL

-- 4. Delete
DELETE FROM Clients
WHERE AddressId IN (
	SELECT Id FROM Addresses
	WHERE Country LIKE 'C%')

DELETE FROM Addresses
WHERE Country LIKE 'C%'

-- 05. Cigars by Price
SELECT
	CigarName,
	PriceForSingleCigar,	
	ImageURL
FROM Cigars
ORDER BY PriceForSingleCigar, CigarName DESC

-- 06. Cigars by Taste
SELECT
	c.Id,
	c.CigarName,
	c.PriceForSingleCigar,
	t.TasteType,
	t.TasteStrength
FROM Cigars c
JOIN Tastes t ON c.TastId = t.Id
WHERE t.TasteType IN ('Earthy', 'Woody')
ORDER BY c.PriceForSingleCigar DESC

-- 07. Clients without Cigars
SELECT
	c.Id,
	CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
	c.Email
FROM Clients c
LEFT JOIN ClientsCigars cc ON c.Id = cc.ClientId
WHERE cc.CigarId IS NULL
ORDER BY CONCAT(c.FirstName, ' ', c.LastName)

-- 08. First 5 Cigars
SELECT TOP(5)
	c.CigarName,
	c.PriceForSingleCigar,
	c.ImageURL
FROM Cigars c
JOIN Sizes s ON c.SizeId = s.Id
WHERE 
	s.[Length] >= 12 AND (c.CigarName LIKE '%ci%'
	OR c.PriceForSingleCigar > 50 AND s.RingRange > 2.55)
ORDER BY c.CigarName, c.PriceForSingleCigar DESC

-- 9. Clients with ZIP Codes
SELECT
	CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
	a.Country,
	a.ZIP,
	CONCAT('$', MAX(cg.PriceForSingleCigar)) AS CigarPrice
FROM Clients c
JOIN Addresses a ON c.AddressId = a.Id
JOIN ClientsCigars cc ON c.Id = cc.ClientId
JOIN Cigars cg ON cc.CigarId = cg.Id
WHERE ISNUMERIC(a.ZIP) = 1
GROUP BY CONCAT(c.FirstName, ' ', c.LastName), a.Country, a.ZIP
ORDER BY CONCAT(c.FirstName, ' ', c.LastName)

-- 10. Cigars by Size
-- LastName		CiagrLength		CiagrRingRange

SELECT * FROM Cigars
SELECT * FROM Sizes

SELECT
	c.LastName,
	AVG(s.[Length]) AS CiagrLength
	--CEILING(s.RingRange) AS CiagrRingRange
FROM Clients c
JOIN ClientsCigars cc ON c.Id = cc.ClientId
JOIN Cigars cg ON cc.CigarId = cg.Id
JOIN Sizes s ON cg.SizeId = s.Id
GROUP BY c.LastName
ORDER BY AVG(s.[Length]) DESC


SELECT
	c.LastName,
	AVG(s.[Length]) AS CiagrLength,
	CEILING(s.RingRange) AS CiagrRingRange
FROM Clients c
JOIN ClientsCigars cc ON c.Id = cc.ClientId
JOIN Cigars cg ON cc.CigarId = cg.Id
JOIN Sizes s ON cg.SizeId = s.Id
GROUP BY c.LastName
ORDER BY AVG(s.[Length]) DESC
