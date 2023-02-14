CREATE DATABASE Airport
GO

USE Airport

-- 1. DDL
CREATE TABLE Passengers (
	Id INT IDENTITY PRIMARY KEY,
	FullName VARCHAR(100) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots (
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Age TINYINT NOT NULL CHECK (Age BETWEEN 21 AND 62),
	Rating FLOAT CHECK (Rating BETWEEN 0.0 AND 10.0)	
)


CREATE TABLE AircraftTypes(
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft (
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,
	Condition CHAR NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft (
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id),
	PilotId INT FOREIGN KEY REFERENCES Pilots(Id),
	PRIMARY KEY (AircraftId, PilotId)
)

CREATE TABLE Airports (
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) UNIQUE NOT NULL,
	Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations (
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT FOREIGN KEY REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT FOREIGN KEY REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT FOREIGN KEY REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18, 2) DEFAULT 15 NOT NULL
)

-- 2. Insert
INSERT INTO Passengers (FullName, Email)
SELECT
	CONCAT(FirstName, ' ', LastName),
	CONCAT(FirstName, LastName, '@gmail.com')
FROM Pilots
WHERE Pilots.Id BETWEEN 5 AND 15

-- 3. Update
UPDATE Aircraft
SET Condition = 'A'
WHERE (Condition IN ('B', 'C')) AND (FlightHours IS NULL OR FlightHours <= 100) AND ([Year] >= 2013)

-- 4. Delete
DELETE FROM Passengers
WHERE LEN(FullName) <= 10

-- 5. Aircraft
SELECT
	Manufacturer,
	Model,
	FlightHours,
	Condition
FROM Aircraft
ORDER BY FlightHours DESC

-- 6. Pilots and Aircraft
SELECT
	p.FirstName,
	p.LastName,
	a.Manufacturer,
	a.Model,
	a.FlightHours
FROM Pilots p
JOIN PilotsAircraft pa ON p.Id = pa.PilotId
JOIN Aircraft a ON pa.AircraftId = a.Id
WHERE a.FlightHours < 304 AND a.FlightHours IS NOT NULL
ORDER BY a.FlightHours DESC, p.FirstName

-- 7. Top 20 Flight Destinations
SELECT TOP(20)
	fd.Id AS DestinationId,
	fd.[Start],
	p.FullName,
	a.AirportName,
	fd.TicketPrice
FROM FlightDestinations fd
JOIN Passengers p ON fd.PassengerId = p.Id
JOIN Airports a ON fd.AirportId = a.Id
WHERE DAY(fd.[Start]) % 2 = 0
ORDER BY fd.TicketPrice DESC, a.AirportName

-- 8. Number of Flights for Each Aircraft
SELECT
a.Id AS AircraftId,
a.Manufacturer,
a.FlightHours,
COUNT(fd.Id) AS FlightDestinationsCount,
ROUND(AVG(fd.TicketPrice), 2) AS AvgPrice
FROM Aircraft a
JOIN FlightDestinations fd ON a.Id = fd.AircraftId
GROUP BY a.Id, a.Manufacturer, a.FlightHours
HAVING COUNT(fd.Id) >= 2
ORDER BY COUNT(fd.Id) DESC, AircraftId

-- 9. Regular Passengers
SELECT
p.FullName,
COUNT(fd.AircraftId) AS 'CountOfAircraft',
SUM(fd.TicketPrice) AS 'TotalPayed'
FROM Passengers p
JOIN FlightDestinations fd ON p.Id = fd.PassengerId
GROUP BY P.FullName
HAVING COUNT(fd.AircraftId) > 1 AND SUBSTRING(p.FullName, 2, 1) = 'a'
ORDER BY p.FullName

-- 10. Full Info for Flight Destinations
SELECT
	ap.AirportName,
	fd.[Start] AS DayTime,
	fd.TicketPrice,
	p.FullName,
	ac.Manufacturer,
	ac.Model
FROM FlightDestinations as fd
JOIN Airports ap ON fd.AirportId = ap.Id
JOIN Aircraft ac ON fd.AircraftId = ac.Id
JOIN Passengers p ON fd.PassengerId = p.Id
WHERE (DATEPART(HOUR , fd.[Start]) BETWEEN 6 AND 20) AND fd.TicketPrice > 2500
ORDER BY ac.Model

-- 11. Find all Destinations by Email Address
CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @DestinationsCount INT
	
	SELECT	
	@DestinationsCount = COUNT(fd.Id)
	FROM Passengers p
	JOIN FlightDestinations fd ON p.Id = fd.PassengerId
	GROUP BY p.Email
	HAVING p.Email = @email

	IF (@DestinationsCount IS NULL)
		SET @DestinationsCount = 0
	RETURN @DestinationsCount
END

SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')

-- 12. Full Info for Airports
CREATE PROCEDURE usp_SearchByAirportName  @airportName VARCHAR (70)
AS
SELECT
	ap.AirportName,
	p.FullName,
	CASE
		WHEN fd.TicketPrice <= 400 THEN 'Low'
		WHEN fd.TicketPrice <= 1500 THEN 'Medium'
		WHEN fd.TicketPrice > 1501 THEN 'High' 
	END AS LevelOfTickerPrice,
	ac.Manufacturer,
	ac.Condition,
	[at].TypeName
FROM FlightDestinations fd
JOIN Airports ap ON fd.AirportId = ap.Id
JOIN Passengers p ON fd.PassengerId = p.Id
JOIN Aircraft ac ON fd.AircraftId = ac.Id
JOIN AircraftTypes [at] ON ac.TypeId = [at].Id
WHERE ap.AirportName = @airportName
ORDER BY ac.Manufacturer, p.FullName

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'

