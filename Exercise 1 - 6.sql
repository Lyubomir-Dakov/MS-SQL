-- 1
CREATE DATABASE Minions

-- 2
CREATE TABLE Minions (
	Id INT NOT NULL,
	[Name] VARCHAR (100),
	Age INT,
	CONSTRAINT Id PRIMARY KEY (Id)
);

CREATE TABLE Towns (
	Id INT NOT NULL,
	[Name] VARCHAR (100),
	CONSTRAINT TownId PRIMARY KEY (Id)
)

-- 3
ALTER TABLE Minions
	ADD TownId INT FOREIGN KEY (TownId) REFERENCES Towns(Id);


-- 4
INSERT INTO Towns 
VALUES 
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')


INSERT INTO Minions
VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Stewart', NULL, 2)


-- 5
DELETE FROM Minions;

-- 6
DROP TABLE Minions;
DROP TABLE Towns;




--SELECT * FROM Minions;
--SELECT * FROM Towns;


