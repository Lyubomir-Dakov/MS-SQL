USE SoftUni
GO

--01. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName FROM Employees
WHERE Salary > 35000

EXEC usp_GetEmployeesSalaryAbove35000

-- 2. Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18, 4)
AS
SELECT 
FirstName, LastName
FROM Employees
WHERE Salary >= @Number

EXEC usp_GetEmployeesSalaryAboveNumber @Number = 48100

-- 03. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith @Word VARCHAR(100)
AS
SELECT
[Name]
FROM Towns
WHERE @Word = SUBSTRING([Name], 1, LEN(@Word))

EXEC usp_GetTownsStartingWith @Word = 'b'

-- 04. Employees from Town
CREATE PROC usp_GetEmployeesFromTown @TownName VARCHAR(100)
AS
SELECT
e.FirstName,
e.LastName
FROM Employees e
JOIN Addresses a ON e.AddressID = a.AddressID
JOIN Towns t ON a.TownID = t.TownID
WHERE t.[Name] = @TownName
	
EXEC usp_GetEmployeesFromTown @TownName = 'Sofia'

-- 05. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @SalaryLevel VARCHAR(10)
	IF @salary < 30000 SET @SalaryLevel = 'Low'
	ELSE IF @salary BETWEEN 30000 AND 50000 SET @SalaryLevel = 'Average'
	ELSE IF @salary > 50000 SET @SalaryLevel = 'High'
	RETURN @SalaryLevel;
END

SELECT
Salary,
dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
FROM Employees;

-- 06. Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel @SalaryLevel VARCHAR(10)
AS
SELECT
FirstName,
LastName
FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

EXEC usp_EmployeesBySalaryLevel @SalaryLevel = 'High'

-- 07. Define Function
SELECT * FROM Employees
SELECT * FROM Towns

CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(300), @word VARCHAR(100))
RETURNS BIT
AS
BEGIN
	DECLARE @result INT = 1
	DECLARE @index INT = 1
	WHILE @index <= LEN(@word)
	BEGIN
		IF CHARINDEX(@setOfLetters, SUBSTRING(@word, @index, 1)) > 0
		SET @index = @index + 1 
		ELSE SET @result = 0
		BREAK
	END
	RETURN @result
END

SELECT
LOWER(MiddleName) AS SetOfLetters,
JobTitle AS Word,
dbo.ufn_IsWordComprised(MiddleName, JobTitle) AS Result
FROM Employees

-- 8. Delete Employees and Departments
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment @departmentId INT
AS
BEGIN
	DECLARE @employeesToDelete TABLE(Id INT)

	INSERT INTO @employeesToDelete (Id)
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (SELECT Id FROM @employeesToDelete)

	ALTER TABLE Employees
	ALTER COLUMN DepartmentID INT

	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT

	UPDATE Employees
	SET DepartmentID = NULL
	WHERE DepartmentID = @departmentId

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT Id FROM @employeesToDelete)

	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	SELECT 
	COUNT(*)
	FROM Employees
	WHERE DepartmentID = @departmentId
END

EXEC dbo.usp_DeleteEmployeesFromDepartment 3

-- 9. Find Full Name
USE Bank

CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN 
	SELECT
	CONCAT(a.FirstName, ' ', a.LastName) AS 'Full Name'
	FROM AccountHolders a
END

EXEC dbo.usp_GetHoldersFullName

-- 10. People with Balance Higher Than
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan @moneyBorder MONEY
AS
BEGIN 
	SELECT
	ah.FirstName AS 'First Name',
	ah.LastName AS 'Last Name'
	FROM Accounts a
	JOIN AccountHolders ah ON a.AccountHolderId = ah.Id
	GROUP BY a.AccountHolderId, ah.FirstName, ah.LastName
	HAVING SUM(a.Balance) > @moneyBorder
	ORDER BY ah.FirstName, ah.LastName
END

EXEC dbo.usp_GetHoldersWithBalanceHigherThan 500000

-- 11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue (@initialSum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @NumberOfYears INT)
RETURNS DECIMAL(18, 4)
AS
BEGIN
	DECLARE @futureValue DECIMAL(18, 4)
	SET @futureValue = @initialSum * POWER((1 + @yearlyInterestRate), @NumberOfYears)
	RETURN ROUND(@futureValue, 4)
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)

-- 12. Calculating Interest
CREATE OR ALTER PROCEDURE usp_CalculateFutureValueForAccount (@accountId INT, @interestRate FLOAT)
AS
SELECT
	a.Id AS 'Account Id',
	ah.FirstName AS 'First Name',
	ah.LastName AS 'Last Name',
	SUM(a.Balance) AS 'Current Balance',
	dbo.ufn_CalculateFutureValue(SUM(a.Balance), @interestRate, 5) AS 'Balance in 5 years'
FROM Accounts a
JOIN AccountHolders ah ON a.AccountHolderId = ah.Id
WHERE a.Id = @accountId
GROUP BY a.Id, a.AccountHolderId, ah.FirstName, ah.LastName


EXEC usp_CalculateFutureValueForAccount 1, 0.1


-- 13. *Cash in User Games Odd Rows
USE Diablo

GO

CREATE FUNCTION ufn_CashInUsersGames (@gameName NVARCHAR(50))
RETURNS TABLE
AS
RETURN	
	SELECT
	SUM(Cash) AS 'SumCash'
	FROM (
		SELECT
		g.[Name],
		ug.Cash,
		ROW_NUMBER() OVER(PARTITION BY g.[Name] ORDER BY ug.Cash DESC) AS 'RowNumber'
		FROM Games g
		JOIN UsersGames ug ON g.Id = ug.GameId) AS sub_1
	WHERE [Name] = @gameName AND RowNumber % 2 <> 0

GO

SELECT * FROM  dbo.ufn_CashInUsersGames('Love in a mist')
