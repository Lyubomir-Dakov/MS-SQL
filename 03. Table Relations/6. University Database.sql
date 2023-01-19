-- 6. University Database
CREATE DATABASE University

USE University
GO

CREATE TABLE Subjects (
	SubjectID INT IDENTITY,
	SubjectsName VARCHAR(255),
	CONSTRAINT PK_Subject PRIMARY KEY (SubjectID)
)

CREATE TABLE Majors (
	MajorID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Major PRIMARY KEY (MajorID)
)

CREATE TABLE Students (
	StudentID INT IDENTITY,
	StudentNumber INT NOT NULL,
	StudentName VARCHAR(255) NOT NULL,
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID),
	CONSTRAINT PK_Student PRIMARY KEY (StudentID)
)

CREATE TABLE Agenda (
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID) NOT NULL,
	CONSTRAINT PK_Agenda PRIMARY KEY (StudentID, SubjectID)
)

CREATE TABLE Payments (
	PaymentID INT IDENTITY,
	PaymentDate DATE NOT NULL,
	PaymentAmount INT NOT NULL,
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
	CONSTRAINT PK_Payment PRIMARY KEY (PaymentID)
)