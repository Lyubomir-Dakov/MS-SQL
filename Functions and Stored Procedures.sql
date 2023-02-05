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

DROP FUNCTION ufn_IsWordComprised

select * from Employees