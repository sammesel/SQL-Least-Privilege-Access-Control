-- ================================================================================= --
-- LOGIN as:		DBA_for_BACKUP
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
go
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- can this DBA read from any objects?
	-- does user have access to objects in the HumanResources SCHEMA?
	-- NO
	SELECT * FROM HumanResources.Employee
	SELECT * FROM HumanResources.Department
	SELECT * FROM HumanResources.JobCandidate
	SELECT * FROM HumanResources.vEmployee
	--
	-- does user have access to objects in other SCHEMAs?
	-- NO
	SELECT * FROM [Production].[Location]
	SELECT * FROM [Production].[Product]
	SELECT * FROM [Production].[ProductCategory]
	SELECT * FROM [Production].[ProductDescription]
	SELECT * FROM [Production].[ProductReview]
	SELECT * FROM [Production].[ScrapReason]
	SELECT * FROM [Production].[UnitMeasure]
	SELECT * FROM Person.Address
	SELECT * FROM Person.EmailAddress
	SELECT * FROM Person.Password
	SELECT * FROM Person.Person
	SELECT * FROM Person.PhoneNumberType
	SELECT * FROM Purchasing.Vendor
	SELECT * FROM Sales.CreditCard
	SELECT * FROM Sales.CurrencyRate
	SELECT * FROM Sales.SalesOrderHeader
	SELECT * FROM Sales.SalesTaxRate

GO

-- master
use master
go
-- FULL BACKUP 
BACKUP DATABASE [master] TO  DISK = N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\master.bak' -- N'<replace with path to your backup folder>\master.bak' 
	WITH NOFORMAT, 
	NOINIT,  
	NAME = N'master-Full Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10, 
	CHECKSUM
GO

-- USE AdventureWorks2019
-- FULL BACKUP without verification
BACKUP DATABASE [AdventureWorks2019] TO  DISK = N'<replace with path to your backup folder>\AdventureWorks2019_FULL.bak' 
	WITH NOFORMAT, 
	INIT,  
	NAME = N'AdventureWorks2019-Full Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO


-- run script [200_A1_C_create_Enlarged_table_in_AdventureWorks.sql]
-- to CREATE TABLE Sales.SalesOrderHeaderEnlarged
-- then take a differtial backup next


-- AdventureWorks2019
-- DIFFERENTIAL BACKUP without verification
BACKUP DATABASE [AdventureWorks2019] TO  DISK = N'<replace with path to your backup folder>\AdventureWorks2019_diff.bak' 
	WITH  DIFFERENTIAL , 
	NOFORMAT, 
	NOINIT,  
	NAME = N'AdventureWorks2019-Diff Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO

-- run script [200_A1_D_update_Enlarged_table_in_AdventureWorks.sql]
-- then take a TLOG backup next

-- AdventureWorks2019
-- TLOG BACKUP without verification
BACKUP LOG [AdventureWorks2019] TO  DISK = N'<replace with path to your backup folder>\AdventureWorks2019_TLOG.LOG' 
	WITH NOFORMAT, 
	NOINIT,  
	NAME = N'AdventureWorks2019-LOG Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO

-- SHOW contents on Drive/folder used for backup:
-- <replace with path to your backup folder>

-- go to restore operation:
-- demo 11C and 11D
-- SQLSecurityDemoDB
-- FULL BACKUP without verification
BACKUP DATABASE [SQLSecurityDemoDB] TO  DISK = N'<replace with path to your backup folder>\SQLSecurityDemoDB_FULL.bak' 
	WITH NOFORMAT, 
	INIT,  
	NAME = N'SQLSecurityDemoDB-Full Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO


-- SQLSecurityDemoDB
-- DIFFERENTIAL BACKUP without verification
BACKUP DATABASE [SQLSecurityDemoDB] TO  DISK = N'<replace with path to your backup folder>\SQLSecurityDemoDB_DIFF.bak' 
	WITH  DIFFERENTIAL , 
	NOFORMAT, 
	NOINIT,  
	NAME = N'SQLSecurityDemoDB-Diff Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO


-- SQLSecurityDemoDB
-- TLOG BACKUP without verification
BACKUP LOG [SQLSecurityDemoDB] TO  DISK = N'<replace with path to your backup folder>\SQLSecurityDemoDB_TLOG.LOG' 
	WITH NOFORMAT, 
	NOINIT,  
	NAME = N'SQLSecurityDemoDB-LOG Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO
