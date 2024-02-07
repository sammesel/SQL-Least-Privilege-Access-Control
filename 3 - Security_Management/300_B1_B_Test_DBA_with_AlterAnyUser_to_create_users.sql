-- https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addrolemember-transact-sql?view=sql-server-ver16


-- ================================================================================= --
-- LOGIN as:		DBA_with_AlterAnyUser
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- test access 'DBA_with_AlterAnyUser'

-- START:

-- -- SELECT will fail: start
	-- does user access objects in the HumanResources SCHEMA?
	-- no
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
-- -- SELECT will fail: end

-- -- modify UNMASK permission will fail: start
	-- -- REVOKE GRANT UNMASK will fail
	REVOKE UNMASK TO DBA_with_AlterAnyUser;
	GRANT  UNMASK TO DBA_with_AlterAnyUser;
-- -- modify UNMASK permission will fail: end


-- -- execute DBCC commands will fail: Start
	-- -- DBCC  will fail
	DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID);
	GO
	DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID) WITH HISTOGRAM;
	GO
	-- DBCC_SHOWCONTIG?
	DBCC SHOWCONTIG ('Sales.SalesTaxRate');
	GO
	-- DBCC SHRINKDATABASE?
	DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
	GO
-- -- execute DBCC commands will fail: end


-- test operating on users
-- these will succeed:
-- test can DBA_with_AlterAnyUser create a user from a login
USE [SQLSecurityDemoDB]
GO
CREATE USER UserMary1 FROM LOGIN UserMary1
GO
CREATE USER UserMary2 FROM LOGIN UserMary2
GO
CREATE USER UserJohn2 FROM LOGIN UserJohn2
go

-- BEFORE DROPPING USERs (UserMary1 , UserMary2 , UserMary3 , UserJohn1 , and UserJohn2 )
-- execute scripts to test these users:
--			300_B1_C
--			300_B1_D
-- 
DROP USER UserMary1;
DROP USER UserMary2;
DROP USER UserMary3;
DROP USER UserJohn1;
DROP USER UserJohn2;


-- logins for demo 03F1, 03F2 (Roles)
USE [SQLSecurityDemoDB]
GO
CREATE USER HR_Manager			FROM LOGIN HR_Manager			
CREATE USER SalesManager		FROM LOGIN SalesManager		
CREATE USER SalesPerson			FROM LOGIN SalesPerson	
CREATE USER OperationsManager	FROM LOGIN OperationsManager

-- BEFORE DROPPING USERs (HR_Manager , SalesManager , SalesPerson , and OperationsManager )
-- execute scripts to test these users:
--			300_B1_C
--			300_B1_D
-- 

-- clean up
USE [SQLSecurityDemoDB]
GO
DROP USER HR_Manager			
DROP USER SalesManager		
DROP USER SalesPerson			
DROP USER OperationsManager	
