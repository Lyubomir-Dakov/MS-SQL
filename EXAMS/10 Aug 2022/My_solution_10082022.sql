CREATE DATABASE NationalTouristSitesOfBulgaria
GO

USE NationalTouristSitesOfBulgaria
GO

-- 01.DDL

CREATE TABLE Categories (
	Id INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Locations(
	Id INT IDENTITY PRIMARY KEY,
	[Name] VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50),
	Province VARCHAR(50)
)

CREATE TABLE Sites(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(100) NOT NULL,
	LocationId INT FOREIGN KEY REFERENCES Locations(Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	Establishment VARCHAR(15) 
)

CREATE TABLE Tourists(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL, 
	Age INT NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Reward VARCHAR(20),
	CHECK(Age BETWEEN 0 AND 120)
)


CREATE TABLE SitesTourists(
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id),
	SiteId INT	FOREIGN KEY REFERENCES Sites(Id),
	CONSTRAINT PK_SiteTourist PRIMARY KEY (TouristId, SiteId)
)


CREATE TABLE BonusPrizes(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE TouristsBonusPrizes (
	TouristId INT FOREIGN KEY REFERENCES Tourists(Id),
	BonusPrizeId INT FOREIGN KEY REFERENCES BonusPrizes(Id),
	CONSTRAINT PK_TouristPrize PRIMARY KEY (TouristId, BonusPrizeId)
)

-- 02. Insert
INSERT INTO Tourists ([Name], Age, PhoneNumber, Nationality, Reward)
VALUES
	('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
	('Peter Bosh', 48, '+447911844141',	'UK', NULL),
	('Martin Smith',29	, '+353863818592' , 'Ireland', 'Bronze badge'),
	('Svilen Dobrev', 49, '+359986584786', 'Bulgaria' ,'Silver badge'),
	('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO Sites ([Name], LocationId, CategoryId, Establishment)
VALUES
	('Ustra fortress' ,90 , 7,	'X'),
	('Karlanovo Pyramids', 65 ,7 ,NULL),
	('The Tomb of Tsar Sevt', 63 ,8 , 'V BC'),
	('Sinite Kamani Natural Park', 17, 1 ,NULL),
	('St. Petka of Bulgaria – Rupite', 92, 6 ,'1994')

-- 03. Update
UPDATE Sites
	SET Establishment = '(not defined)'
	WHERE Establishment IS NULL;

-- 04. Delete 
DELETE FROM Tourists
WHERE Reward = 'Sleeping bag';

DELETE FROM TouristsBonusPrizes
WHERE BonusPrizeId = (SELECT Id FROM BonusPrizes WHERE [Name] = 'Sleeping bag')

DELETE FROM BonusPrizes
WHERE [Name] = 'Sleeping bag';

-- 05. Tourists
SELECT
[Name],
Age,
PhoneNumber,
Nationality
FROM Tourists
ORDER BY Nationality, Age DESC, [Name]

-- 06. Sites with Their Location and Category
SELECT
s.[Name] AS [Site],
l.[Name] AS	[Location],
Establishment,
c.[Name] AS Category
FROM Sites s
JOIN Locations l
ON s.LocationId = l.Id
JOIN Categories c
ON s.CategoryId = c.Id
ORDER BY c.[Name] DESC, [Location], [Site]

-- 07. Count of Sites in Sofia Province
-- Province		Municipality		Location		CountOfSites

SELECT
l.Province,
l.Municipality,
l.[Name] AS [Location]
--COUNT(s.Id) AS CountOfSites
FROM Locations l
JOIN Sites s
ON l.Id = s.LocationId
WHERE Province = 'Sofia'


SELECT
[Location]
FROM (
	SELECT
	l.Province,
	l.Municipality,
	l.[Name] AS [Location]
	--COUNT(s.Id) AS CountOfSites
	FROM Locations l
	JOIN Sites s
	ON l.Id = s.LocationId
	WHERE Province = 'Sofia'
) AS X 
GROUP BY [Location]






