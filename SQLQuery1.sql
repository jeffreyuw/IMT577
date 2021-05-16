USE DestinationSystem

SELECT * FROM dbo.StageChannel
SELECT * FROM dbo.dimChannel
SELECT * FROm dbo.DimDate


-- ====================================
-- Delete dimChannel table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	DROP TABLE  dbo.dimChannel;
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
	StateProvince NVARCHAR(255) NOT NULL,
	Country NVARCHAR(255) NOT NULL
	);
END
GO
-- ====================================
-- Load dimLocation table - IN PROCESS!!!!!!!!
-- ====================================
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimLocation')
BEGIN
INSERT INTO dbo.dimLocation
(
dimAddress
,dimCity
,dimPostalCode
,dimStateProvince
,dimCountry
SELECT

);
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
, StateProvince
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
	ProductRetailUnitProfit NUMERIC(18,2) NOT NULL,
	ProductWholesaleUnitProfit NUMERIC(18,2) NOT NULL,
	ProductProfitMarginUnitPercent NUMERIC(18,2) NOT NULL
	);
END
GO
-- ====================================
-- Load dimProduct table - IN PROCESS!!!!!!!!
-- ====================================

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
, ProductRetailUnitProfit
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
	-- diable this until dimReller exists
	-- dimLocationKey INT CONSTRAINT FK_ResellerLocation FOREIGN KEY REFERENCES dbo.dimLocation(dimLocationKey) NOT NUll,
	-- once dimLocation exists, remove the next line
	dimLocationKey INT NOT NULL,
	ResellerID NVARCHAR(50) NOT NUll, --Natural Key
	ResellerName NVARCHAR(255) NOT NULL,
	ContactName NVARCHAR(255) NOT NULL,
	PhoneNumber NVARCHAR(255) NOT NULL,
	Email NVARCHAR(255) NOT NULL
	);
END
GO
-- ====================================
-- Load dimReseller table - IN PROCESS!!!!!!!!
-- ====================================

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
	-- diable this until dimReseller exists
	-- dimLocationKey INT CONSTRAINT FK_StoreLocation FOREIGN KEY REFERENCES dbo.dimLocation(dimLocationKey) NOT NUll,
	-- once dimLocation exists, remove the next line
	dimLocationKey INT NOT NULL,
	StoreID INT NOT NUll, --Natural Key
	StoreName NVARCHAR(255) NOT NULL,
	StoreNumber INT NOT NULL,
	StoreManager NVARCHAR(255) NOT NULL
	);
END
GO





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
            AND StageReseller.PostalCode = dimLocation.PostalCode
        
    ;