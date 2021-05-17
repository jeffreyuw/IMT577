USE DestinationSystem

SELECT * FROM dbo.DimDate
SELECT * FROM dbo.dimLocation
SELECT * FROM dbo.dimChannel
SELECT * FROM dbo.dimProduct
SELECT * FROM dbo.dimReseller
SELECT * FROM dbo.dimStore
SELECT * FROM dbo.dimCustomer

-- ====================================
-- Begin load of unknown member for DimDate
-- ====================================
SET IDENTITY_INSERT dbo.DimDate ON;

INSERT INTO dbo.DimDate
(
DimDateKey
, FullDate
, DayNumberOfWeek
, DayNameOfWeek
, DayNumberOfMonth
, DayNumberOfYear
, WeekdayFlag
, WeekNumberOfYear
, [MonthName]
, MonthNumberOfYear
, CalendarQuarter
, CalendarYear
, CalendarSemester
, CreatedDate
, CreatedBy
, ModifiedDate
, ModifiedBy
)
VALUES
(
-1
, '1999-01-01'
, 99
, 'Unknown'
, 99
, -1
, -1
, 99
, 'Unknown'
, 99
, 99
, -1
, 99
, '1999-01-01'
, 'Unknown'
, '1999-01-01'
, 'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.DimDate OFF;
GO

-- ====================================
-- Delete dimChannel table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	DROP TABLE dbo.dimChannel;
END
GO
-- ====================================
-- Create dimChannel table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	CREATE TABLE dbo.dimChannel
	(
	dimChannelKey INT IDENTITY(1,1) CONSTRAINT PK_dimChannel PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	ChannelID INT NOT NUll, --Natural Key
	ChannelCategoryID INT NOT NUll, --Natural Key
	ChannelName VARCHAR(50) NOT NULL,
	ChannelCategory VARCHAR(50) NOT NULL
	);
END
GO
-- ====================================
-- Load dimChannel table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	INSERT INTO dbo.dimChannel
	(
	ChannelID
	, ChannelCategoryID
	, ChannelName
	, ChannelCategory
	)
	SELECT
	dbo.StageChannel.ChannelID AS ChannelID
	,dbo.StageChannel.ChannelCategoryID AS ChannelCategoryID
	,dbo.StageChannel.Channel AS ChannelName
	,dbo.StageChannelCategory.ChannelCategory AS ChannelCategory

	FROM StageChannel
	INNER JOIN StageChannelCategory
	ON StageChannel.ChannelCategoryID = StageChannelCategory.ChannelCategoryID;
END
GO
-- ====================================
-- Begin load of unknown member for dimChannel
-- ====================================
SET IDENTITY_INSERT dbo.dimChannel ON;

INSERT INTO dbo.dimChannel
(
dimChannelKey
, ChannelID
, ChannelCategoryID
, ChannelName
, ChannelCategory
)
VALUES
(
-1
,-1
,-1
,'Unknown'
,'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimChannel OFF;
GO

-- ====================================
-- Delete dimLocation table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimLocation')
BEGIN
	DROP TABLE dbo.dimLocation;
END
GO
-- ====================================
-- Create dimLocation table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimLocation')
BEGIN
	CREATE TABLE dbo.dimLocation
	(
	dimLocationKey INT IDENTITY(1,1) CONSTRAINT PK_dimLocation PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	[Address] NVARCHAR(255) NOT NULL,
	City NVARCHAR(255) NOT NULL,
	PostalCode NVARCHAR(255) NOT NULL,
	State_Province NVARCHAR(255) NOT NULL,
	Country NVARCHAR(255) NOT NULL
	);
END
GO
-- ====================================
-- Load dimLocation table - IN PROCESS!!!!!!!!
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimLocation')
BEGIN
	-- Load customer addresses
	INSERT INTO dbo.dimLocation
	(
	[Address]
	, City
	, PostalCode
	, State_Province
	, Country
	)
	SELECT
	dbo.StageCustomer.[Address] AS CustStreet
	, dbo.StageCustomer.City AS CustCity
	, dbo.StageCustomer.PostalCode AS CustPC
	, dbo.StageCustomer.StateProvince As CustState
	, dbo.StageCustomer.Country AS CustCountry
	FROM
	dbo.StageCustomer;
	-- Load store addresses
	INSERT INTO dbo.dimLocation
	(
	[Address]
	, City
	, PostalCode
	, State_Province
	, Country
	)
	SELECT
	dbo.StageStore.[Address] AS StoreStreet
	, dbo.StageStore.City AS StoreCity
	, dbo.StageStore.PostalCode AS StorePC
	, dbo.StageStore.StateProvince As StoreState
	, dbo.StageStore.Country AS StoreCountry
	FROM
	dbo.StageStore;
	-- Load reseller addresses
	INSERT INTO dbo.dimLocation
	(
	[Address]
	, City
	, PostalCode
	, State_Province
	, Country
	)
	SELECT
	dbo.StageReseller.[Address] AS ResellStreet
	, dbo.StageReseller.City AS ResellCity
	, dbo.StageReseller.PostalCode AS ResellPC
	, dbo.StageReseller.StateProvince As ResellState
	, dbo.StageReseller.Country AS ResellCountry
	FROM
	dbo.StageReseller;
END
GO
-- ====================================
-- Begin load of unknown member for dimLocation
-- ====================================
SET IDENTITY_INSERT dbo.dimLocation ON;

INSERT INTO dbo.dimLocation
(
dimLocationKey
, [Address]
, City
, PostalCode
, State_Province
, Country
)
VALUES
(
-1
, 'Unknown'
, 'Unknown'
, 'Unknown'
, 'Unknown'
, 'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimLocation OFF;
GO

-- ====================================
-- Delete dimProduct table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	DROP TABLE dbo.dimProduct;
END
GO
-- ====================================
-- Create dimProduct table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	CREATE TABLE dbo.dimProduct
	(
	dimProductKey INT IDENTITY(1,1) CONSTRAINT PK_dimProduct PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	ProductID INT NOT NULL, -- Natural Key
	ProductTypeID INT NOT NULL, -- Natural Key
	ProductCategoryID INT NOT NULL, -- Natural Key
	ProductName NVARCHAR(50) NOT NULL,
	ProductType NVARCHAR(50) NOT NULL,
	ProductCategory NVARCHAR(50) NOT NULL,
	ProductRetailPrice NUMERIC(18,2) NOT NULL,
	ProductWholesalePrice NUMERIC(18,2) NOT NULL,
	ProductCost NUMERIC(18,2) NOT NULL,
	ProductRetailProfit NUMERIC(18,2) NOT NULL,
	ProductWholesaleUnitProfit NUMERIC(18,2) NOT NULL,
	ProductProfitMarginUnitPercent NUMERIC(18,2) NOT NULL
	);
END
GO
-- ====================================
-- Load dimProduct table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	INSERT INTO dbo.dimProduct
	(
	ProductID
	, ProductTypeID
	, ProductCategoryID
	, ProductName
	, ProductType
	, ProductCategory
	, ProductRetailPrice
	, ProductWholesalePrice
	, ProductCost
	, ProductRetailProfit
	, ProductWholesaleUnitProfit
	, ProductProfitMarginUnitPercent
	)
	SELECT
	P.ProductID AS ProdID
	, PT.ProductTypeID AS TypeID
	, PC.ProductCategoryID AS CatID
	, P.Product AS ProdName
	, PT.ProductType AS TypeName
	, PC.ProductCategory AS CatName
	, P.Price AS RetailPrice
	, P.WholesalePrice AS WholesalePrice
	, P.Cost AS Cost
	, P.Price-P.Cost AS RetailProfit
	, P.WholesalePrice-P.Cost AS WholesaleProfit
	, ((P.Price-P.Cost)/P.Price)*100 AS ProfitMargin
	FROM dbo.StageProduct AS P
	INNER JOIN dbo.StageProductType AS PT ON P.ProductTypeID = PT.ProductTypeID
	INNER JOIN dbo.StageProductCategory AS PC ON PT.ProductCategoryID = PC.ProductCategoryID
END
GO
-- ====================================
-- Begin load of unknown member for dimProduct
-- ====================================
SET IDENTITY_INSERT dbo.dimProduct ON;

INSERT INTO dbo.dimProduct
(
dimProductKey
, ProductID
, ProductTypeID
, ProductCategoryID
, ProductName
, ProductType
, ProductCategory
, ProductRetailPrice
, ProductWholesalePrice
, ProductCost
, ProductRetailProfit
, ProductWholesaleUnitProfit
, ProductProfitMarginUnitPercent
)
VALUES
(
-1
, -1
, -1
, -1
, 'Unknown'
, 'Unknown'
, 'Unknown'
, -1.00
, -1.00
, -1.00
, -1.00
, -1.00
, -1.00
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimProduct OFF;
GO

-- ====================================
-- Delete dimReseller table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
	DROP TABLE dbo.dimReseller;
END
GO
-- ====================================
-- Create dimReseller table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
	CREATE TABLE dbo.dimReseller
	(
	dimResellerKey INT IDENTITY(1,1) CONSTRAINT PK_dimReseller PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimLocationKey INT CONSTRAINT FK_ResellerLocation FOREIGN KEY REFERENCES dbo.dimLocation(dimLocationKey) NOT NUll,
	ResellerID NVARCHAR(50) NOT NUll, --Natural Key
	ResellerName NVARCHAR(255) NOT NULL,
	ContactName NVARCHAR(255) NOT NULL,
	PhoneNumber NVARCHAR(255) NOT NULL,
	Email NVARCHAR(255) NOT NULL
	);
END
GO
-- ====================================
-- Load dimReseller table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
	INSERT INTO dbo.dimReseller
	(
	dimLocationKey
	, ResellerID
	, ResellerName
	, ContactName
	, PhoneNumber
	, Email
	)
	SELECT
	L.dimLocationKey AS LocKey
	, CAST(R.ResellerID AS NVARCHAR(50)) AS CustID
	, R.ResellerName AS [Name]
	, R.Contact AS Contact
	, R.PhoneNumber AS Phone
	, R.EmailAddress AS Email
	FROM dbo.StageReseller AS R
	INNER JOIN dbo.dimLocation AS L ON R.[Address] = L.[Address]
	AND R.PostalCode = L.PostalCode; -- future-proofing against duplicates from large tables
END
GO
-- ====================================
-- Begin load of unknown member for dimReseller
-- ====================================
SET IDENTITY_INSERT dbo.dimReseller ON;

INSERT INTO dbo.dimReseller
(
dimResellerKey
, dimLocationKey
, ResellerID
, ResellerName
, ContactName
, PhoneNumber
, Email
)
VALUES
(
-1
, -1
, 'Unknown'
, 'Unknown'
, 'Unknown'
, 'Unknown'
, 'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimReseller OFF;
GO

-- ====================================
-- Delete dimStore table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimStore')
BEGIN
	DROP TABLE dbo.dimStore;
END
GO
-- ====================================
-- Create dimStore table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimStore')
BEGIN
	CREATE TABLE dbo.dimStore
	(
	dimStoreKey INT IDENTITY(1,1) CONSTRAINT PK_dimStore PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimLocationKey INT CONSTRAINT FK_StoreLocation FOREIGN KEY REFERENCES dbo.dimLocation(dimLocationKey) NOT NULL,
	StoreID INT NOT NULL, --Natural Key
	StoreName NVARCHAR(255) NOT NULL,
	StoreNumber INT NOT NULL,
	StoreManager NVARCHAR(255) NOT NULL
	);
END
GO
-- ====================================
-- Load dimStore table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimStore')
BEGIN
	INSERT INTO dbo.dimStore
	(
	dimLocationKey
	, StoreID
	, StoreName
	, StoreNumber
	, StoreManager
	)
	SELECT
	L.dimLocationKey AS LocKey
	, S.StoreID AS StoreID
	, S.City + ' ' + CAST(S.StoreNumber AS nvarchar(10)) AS [Name]
	, S.StoreNumber AS Number
	, S.StoreManager AS Manager
	FROM dbo.StageStore AS S
	INNER JOIN dbo.dimLocation AS L ON S.[Address] = L.[Address]
	AND S.PostalCode = L.PostalCode; -- future-proofing against duplicates from large tables
END
GO
-- ====================================
-- Begin load of unknown member for dimStore
-- ====================================
SET IDENTITY_INSERT dbo.dimStore ON;

INSERT INTO dbo.dimStore
(
dimStoreKey
, dimLocationKey
, StoreID
, StoreName
, StoreNumber
, StoreManager
)
VALUES
(
-1
, -1
, -1
, 'Unknown'
, -1
, 'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimStore OFF;
GO

-- ====================================
-- Delete dimCustomer table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	DROP TABLE dbo.dimCustomer;
END
GO
-- ====================================
-- Create dimCustomer table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	CREATE TABLE dbo.dimCustomer
	(
	dimCustomerKey INT IDENTITY(1,1) CONSTRAINT PK_dimCustomer PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimLocationKey INT CONSTRAINT FK_CustomerLocation FOREIGN KEY REFERENCES dbo.dimLocation(dimLocationKey) NOT NUll,
	CustomerID NVARCHAR(50) NOT NUll, --Natural Key
	CustomerFullName NVARCHAR(255) NOT NULL,
	CustomerFirstName NVARCHAR(255) NOT NULL,
	CustomerLastName NVARCHAR(255) NOT NULL,
	CustomerGender NVARCHAR(1) NOT NULL
	);
END
GO
-- ====================================
-- Load dimCustomer table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	INSERT INTO dbo.dimCustomer
	(
	dimLocationKey
	, CustomerID
	, CustomerFullName
	, CustomerFirstName
	, CustomerLastName
	, CustomerGender
	)
	SELECT
	L.dimLocationKey AS LocKey
	, CAST(C.CustomerID AS NVARCHAR(50)) AS CustID
	, C.FirstName + ' ' + C.LastName AS FullName
	, C.FirstName AS [First]
	, C.LastName AS [Last]
	, C.Gender AS Gender
	FROM dbo.StageCustomer AS C
	INNER JOIN dbo.dimLocation AS L ON C.[Address] = L.[Address]
	AND C.PostalCode = L.PostalCode; -- future-proofing against duplicates from large tables
END
GO

-- ====================================
-- Begin load of unknown member for dimCustomer
-- ====================================
SET IDENTITY_INSERT dbo.dimCustomer ON;

INSERT INTO dbo.dimCustomer
(
dimCustomerKey
, dimLocationKey
, CustomerID
, CustomerFullName
, CustomerFirstName
, CustomerLastName
, CustomerGender
)
VALUES
(
-1
, -1
, 'Unknown'
, 'Unknown'
, 'Unknown'
, 'Unknown'
, '-'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimCustomer OFF;
GO

/*
--==========================
--David's Reseller Table
--==========================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
DBCC CHECKIDENT (dimReseller, RESEED, 1)
    INSERT INTO dbo.dimReseller
    (
    dimLocationKey 
    , ResellerID 
    , ResellerName
    , ContactName
    , PhoneNumber
    , Email
    )
    SELECT 
    dbo.dimLocation.dimLocationKey AS dimLocationKey
    , CAST(dbo.stageReseller.ResellerID AS VARCHAR(50))
    , ResellerName
    , Contact
    , PhoneNumber
    , EmailAddress
    FROM dbo.StageReseller
        INNER JOIN dbo.dimLocation 
            ON StageReseller.Address = dimLocation.Address
            AND StageReseller.PostalCode = dimLocation.PostalCode;
END
GO
*/



-- ====================================
-- Fact tables!!!!
-- ====================================
/*
USE DestinationSystem

SELECT * FROM dbo.DimDate
SELECT * FROM dbo.dimLocation
SELECT * FROM dbo.dimChannel
SELECT * FROM dbo.dimProduct
SELECT * FROM dbo.dimReseller
SELECT * FROM dbo.dimStore
SELECT * FROM dbo.dimCustomer
*/

-- ====================================
-- Delete factSalesActual table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSalesActual')
BEGIN
	DROP TABLE dbo.factSalesActual;
END
GO
-- ====================================
-- Create factSalesActual table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSalesActual')
BEGIN
	CREATE TABLE dbo.factSalesActual
	(
	factSalesActualKey INT IDENTITY(1,1) CONSTRAINT PK_factSalesActual PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimProductKey INT CONSTRAINT FK_SalesActualProduct FOREIGN KEY REFERENCES dbo.dimProduct(dimProductKey) NOT NULL,
	dimStoreKey INT CONSTRAINT FK_SalesActualStore FOREIGN KEY REFERENCES dbo.dimStore(dimStoreKey) NUll,
	dimResellerKey INT CONSTRAINT FK_SalesActualReseller FOREIGN KEY REFERENCES dbo.dimReseller(dimResellerKey) NULL,
	dimCustomerKey INT CONSTRAINT FK_SalesActualCustomer FOREIGN KEY REFERENCES dbo.dimCustomer(dimCustomerKey) NULL,
	dimChannelKey INT CONSTRAINT FK_SalesActualChannel FOREIGN KEY REFERENCES dbo.dimChannel(dimChannelKey) NOT NULL,
	dimSaleDateKey INT CONSTRAINT FK_SalesActualDate FOREIGN KEY REFERENCES dbo.DimDate(dimDateKey) NOT NULL,
	dimLocationKey INT CONSTRAINT FK_SalesActualLocation FOREIGN KEY REFERENCES dbo.dimLocation(dimLocationKey) NOT NULL,
	SalesHeaderID INT NOT NULL, -- Natural Key
	SalesDetailID INT NOT NULL, -- Natural Key
	SaleAmount NUMERIC(18,2) NOT NULL,
	SaleQuantity INT NOT NULL,
	SaleUnitPrice NUMERIC(18,2) NOT NULL,
	SaleExtendedCost NUMERIC(18,2) NOT NULL,
	SaleTotalProfit NUMERIC(18,2) NOT NULL
	);
END
GO
-- ====================================
-- Load factSalesActual table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	INSERT INTO dbo.dimCustomer
	(
	dimLocationKey
	, CustomerID
	, CustomerFullName
	, CustomerFirstName
	, CustomerLastName
	, CustomerGender
	)
	SELECT
	L.dimLocationKey AS LocKey
	, CAST(C.CustomerID AS NVARCHAR(50)) AS CustID
	, C.FirstName + ' ' + C.LastName AS FullName
	, C.FirstName AS [First]
	, C.LastName AS [Last]
	, C.Gender AS Gender
	FROM dbo.StageCustomer AS C
	INNER JOIN dbo.dimLocation AS L ON C.[Address] = L.[Address]
	AND C.PostalCode = L.PostalCode; -- future-proofing against duplicates from large tables
END
GO
SELECT * FROM factSalesActual


-- ====================================
-- Delete factSRCSalesTarget table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSRCSalesTarget')
BEGIN
	DROP TABLE dbo.factSRCSalesTarget;
END
GO
-- ====================================
-- Create factSRCSalesTarget table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factSRCSalesTarget')
BEGIN
	CREATE TABLE dbo.factSRCSalesTarget
	(
	factSalesTarget INT IDENTITY(1,1) CONSTRAINT PK_factSRCSalesTarget PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimStoreKey INT CONSTRAINT FK_SRCSalesTargetStore FOREIGN KEY REFERENCES dbo.dimStore(dimStoreKey) NUll,
	dimResellerKey INT CONSTRAINT FK_SRCSalesTargetReseller FOREIGN KEY REFERENCES dbo.dimReseller(dimResellerKey) NULL,
	dimChannelKey INT CONSTRAINT FK_SRCSalesTargetChannel FOREIGN KEY REFERENCES dbo.dimChannel(dimChannelKey) NOT NULL,
	dimTargetDateKey INT CONSTRAINT FK_SRCSalesTargetDate FOREIGN KEY REFERENCES dbo.DimDate(dimDateKey) NOT NULL,
	SalesTargetAmount NUMERIC(18,2) NOT NULL
	);
END
GO
-- ====================================
-- Load factSRCSalesTarget table
-- ====================================


SELECT * FROM factSRCSalesTarget

-- ====================================
-- Delete factProductSalesTarget table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factProductSalesTarget')
BEGIN
	DROP TABLE dbo.factProductSalesTarget;
END
GO
-- ====================================
-- Create factProductSalesTarget table
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'factProductSalesTarget')
BEGIN
	CREATE TABLE dbo.factProductSalesTarget
	(
	factSalesTargetKey INT IDENTITY(1,1) CONSTRAINT PK_factProductSalesTarget PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimProductKey INT CONSTRAINT FK_ProductSalesTargetProduct FOREIGN KEY REFERENCES dbo.dimProduct(dimProductKey) NOT NULL,
	dimTargetDateKey INT CONSTRAINT FK_ProductSalesTargetDate FOREIGN KEY REFERENCES dbo.DimDate(dimDateKey) NOT NULL,
	ProductTargetSalesQuanitity INT NOT NULL
	);
END
GO
-- ====================================
-- Load factProductSalesTarget table
-- ====================================


SELECT * FROM factProductSalesTarget