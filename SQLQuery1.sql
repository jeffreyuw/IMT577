USE DestinationSystem

SELECT * FROM dbo.StageChannel
SELECT * FROM dbo.dimChannel
SELECT * FROm dbo.DimDate

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'StageChannel')
BEGIN
	DROP TABLE dbo.StageChannel;
END
GO

CREATE TABLE [dbo].[StageChannel] (
    [ChannelID] int,
    [ChannelCategoryID] int,
    [Channel] nvarchar(50),
    [CreatedDate] datetime,
    [CreatedBy] nvarchar(255),
    [ModifiedDate] datetime,
    [ModifiedBy] nvarchar(255)
)
GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	DROP TABLE  dbo.dimChannel;
END
GO

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	CREATE TABLE dbo.dimChannel
	(
	dimChannelKey INT IDENTITY(1,1) CONSTRAINT PK_dimChannel PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimSourceChannelID INT NOT NUll, --Natural Key
	dimSourceCategoryID INT NOT NUll, --Natural Key
	dimChannelCategoryName VARCHAR(50) NOT NULL,
	dimChannelName VARCHAR(50) NOT NULL
	);
END
GO

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimChannel')
BEGIN
	-- ====================================
	-- Load dimChannel table
	-- ====================================

	INSERT INTO dbo.dimChannel
	(
	dimSourceChannelID
	,dimSourceCategoryID
	,dimChannelCategoryName
	,dimChannelName
	)
	SELECT
	dbo.StageChannel.ChannelID AS dimSourceChannelID
	,dbo.StageChannel.ChannelCategoryID AS dimSourceChannelCategory
	,dbo.StageChannelCategory.ChannelCategory AS dimCategoryName
	,dbo.StageChannel.Channel AS dimChannelName

	FROM StageChannel
	INNER JOIN StageChannelcategory
	ON StageChannel.ChannelCategoryID = StageChannelCategory.ChannelCategoryID;
END
GO

-- =============================
-- Begin load of unknown member
-- =============================

SET IDENTITY_INSERT dbo.dimChannel ON;

INSERT INTO dbo.dimChannel
(
dimChannelID
,dimSourceChannelID
,dimSourceCategoryID
,dimChannelCategoryName
,dimChannelName
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

--==========================
-- CREATE dimLocation TABLE
--==========================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimLocation')
BEGIN
	DROP TABLE dbo.dimLocation;
END
GO

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
	CREATE TABLE dbo.dimLocation
	(
	dimLocationKey INT IDENTITY(1,1) CONSTRAINT PK_dimLocation PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimAddress NVARCHAR(255) NOT NUll, --Natural Key
	dimCity NVARCHAR(255) NOT NUll, --Natural Key
	dimPostalCode NVARCHAR(255) NOT NULL,
	dimStateProvince NVARCHAR(255) NOT NULL,
	dimCountry NVARCHAR(255) NOT NULL
	);
END
GO

INSERT INTO dbo.dimLocation
(
dimAddress
,dimCity
,dimPostalCode
,dimStateProvince
,dimCountry
SELECT

);
GO

--==========================
--CREATE dimReseller Table
--==========================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
	DROP TABLE dbo.dimReseller;
END
GO

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimReseller')
BEGIN
	CREATE TABLE dbo.dimReseller
	(
	dimResellerKey INT IDENTITY(1,1) CONSTRAINT PK_dimReseller PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	-- diable this until dimLocaiton exists
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