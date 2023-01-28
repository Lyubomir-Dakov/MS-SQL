-- 1. Employee Address
USE SoftUni
GO

SELECT TOP(5) e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText
FROM Employees e
INNER JOIN Addresses a
ON e.AddressID = a.AddressID
ORDER BY AddressID

-- 2. Addresses with Towns
USE SoftUni
GO

SELECT TOP(50) e.FirstName, e.LastName, t.[Name], a.AddressText
FROM ((Employees e
INNER JOIN Addresses a ON e.AddressID = a.AddressID)
INNER JOIN Towns t ON a.TownID = t.TownID)
ORDER BY FirstName, LastName;

-- 03. Sales Employees
USE SoftUni
GO

SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] AS DepartmentName
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE d.[Name] = 'Sales'
ORDER BY EmployeeID

-- 04. Employee Departments
USE SoftUni
GO

SELECT TOP(5) e.EmployeeID, e.FirstName, e.Salary, d.[Name] AS DepartmentName
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE Salary > 15000
ORDER BY d.DepartmentID

-- 05. Employees Without Projects
SELECT TOP(3) e.EmployeeID, e.FirstName
FROM Employees e
LEFT JOIN EmployeesProjects ep
ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL

-- 06. Employees Hired After 
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] AS DeptName
FROM Employees e
INNER JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE e.HireDate > '1.1.1999' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate;

-- 07. Employees With Project 
SELECT TOP(5) e.EmployeeID, e.FirstName, p.[Name] AS ProjectName
FROM ((Projects p
INNER JOIN EmployeesProjects ep ON p.ProjectID = ep.ProjectID)
INNER JOIN Employees e ON e.EmployeeID = ep.EmployeeID)
WHERE p.StartDate > '08.13.2002'
ORDER BY e.EmployeeID

-- 08. Employee 24
SELECT 
	e.EmployeeID,
	e.FirstName, 
	CASE
		WHEN YEAR(p.StartDate) >= 2005 THEN NULL
		ELSE p.[Name]
	END AS ProjectName
FROM ((Projects p
INNER JOIN EmployeesProjects ep ON p.ProjectID = ep.ProjectID)
INNER JOIN Employees e ON ep.EmployeeID = e.EmployeeID)
WHERE e.EmployeeID = 24

-- 09. Employee Manager
SELECT
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	m.FirstName AS ManagerName
FROM Employees e, Employees m
WHERE e.ManagerID = m.EmployeeID AND e.ManagerID IN (3, 7)

-- 10. Employees Summary
SELECT TOP(50)
	e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
	CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
	d.[Name] AS DepartmentName
FROM Employees e, Employees m, Departments d
WHERE e.ManagerID = m.EmployeeID AND e.DepartmentID = d.DepartmentID


-- 11. Min Average Salary
SELECT MIN(s.AvgSalary) FROM
(SELECT AVG(Salary) AS AvgSalary FROM Employees
GROUP BY DepartmentID) AS s

-- 12. Highest Peaks in Bulgaria
USE Geography
GO

SELECT mc.CountryCode, m.MountainRange, p.PeakName, p.Elevation
FROM MountainsCountries mc
JOIN Mountains m ON m.Id = mc.MountainId
JOIN Peaks p ON p.MountainId = m.Id
WHERE mc.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY p.Elevation DESC

-- 13. Count Mountain Ranges
SELECT c.CountryCode, COUNT(m.MountainRange)
FROM Countries c
JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
JOIN Mountains m ON m.Id = mc.MountainId
WHERE c.CountryCode IN ('BG', 'US', 'RU')
GROUP BY c.CountryCode


-- 14. Countries With or Without Rivers
SELECT TOP(5) c.CountryName, r.RiverName
FROM Countries c
LEFT JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
LEFT JOIN Rivers r ON cr.RiverId = r.Id
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

-- 15. *Continents and Currencies
SELECT 
ContinentCode,
CurrencyCode,
CurrencyUsage
FROM 
	(
	SELECT *,
	DENSE_RANK() OVER(PARTITION BY ContinentCode ORDER BY CurrencyUsage DESC) AS CurrencyRank
	FROM 
		(
		SELECT 
		ContinentCode,
		CurrencyCode,
		COUNT(CurrencyCode) AS CurrencyUsage
		FROM Countries
		GROUP BY ContinentCode, CurrencyCode
		HAVING COUNT(CurrencyCode) > 1
		) AS Subquery_1
	) AS Subquery_2
WHERE CurrencyRank = 1

-- 16. Countries Without Any Mountains
SELECT 
COUNT(*) AS [Count]
FROM Countries c
LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
WHERE mc.MountainId IS NULL

-- 17. Highest Peak and Longest River by Country
SELECT TOP(5)
CountryName,
Elevation AS HighestPeakElevation,
[Length] AS LongestRiverLength
FROM
	(
		SELECT *,
		DENSE_RANK() OVER(PARTITION BY asd.CountryName ORDER BY asd.Elevation DESC) AS MountineRank,
		DENSE_RANK() OVER(PARTITION BY asd.CountryName ORDER BY asd.[Length] DESC) AS RiverRank
		FROM (
				SELECT
				c.CountryName,
				p.Elevation,
				r.[Length]
				FROM Countries c
				LEFT JOIN CountriesRivers cr ON c.CountryCode = cr.CountryCode
				LEFT JOIN Rivers r ON cr.RiverId = r.Id
				LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
				LEFT JOIN Mountains m ON mc.MountainId = m.Id
				LEFT JOIN Peaks p ON m.Id = p.MountainId
			) AS asd
	) AS asd2
WHERE MountineRank = 1 AND RiverRank = 1
ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, CountryName

-- 18. Highest Peak Name and Elevation by Country
SELECT TOP(5)
Country,
[Highest Peak Name],
[Highest Peak Elevation],
Mountine
FROM
	(
		SELECT *,
		DENSE_RANK() OVER(PARTITION BY sub.Country ORDER BY sub.[Highest Peak Elevation] DESC) AS PeakRank
		FROM
			(
				SELECT 
				c.CountryName AS Country,
				ISNULL(p.PeakName, '(no highest peak)') AS [Highest Peak Name],
				ISNULL(p.Elevation, 0) AS [Highest Peak Elevation],
				ISNULL(m.MountainRange, '(no mountain)') AS Mountine
				FROM Countries c
				LEFT JOIN MountainsCountries mc ON c.CountryCode = mc.CountryCode
				LEFT JOIN Mountains m ON mc.MountainId = m.Id
				LEFT JOIN Peaks p ON m.Id = p.MountainId
			) AS sub
	) AS sub2
WHERE PeakRank = 1
ORDER BY Country, [Highest Peak Name]







	