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


