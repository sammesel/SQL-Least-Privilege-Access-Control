-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
USE SQLSecurityDemoDB
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()

-- as [Login_Test_DBA] cannot use the target database:
-- run script [6004_Create_USER_for_Test_DBA_OnTargetDatabase.sql] that will add that principal into 
--		the target database: SQLSecurityDemoDB

		-- tables with NO masked columns
		SELECT * FROM [Production].[Location]
		SELECT * FROM [Production].[Product]
		SELECT * FROM [Production].[ProductCategory]
		SELECT * FROM [Production].[ProductDescription]
		SELECT * FROM [Production].[ProductReview]
		SELECT * FROM [Production].[ScrapReason]
		SELECT * FROM [Production].[UnitMeasure]
		SELECT * FROM HumanResources.Department
		SELECT * FROM HumanResources.JobCandidate

		-- QUERY Tables with MASKED DATA:
		SELECT TOP (50) AddressID,[AddressLine1],[City],[PostalCode],* FROM [Person].[Address]
		SELECT TOP (50) BusinessEntityID,BirthDate,NationalIDNumber,* FROM HumanResources.Employee
		SELECT TOP (50) [CreditCardID],[CardType],[CardNumber],[ExpMonth],[ExpYear] FROM [Sales].[CreditCard]
		SELECT TOP (10) [BusinessEntityID],[PhoneNumber],[PhoneNumberTypeID] FROM [Person].[PersonPhone]
		SELECT TOP (50) AddressID,[AddressLine2],[City],[PostalCode] FROM [Person].[Address]
		SELECT TOP (50) BusinessEntityID,PasswordHash,PasswordSalt FROM Person.Password
		SELECT TOP (50) BusinessEntityID,LastName,FirstName FROM Person.Person
		SELECT TOP (50) SalesOrderId,AccountNumber FROM Sales.SalesOrderHeader
		SELECT TOP (50) SalesOrderId,CreditCardApprovalCode,CreditCardID,CurrencyRateID FROM Sales.SalesOrderHeader
		SELECT TOP (50) BusinessEntityID,AccountNumber FROM Purchasing.Vendor
		SELECT * FROM Purchasing.Vendor WHERE BusinessEntityID=1596

		-- to be used with new logins, to validate if they have access to these tables:
		SELECT * FROM dbo.ErrorLog
		SELECT * FROM HumanResources.Employee
		SELECT * FROM Person.Address
		SELECT * FROM Person.EmailAddress
		SELECT * FROM Person.Password
		SELECT * FROM Person.Person
		SELECT * FROM Person.PhoneNumberType
		SELECT * FROM Production.ProductReview
		SELECT * FROM Purchasing.Vendor
		SELECT * FROM Sales.CreditCard
		SELECT * FROM Sales.CurrencyRate
		SELECT * FROM Sales.SalesOrderHeader
		SELECT * FROM Sales.SalesTaxRate


		-- try Removing the UNMASK permission to SELF
		-- CAN'T DO IT
		REVOKE UNMASK TO [User_Test_DBA]
		GRANT  UNMASK TO [User_Test_DBA]

		-- CAN [Login_Test_DBA] run DBCC SHOWSTATISTICS?
		DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID);
		GO
		DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID) WITH HISTOGRAM;
		GO
		-- CAN [Login_Test_DBA] run DBCC_SHOWCONTIG?
		DBCC SHOWCONTIG ('Sales.SalesTaxRate');
		GO
		-- CAN [Login_Test_DBA] run DBCC SHRINKDATABASE?
		DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
		GO
		-- end
	-- [Login_Test_DBA] does not have access to SQLSecurityDemoDB database

--	END:
-- test access for [Login_Test_DBA] 
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


USE master
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
-- now test with wrapper code:
execute sp_readerrorlog 
GO
execute master.custom_DBA_tools.up_sp_readerrorlog  
GO
execute master.custom_DBA_tools.up_sp_readerrorlog NULL, 1,'UTC'
GO
execute master.custom_DBA_tools.up_sp_readerrorlog NULL, 1,'process ID is'
GO
-- these will error out on Azure SQL MI/DB due to the infrastructure not making available previous errorlogs
execute master.custom_DBA_tools.up_sp_readerrorlog 2
GO
execute master.custom_DBA_tools.up_sp_readerrorlog 2,1
GO
execute master.custom_DBA_tools.up_sp_readerrorlog 2,1,'process ID is'
GO
-- recycling errorlog
-- this will not work on Azure SQL MI / DB
exec sp_cycle_errorlog
GO

-->>> NEEDS REVIEW <<<---
exec master.custom_DBA_tools.up_sp_cycle_errorlog
GO
-->>> NEEDS REVIEW <<<---


-- tests
EXEC master.custom_DBA_tools.up_sp_readerrorlog
GO