USE TableRelations
GO

-- 3. Many-To-Many Relationship
CREATE TABLE Students (
	StudentID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Student PRIMARY KEY (StudentID)
)

CREATE TABLE Exams (
	ExamID INT,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_Exam PRIMARY KEY (ExamID)
)

CREATE TABLE StudentsExams (
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID) NOT NULL
	CONSTRAINT PK_StudentExam PRIMARY KEY (StudentID, ExamID)
)

INSERT INTO Exams (ExamID, [Name])
VALUES
(101, 'SpringMVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');


INSERT INTO Students ([Name])
VALUES
('Mila'),
('Toni'),
('Ron');

INSERT INTO StudentsExams (StudentID, ExamID)
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);
