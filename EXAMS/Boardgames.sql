CREATE DATABASE Boardgames
GO

USE Boardgames

GO
-- 1. DDL
CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE Addresses (
	Id INT PRIMARY KEY IDENTITY,
	StreetName VARCHAR(100) UNIQUE NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)

CREATE TABLE Publishers (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id) NOT NULL,
	Website VARCHAR(40) UNIQUE,
	Phone VARCHAR(20) UNIQUE
)

CREATE TABLE PlayersRanges(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) UNIQUE NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(18,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id) NOT NULL,
	PublisherId INT FOREIGN KEY REFERENCES Publishers(Id) NOT NULL,
	PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(Id) NOT NULL
)

CREATE TABLE Creators (
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Email VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE CreatorsBoardgames(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id) NOT NULL,
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id) NOT NULL
	PRIMARY KEY (CreatorId, BoardgameId)
)

-- 2. Insert
INSERT INTO Boardgames ([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId)
VALUES
	('Deep Blue', 2019, 5.67, 1, 15, 7),
	('Paris', 2016, 9.78, 7, 1, 5),
	('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
	('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
	('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO Publishers ([Name], AddressId, Website, Phone)
VALUES
	('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
	('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
	('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

-- 3. Update
UPDATE PlayersRanges
SET PlayersMax = PlayersMax + 1
WHERE PlayersMin = 2 AND PlayersMax = 2

UPDATE Boardgames
SET [Name] = CONCAT([Name], 'V2')
WHERE YearPublished >= 2020

-- 04. Delete
DELETE FROM CreatorsBoardgames
WHERE BoardgameId IN (SELECT Id
						FROM Boardgames
						WHERE PublisherId IN (SELECT
												Id
												FROM Publishers
												WHERE AddressId IN (SELECT 
																	Id
																	FROM Addresses
																	WHERE Country = 'USA')))

DELETE FROM Boardgames
WHERE PublisherId IN (SELECT
						Id
						FROM Publishers
						WHERE AddressId IN (SELECT 
											Id
											FROM Addresses
											WHERE Country = 'USA'))


DELETE FROM Publishers
WHERE AddressId IN (SELECT 
					Id
					FROM Addresses
					WHERE Country = 'USA')

DELETE FROM Addresses
WHERE Country = 'USA'

-- 5. Boardgames by Year of Publication
SELECT 
[Name],
Rating
FROM Boardgames
ORDER BY YearPublished, [Name] DESC

-- 06. Boardgames by Category
SELECT
	b.Id,
	b.[Name],
	b.YearPublished,
	c.[Name] AS CategoryName
FROM Boardgames b
JOIN Categories c ON b.CategoryId = c.Id
WHERE c.[Name] IN ('Strategy Games', 'Wargames')
ORDER BY b.YearPublished DESC

-- 07. Creators without Boardgames
SELECT
	c.Id,
	CONCAT(c.FirstName, ' ', c.LastName) AS 'CreatorName',
	c.Email
FROM Creators c
LEFT JOIN CreatorsBoardgames cb ON cb.CreatorId = c.Id
LEFT JOIN Boardgames b ON cb.BoardgameId = b.Id
WHERE cb.BoardgameId IS NULL

-- 08. First 5 Boardgames
SELECT TOP(5)
	b.[Name],
	b.Rating,
	c.[Name] AS CategoryName
FROM Boardgames b
JOIN PlayersRanges pr ON b.PlayersRangeId = pr.Id
JOIN Categories c ON b.CategoryId = c.Id
WHERE (b.Rating > 7.00 AND b.[Name] LIKE('%a%'))
   OR (b.Rating > 7.50 AND pr.PlayersMin = 2 AND pr.PlayersMax = 5)
ORDER BY b.[Name], b.Rating DESC

-- 09. Creators with Emails
SELECT
	CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
	c.Email,
	MAX(b.Rating) AS 'Rating'
FROM Creators c
JOIN CreatorsBoardgames cb ON c.Id = cb.CreatorId
JOIN Boardgames b ON cb.BoardgameId = b.Id
WHERE c.Email LIKE('%.com')
GROUP BY CONCAT(c.FirstName, ' ', c.LastName), c.Email
ORDER BY CONCAT(c.FirstName, ' ', c.LastName)

-- 10. Creators by Rating
SELECT
	c.LastName,
	CEILING(AVG(b.Rating)) AS AverageRating,
	p.[Name] AS PublisherName
FROM Creators c
JOIN CreatorsBoardgames cb ON c.Id = cb.CreatorId
JOIN Boardgames b ON cb.BoardgameId = b.Id
JOIN Publishers p ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AVG(b.Rating) DESC

-- 11. Creator with Boardgames 
GO

CREATE FUNCTION udf_CreatorWithBoardgames (@name VARCHAR(30))
RETURNS INT
AS
BEGIN
	DECLARE @result INT

	SELECT
	@result = COUNT(b.Id)
	FROM Creators c
	JOIN CreatorsBoardgames cb ON cb.CreatorId = c.Id
	JOIN Boardgames b ON cb.BoardgameId = b.Id
	WHERE c.FirstName = @name
	GROUP BY c.FirstName
	
	IF @result IS NULL
		SET @result = 0
	
	RETURN @result
END

DROP FUNCTION udf_CreatorWithBoardgames

GO

SELECT dbo.udf_CreatorWithBoardgames('Matt')
SELECT dbo.udf_CreatorWithBoardgames('ASDFASDFG')

-- 12. Search for Boardgame with Specific Category

GO

CREATE PROCEDURE usp_SearchByCategory (@category VARCHAR(50))
AS 
SELECT
	b.[Name],
	b.YearPublished,
	b.Rating,
	c.[Name] AS CategoryName,
	p.[Name] AS PublisherName,
	CONCAT(pr.PlayersMin, ' people') AS MinPlayers,
	CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
FROM Boardgames b
JOIN Categories c ON b.CategoryId = c.Id
JOIN Publishers p ON b.PublisherId = p.Id
JOIN PlayersRanges pr ON b.PlayersRangeId = pr.Id
WHERE c.[Name] = @category
ORDER BY p.[Name], b.YearPublished DESC

EXEC usp_SearchByCategory 'Wargames'

