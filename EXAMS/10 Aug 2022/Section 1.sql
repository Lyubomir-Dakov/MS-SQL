CREATE DATABASE NationalTouristSitesOfBulgaria
GO
USE NationalTouristSitesOfBulgaria
GO

CREATE TABLE Categories (
	Id INT IDENTITY(0, 1) UNIQUE,
	[Name] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Category PRIMARY KEY (Id)
)

CREATE TABLE Locations (
	Id INT IDENTITY(0, 1) UNIQUE,
	[Name] VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50),
	Province VARCHAR(50),
	CONSTRAINT PK_Location PRIMARY KEY (Id)
)

CREATE TABLE Sites (
	Id INT IDENTITY(0, 1) UNIQUE,
	[Name] VARCHAR(100) NOT NULL,
	LocationId INT FOREIGN KEY REFERENCES Locations NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories NOT NULL,
	Establishment VARCHAR(15),
	CONSTRAINT PK_Site PRIMARY KEY (Id)
)

CREATE TABLE Tourists (
	Id INT IDENTITY(0, 1) UNIQUE,
	[Name] VARCHAR(50) NOT NULL,
	Age INT CHECK(Age BETWEEN 0 AND 120) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Reward VARCHAR(20),
	CONSTRAINT PK_Tourist PRIMARY KEY(Id)
)

CREATE TABLE SitesTourists (
	TouristId INT UNIQUE FOREIGN KEY REFERENCES Tourists,
	SiteId INT UNIQUE FOREIGN KEY REFERENCES Sites,
	CONSTRAINT PK_SiteTourist PRIMARY KEY (TouristId, SiteId)
)

CREATE TABLE BonusPrizes (
	Id INT IDENTITY(0, 1) UNIQUE,
	[Name] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_BonusPrice PRIMARY KEY (Id)
)

CREATE TABLE TouristsBonusPrizes (
	TouristId INT UNIQUE FOREIGN KEY REFERENCES Tourists,
	BonusPrizeId INT UNIQUE FOREIGN KEY REFERENCES BonusPrizes,
	CONSTRAINT PK_TouristPrice PRIMARY KEY (TouristId, BonusPrizeId)
)
