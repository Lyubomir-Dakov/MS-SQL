-- 8
CREATE TABLE Users(
	Id INT IDENTITY NOT NULL PRIMARY KEY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),
	LastLoginTime DATETIME2,
	IsDeleted BIT
);

INSERT INTO Users
VALUES
('bold', 'igrach123', NULL, NULL, 'true'),
('meme', 'igrach123', NULL, NULL, 'false'),
('jojo', 'igrach123', NULL, NULL, 'true'),
('xaxa', 'igrach123', NULL, NULL, 'false'),
('jihi', 'igrach123', NULL, NULL, 'true');



-- 9
ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC079A06A0B0;

ALTER TABLE Users
ADD CONSTRAINT PK_User PRIMARY KEY (Id, Username);

-- 10
ALTER TABLE Users
ADD CHECK (LEN(Password)>= 5);

-- 11
ALTER TABLE Users
ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime;

-- 12
ALTER TABLE Users
DROP CONSTRAINT PK_User;

ALTER TABLE Users
ADD CONSTRAINT PK_User PRIMARY KEY (Id);

ALTER TABLE Users
ADD CHECK (LEN(Username) >= 3);

