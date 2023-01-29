-- 1. Records' Count
USE Gringotts
GO

SELECT
COUNT(*) AS [Count]
FROM WizzardDeposits

-- 02. Longest Magic Wand 
SELECT
MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

-- 03. Longest Magic Wand per Deposit Groups
SELECT 
DepositGroup,
MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup

-- 04. Smallest Deposit Group per Magic Wand Size
SELECT TOP(2)
DepositGroup
FROM (
	SELECT 
	DepositGroup,
	AVG(MagicWandSize) AS AvgMagicWandSize
	FROM WizzardDeposits
	GROUP BY DepositGroup) AS a
ORDER BY AvgMagicWandSize

-- 05. Deposits Sum
SELECT
DepositGroup,
SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
GROUP BY DepositGroup

-- 6. Deposits Sum for Ollivander Family
SELECT 
DepositGroup,
SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup 

-- 7. Deposits Filter
SELECT 
DepositGroup,
SUM(DepositAmount) AS TotalSum
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

-- 08. Deposit Charge 
SELECT
DepositGroup,
MagicWandCreator,
MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup

-- 09. Age Groups 
SELECT 
AgeGroup,
SUM(WizardCount) AS WizardCount
FROM (
	SELECT
	CASE
		WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN Age BETWEEN 11 AND 20 THEN '[11-20]' 
		WHEN Age BETWEEN 21 AND 30 THEN '[21-30]' 
		WHEN Age BETWEEN 31 AND 40 THEN '[31-40]' 
		WHEN Age BETWEEN 41 AND 50 THEN '[41-50]' 
		WHEN Age BETWEEN 51 AND 60 THEN '[51-60]' 
		WHEN Age >= 61  THEN '[61+]' 
	END AS AgeGroup,
	COUNT(*) AS WizardCount
	FROM WizzardDeposits
	GROUP BY Age) AS a
GROUP BY AgeGroup

-- 10. First Letter
SELECT DISTINCT
SUBSTRING(FirstName, 1, 1) AS FirstLetter
FROM WizzardDeposits
GROUP BY FirstName, DepositGroup
HAVING DepositGroup = 'Troll Chest'
ORDER BY FirstLetter

-- 11. Average Interest
SELECT 
DepositGroup,
IsDepositExpired,
AVG(AverageInterest) AS AverageInterest
FROM (
	SELECT
	DepositGroup,
	IsDepositExpired,
	DepositStartDate,
	AVG(DepositInterest) AS AverageInterest
	FROM WizzardDeposits
	GROUP BY DepositGroup, IsDepositExpired, DepositStartDate
	HAVING DepositStartDate > '01/01/1985') AS a
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

-- 12. *Rich Wizard, Poor Wizard
SELECT
SUM([Difference]) AS SumDifference
FROM (
	SELECT
	hw.FirstName AS [Host Wizard],
	hw.DepositAmount AS [Host Wizard Deposit],
	gw.FirstName AS [Guest Wizard],
	gw.DepositAmount AS [Guest Wizard Deposit],
	hw.DepositAmount - gw.DepositAmount AS [Difference]
	FROM WizzardDeposits hw
	JOIN WizzardDeposits gw ON hw.Id = gw.Id - 1) AS a

-- 13. Departments Total Salaries
USE SoftUni
GO

SELECT
DepartmentID,
SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID

-- 14. Employees Minimum Salaries
SELECT
DepartmentID,
MIN(Salary) AS MinimumSalary
FROM Employees
GROUP BY DepartmentID
HAVING DepartmentID IN (2, 5, 7)

-- 15. Employees Average Salaries
SELECT *
INTO NewEmployees
FROM Employees
WHERE Salary > 30000

DELETE FROM NewEmployees
WHERE ManagerID = 42

UPDATE NewEmployees
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT
DepartmentID,
AVG(Salary) AS AverageSalary
FROM NewEmployees
GROUP BY DepartmentID

-- 16. Employees Maximum Salaries
SELECT
DepartmentID,
MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

-- 17. Employees Count Salaries
SELECT
COUNT(*) AS [Count]
FROM Employees
WHERE ManagerID IS NULL

-- 18. *3rd Highest Salary
SELECT
DepartmentID,
Salary AS ThirdHighestSalary
FROM (
	SELECT
	DepartmentID,
	Salary,
	DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
	FROM Employees
	GROUP BY DepartmentID, Salary) AS a
GROUP BY DepartmentID, Salary, SalaryRank
HAVING SalaryRank = 3

-- 19. **Salary Challenge
WITH a AS (
SELECT
DepartmentID,
AVG(Salary) AS AvgSalaryPerDepartment
FROM Employees
GROUP BY DepartmentID)

SELECT TOP(10)
b.FirstName,
b.LastName,
b.DepartmentID
FROM Employees b
JOIN a ON a.DepartmentID = b.DepartmentID
WHERE b.Salary > a.AvgSalaryPerDepartment
ORDER BY a.DepartmentID			
