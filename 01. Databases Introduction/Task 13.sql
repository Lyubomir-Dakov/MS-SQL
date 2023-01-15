-- 13
CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors (
	Id INT IDENTITY PRIMARY KEY,
	DirectorName VARCHAR(100) NOT NULL,
	Notes VARCHAR(MAX),
);

CREATE TABLE Genres (
	Id INT IDENTITY PRIMARY KEY,
	GenreName VARCHAR(100) NOT NULL,
	Notes VARCHAR (MAX),
);

CREATE TABLE Categories (
	Id INT IDENTITY PRIMARY KEY,
	CategoryName VARCHAR(100) NOT NULL,
	Notes VARCHAR (MAX),
);

CREATE TABLE Movies (
	Id INT IDENTITY PRIMARY KEY,
	Title VARCHAR (100) NOT NULL,
	DirectorId INT FOREIGN KEY REFERENCES Directors (Id) NOT NULL,
	CopyrightYear INT NOT NULL,
	[Length] INT NOT NULL,
	GenreId INT FOREIGN KEY REFERENCES Genres (Id) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories (Id) NOT NULL,
	Rating INT NOT NULL,
	Notes VARCHAR(MAX),
);

INSERT INTO Directors
VALUES
('Adam', 'Very crazy'),
('Smith', 'Go hard or go home'),
('Peter', NULL),
('Kaval', 'Kuku'),
('Maria', NULL);


INSERT INTO Genres (GenreName)
VALUES
('Action'),
('Horror'),
('Romantic'),
('Thriller'),
('Mistery')

INSERT INTO Categories(CategoryName)
VALUES
('Famoly'),
('Documentary'),
('Animation'),
('Science fiction'),
('Independent')

INSERT INTO Movies
VALUES
('The Shawshank Redemption', 2, 1994, 2, 4, 5, 8, NULL),
('The Godfather', 3, 1972, 5, 4, 3, 7, NULL),
('The Dark Knight', 5, 2008, 2, 1, 3, 10, NULL),
('Pulp Fiction', 4, 1994, 3, 1, 5, 9, NULL),
('Inception', 1, 2010, 3, 3, 4, 8, NULL)


--SELECT * FROM Directors
--SELECT * FROM Genres
--SELECT * FROM Categories
--SELECT * FROM Movies

--DROP TABLE Directors
--DROP TABLE Genres
--DROP TABLE Categories
--DROP TABLE Movies
