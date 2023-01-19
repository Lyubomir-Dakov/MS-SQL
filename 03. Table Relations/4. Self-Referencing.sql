-- 4. Self-Referencing
CREATE TABLE Teachers (
	TeacherID INT,
	[Name] VARCHAR(255) NOT NULL,
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
	CONSTRAINT PK_Teacher PRIMARY KEY (TeacherID),
)

INSERT INTO Teachers (TeacherID, [Name], ManagerID)
VALUES
(101, 'John', NULL),
(102, 'Maya', 106),
(103, 'Silvia', 106),
(104, 'Ted', 105),
(105, 'Mark', 101),
(106, 'Greta', 101);