USE SoftUni
GO

-- 1. Find Names of All Employees by First Name
SELECT FirstName, LastName FROM Employees
WHERE FirstName LIKE 'Sa%';

-- 2. Find Names of All Employees by Last Name
SELECT FirstName, LastName FROM Employees
WHERE  LastName LIKE '%ei%';

-- 03. Find First Names of All Employees
SELECT FirstName FROM Employees
WHERE DepartmentID = 3 OR DepartmentID = 10 AND YEAR(HireDate) >= 1995 AND YEAR(HireDate) <= 2005;

-- 04. Find All Employees Except Engineers
SELECT FirstName, LastName FROM Employees
WHERE NOT JobTitle LIKE '%engineer%'


-- 05. Find Towns with Name Length
SELECT [Name] FROM Towns
WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name] ASC;


-- 06. Find Towns Starting With 
SELECT * FROM Towns
WHERE [Name] LIKE 'M%' OR [Name] LIKE 'K%' OR [Name] LIKE 'B%' OR [Name] LIKE 'E%'
ORDER BY [Name] ASC;

-- 07. Find Towns Not Starting With
SELECT * FROM Towns
WHERE [Name] NOT LIKE 'R%' AND [Name] NOT LIKE 'B%' AND [Name] NOT LIKE 'D%'
ORDER BY [Name] ASC;

-- 08. Create View Employees Hired After 2000 Year
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName FROM Employees
WHERE YEAR(HireDate) > 2000;

SELECT * FROM V_EmployeesHiredAfter2000;

-- 09. Length of Last Name
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName) = 5

-- 10. Rank Employees by Salary
SELECT
	EmployeeID,
	FirstName,
	LastName,
	Salary,
	DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
FROM Employees
WHERE Salary >= 10000 AND Salary <= 50000
ORDER BY Salary DESC

-- 11. Find All Employees with Rank 2
SELECT * FROM (
SELECT EmployeeID, FirstName, LastName, Salary, DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank] FROM Employees
WHERE Salary >= 10000 AND Salary <= 50000
) AS T
WHERE T.[Rank] = 2
ORDER BY T.Salary DESC

-- 12. Countries Holding 'A' 3 or More Times
USE Geography
GO

SELECT CountryName, IsoCode FROM Countries
WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'A', '')) >= 3
ORDER BY IsoCode

-- 13. Mix of Peak and River Names
SELECT 
	Peaks.PeakName AS PeakName, 
	Rivers.RiverName AS RiverName, 
	LOWER(CONCAT(PeakName, RIGHT(RiverName, LEN(RiverName) - 1))) AS Mix 
FROM Peaks, Rivers
WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
ORDER BY Mix


-- 14. Games From 2011 and 2012 Year
USE Diablo
GO

SELECT TOP(50)
	[Name], 
	CONVERT(VARCHAR, [Start], 23) AS [Start]
FROM Games
WHERE YEAR([Start]) = 2011 OR YEAR([Start]) = 2012
ORDER BY [Start], [Name] 

-- 15. User Email Providers
USE Diablo
GO

SELECT 
	Username, 
	SUBSTRING(Email, CHARINDEX('@', Email) + 1, LEN(Email)) AS [Email Provider]
FROM Users
ORDER BY [Email Provider], Username

-- 16. Get Users with IP Address Like Pattern
USE Diablo
GO

SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- 17. Show All Games with Duration & Part of the Day
USE Diablo
GO

SELECT
	[Name] AS Game,
	CASE
		WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [START]) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [START]) < 18 THEN 'Afternoon'
		WHEN DATEPART(HOUR, [START]) >= 18 AND DATEPART(HOUR, [START]) < 24 THEN 'Evening'
	END AS [Part of the Day],
	CASE
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration > 3 AND Duration <= 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
	END AS Duration
FROM Games
ORDER BY [Name], Duration, [Part of the Day]

-- 18. Orders Table
USE Orders
GO

SELECT 
	ProductName,
	OrderDate,
	DATEADD(DD,3 , OrderDate) AS [Pay Due],
	DATEADD(MM, +1,OrderDate) AS [Deliver Due]
FROM Orders

-- 19. People Table
CREATE TABLE People (
	Id INT IDENTITY, 
	[Name] VARCHAR(255) NOT NULL, 
	Birthdate DATETIME2,
	CONSTRAINT PK_people PRIMARY KEY (Id)
)

INSERT INTO People ([Name], Birthdate)
VALUES
('Victor', '2000-12-07 00:00:00.000'),
('Steven', '1992-09-10 00:00:00.000'),
('Stephen', '1910-09-19 00:00:00.000'),
('John', '2010-01-06 00:00:00.000')

SELECT 
	[Name],
	DATEDIFF(YEAR, Birthdate, GETDATE()) AS [Age in Years],
	DATEDIFF(MONTH, Birthdate, GETDATE()) AS [Age in Months],
	DATEDIFF(DAY, Birthdate, GETDATE()) AS [Age in Days],
	DATEDIFF(MINUTE, Birthdate, GETDATE()) AS [Age in Minutes]
FROM People
