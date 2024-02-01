/*

The ALTER ANY USER permission in SQL Server allows a user to change the default schema of any user1. 
This can cause a user to select data from the wrong table or execute code from the wrong schema. 
The permission also allows a user to create other database users. 
To change the name of a user, the ALTER ANY USER permission is required1.

Learn more:
1. https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-user-transact-sql?view=sql-server-ver16

*/


-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

use master
go
CREATE LOGIN [DBA_with_AlterAnyUser] 
	WITH PASSWORD=N'<password-place-holder>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF

use [SQLSecurityDemoDB]
GO

CREATE USER [DBA_with_AlterAnyUser] FROM LOGIN [DBA_with_AlterAnyUser]
GO
--
-- make sure to eliminate READ access from DBA_with_AlterAnyUser:
-- 
ALTER ROLE [db_denydatareader] ADD MEMBER [DBA_with_AlterAnyUser]
GO
--
-- no need to give db_owner to DBA_with_AlterAnyUser, ALTER ANY USER is enough:
--
--ALTER ROLE [db_owner] ADD MEMBER [DBA_with_AlterAnyUser]
--GO
GRANT ALTER ANY USER to [DBA_with_AlterAnyUser]
GO


-- test access for DBA_with_AlterAnyLogin:
--	start:
	USE Master
	GO
	select user_name(),suser_name()
	EXECUTE AS USER = 'DBA_with_AlterAnyLogin';
	select user_name(),suser_name()

	-- login [DBA_with_AlterAnyLogin] does not have access to SQLSecurityDemoDB database
		-- -- everything in the next block fail
		USE SQLSecurityDemoDB
		-- as [DBA_with_AlterAnyLogin] cannot access SQLSecurityDemoDB database, next requests will fail:
		SELECT * FROM [Production].[Location]
		SELECT * FROM [Production].[Product]
		SELECT * FROM [Production].[ProductCategory]
		SELECT * FROM [Production].[ProductDescription]
		SELECT * FROM [Production].[ProductReview]
		SELECT * FROM [Production].[ScrapReason]
		SELECT * FROM [Production].[UnitMeasure]
		-- does user access objects in other SCHEMAs?
		-- NO
		SELECT * FROM HumanResources.Employee
		SELECT * FROM HumanResources.Department
		SELECT * FROM HumanResources.JobCandidate
		SELECT * FROM HumanResources.vEmployee
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

		-- AS DBA_with_AlterAnyLogin try Removing the UNMASK permission
		-- CAN'T DO IT
		REVOKE UNMASK TO DBA_with_AlterAnyLogin;
		GRANT  UNMASK TO DBA_with_AlterAnyLogin;

		-- CAN the DBA run DBCC SHOWSTATISTICS?
		DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID);
		GO
		DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID) WITH HISTOGRAM;
		GO
		-- CAN DBA run DBCC_SHOWCONTIG?
		DBCC SHOWCONTIG ('Sales.SalesTaxRate');
		GO
		-- CAN DBA run DBCC SHRINKDATABASE?
		DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
		GO
		-- end
	-- login [DBA_with_AlterAnyLogin] does not have access to SQLSecurityDemoDB database

	-- these will fail:
		-- test can DBA_with_AlterAnyUser create a user from a login
		USE [SQLSecurityDemoDB]
		GO
		CREATE USER Mary1 FROM LOGIN Mary1
		GO

	-- -- these will fail -- --
		ALTER ROLE [db_datareader] ADD MEMBER [Mary1]
		GO
		ALTER ROLE [db_datawriter] ADD MEMBER [Mary1]
		GO

	-- -- these will fail -- --
		exec sp_addrolemember db_datareader, Mary1
		GRANT UPDATE ON SCHEMA::Data TO Mary1;

--	END:
-- test access for DBA_with_AlterAnyLogin:

-- revert to SA
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
REVERT;
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-- CLEAN UP
USE SQLSecurityDemoDB
IF EXISTS (SELECT * FROM sys.database_principals WHERE type_desc = 'SQL_User' and Name = 'DBA_with_AlterAnyUser')
	BEGIN
		
		PRINT 'Droping User: DBA_with_AlterAnyUser'
		DROP USER DBA_with_AlterAnyUser;

		use master
		DROP LOGIN DBA_with_AlterAnyUser;
	END

