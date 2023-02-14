CREATE DATABASE Zoo
GO

USE Zoo;

-- 1. DDL

CREATE TABLE Owners (
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[PhoneNumber] VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50)
)

CREATE TABLE AnimalTypes (
	Id INT PRIMARY KEY IDENTITY,
	AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages (
	Id INT PRIMARY KEY IDENTITY,
	AnimalTypeId INT FOREIGN KEY REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT FOREIGN KEY REFERENCES Owners(Id),
	AnimalTypeId INT FOREIGN KEY REFERENCES AnimalTypes NOT NULL
)

CREATE TABLE AnimalsCages(
	CageId INT FOREIGN KEY REFERENCES Cages(Id) NOT NULL,
	AnimalId INT FOREIGN KEY REFERENCES Animals(Id) NOT NULL
	PRIMARY KEY (CageId, AnimalId)
)

CREATE TABLE VolunteersDepartments(
	Id INT PRIMARY KEY IDENTITY,
	DepartmentName VARCHAR(30) NOT NULL
)

CREATE TABLE Volunteers(
	Id INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	[Address] VARCHAR(50),
	AnimalId INT FOREIGN KEY REFERENCES Animals(Id),
	DepartmentId INT FOREIGN KEY REFERENCES VolunteersDepartments(Id) NOT NULL
)

-- 2. Insert
INSERT INTO Volunteers ([Name], PhoneNumber, [Address], AnimalId, DepartmentId)
VALUES
	('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
	('Dimitur Stoev', '0877564223', NULL, 42, 4),
	('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
	('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
	('Boryana Mileva', '0888112233', NULL, 31, 5)

INSERT INTO Animals ([Name], BirthDate, OwnerId, AnimalTypeId)
VALUES
	('Giraffe', '2018-09-21', 21, 1),
	('Harpy Eagle', '2015-04-17', 15, 3),
	('Hamadryas Baboon', '2017-11-02', NULL, 1),
	('Tuatara', '2021-06-30', 2, 4)

-- 3. Update
UPDATE Animals
SET OwnerId = 4
WHERE OwnerId IS NULL

-- 4. Delete
DELETE FROM Volunteers
WHERE DepartmentId = 2

DELETE FROM VolunteersDepartments
WHERE DepartmentName = 'Education program assistant'

-- 5. Volunteers
SELECT 
	[Name],
	PhoneNumber,
	[Address],
	AnimalId,
	DepartmentId
FROM Volunteers
ORDER BY [Name], AnimalId, DepartmentId

-- 6. Animals data
SELECT
	a.[Name],
	[at].AnimalType,
	CONVERT(VARCHAR, a.BirthDate, 104) AS BirthDate		
FROM Animals a
JOIN AnimalTypes [at]
ON a.AnimalTypeId = [at].Id
ORDER BY a.[Name]

-- 7. Owners and Their Animals
SELECT TOP(5)
o.[Name] AS 'Owner',
COUNT(a.Id) AS 'CountOfAnimals'
FROM Owners o
JOIN Animals a
ON o.Id = a.OwnerId
GROUP BY o.[Name]
ORDER BY COUNT(a.Id) DESC, o.[Name]

-- 8. Owners, Animals and Cages
SELECT
CONCAT(o.[Name], '-', a.[Name]) AS OwnersAnimals,
o.PhoneNumber,
ac.CageId
FROM Owners o
JOIN Animals a ON o.Id = a.OwnerId
JOIN AnimalsCages ac ON a.Id = ac.AnimalId
JOIN AnimalTypes [at] ON a.AnimalTypeId = [at].Id
WHERE [at].AnimalType = 'Mammals'
ORDER BY o.[Name], a.[Name] DESC

-- 9. Volunteers in Sofia
SELECT
	v.[Name],
	v.PhoneNumber,
	TRIM(SUBSTRING(TRIM(v.[Address]), 8, LEN(v.[Address]))) AS 'Address'
FROM Volunteers v
JOIN VolunteersDepartments vd
ON v.DepartmentId = vd.Id
WHERE vd.DepartmentName = 'Education program assistant' AND v.[Address] LIKE '%Sofia%'
ORDER BY v.[Name]

-- 10. Animals for Adoption
SELECT
	a.[Name],	
	YEAR(a.BirthDate) AS BirthYear,
	[at].AnimalType
FROM Animals a
JOIN AnimalTypes [at]
ON a.AnimalTypeId = [at].Id
WHERE (OwnerId IS NULL)
	AND DATEDIFF(YEAR, BirthDate, '01/01/2022') < 5
	AND [at].AnimalType <> 'Birds'
ORDER BY a.[Name]

-- 11. All Volunteers in a Department
CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS 
BEGIN
	DECLARE @countVolunteers INT
	SELECT
	@countVolunteers = COUNT(v.Id)
	FROM VolunteersDepartments vd
	JOIN Volunteers v
	ON vd.Id = v.DepartmentId
	GROUP BY vd.DepartmentName
	HAVING vd.DepartmentName = @VolunteersDepartment
	
	RETURN @countVolunteers
END

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Education program assistant')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement')
SELECT dbo.udf_GetVolunteersCountFromADepartment ('Zoo events')

-- 12. Animals with Owner or Not
CREATE PROCEDURE usp_AnimalsWithOwnersOrNot @AnimalName VARCHAR(30)
AS
SELECT
	a.[Name],
	CASE
		WHEN o.[Name] IS NULL THEN 'For adoption'
		ELSE o.[Name]
	END AS OwnersName
FROM Animals a
LEFT JOIN Owners o
ON a.OwnerId = o.Id
WHERE a.[Name] = @AnimalName

EXEC usp_AnimalsWithOwnersOrNot 'Pumpkinseed Sunfish'
EXEC usp_AnimalsWithOwnersOrNot 'Hippo'
EXEC usp_AnimalsWithOwnersOrNot 'Brown bear'