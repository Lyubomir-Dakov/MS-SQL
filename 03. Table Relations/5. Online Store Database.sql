-- 5. Online Store Database
CREATE DATABASE OnlineStore;

USE OnlineStore
GO

CREATE TABLE Cities (
	CityID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_City PRIMARY KEY (CityID)	
)

CREATE TABLE Customers (
	CustomerID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	Birthday DATE NOT NULL,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID),
	CONSTRAINT PK_Customer PRIMARY KEY (CustomerID)
)

CREATE TABLE Orders (
	OrderID INT IDENTITY,
	CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
	CONSTRAINT PK_Order PRIMARY KEY (OrderID)
)

CREATE TABLE ItemTypes (
	ItemTypeID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	CONSTRAINT PK_ItemType PRIMARY KEY (ItemTypeID)
)

CREATE TABLE Items (
	ItemID INT IDENTITY,
	[Name] VARCHAR(255) NOT NULL,
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID) NOT NULL,
	CONSTRAINT PK_Item PRIMARY KEY (ItemID)
)

CREATE TABLE OrderItems (
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
	ItemID INT FOREIGN KEY REFERENCES Items(ItemID) NOT NULL,
	CONSTRAINT PK_OrderItem PRIMARY KEY (OrderID, ItemID)
)


