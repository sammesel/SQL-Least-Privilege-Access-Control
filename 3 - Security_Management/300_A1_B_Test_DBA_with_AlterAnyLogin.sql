-- ================================================================================= --
-- LOGIN as:		DBA_with_AlterAnyLogin
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-- test access for DBA_with_AlterAnyLogin:
--	start:

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
		-- DBCC_SHOWCONTIG?
		DBCC SHOWCONTIG ('Sales.SalesTaxRate');
		GO
		-- DBCC SHRINKDATABASE?
		DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
		GO
		-- end
	-- login [DBA_with_AlterAnyLogin] does not have access to SQLSecurityDemoDB database

--	END:
-- test access for DBA_with_AlterAnyLogin:




-- create login with password
CREATE LOGIN UserMary1 WITH PASSWORD = '<password-place-holder>';
GO
-- create login with password that needs to be changed
CREATE LOGIN UserMary2 WITH PASSWORD = '<password-place-holder>'
    MUST_CHANGE, CHECK_EXPIRATION = ON;
GO
-- create login with password
CREATE LOGIN UserMary3 WITH PASSWORD = '<password-place-holder>';
GO
-- create login with password
CREATE LOGIN UserJohn1 WITH PASSWORD = '<password-place-holder>';
GO
CREATE LOGIN UserJohn2 WITH PASSWORD = '<password-place-holder>';
GO

-- create a login from a Windows domain account
-- CREATE LOGIN [<domainName>\<login_name>] FROM WINDOWS;
-- GO


-- enable and disable login
ALTER LOGIN UserMary1 DISABLE;
ALTER LOGIN UserMary1 ENABLE;


-- change password
-- https://passwordsgenerator.net/
ALTER LOGIN UserMary1 WITH PASSWORD = '<password-place-holder>';
ALTER LOGIN UserMary3 WITH PASSWORD = 'uDwf*+zj:~Wxg/)$k5`vR7';
ALTER LOGIN UserMary3 WITH PASSWORD = 'A4L7]xwD}&5G!2f?K@)^ng';
ALTER LOGIN UserMary3 WITH PASSWORD = 'p]&`K!a%S7fb$8#BqwH)X<';
ALTER LOGIN UserMary3 WITH PASSWORD = 'F&92u_s.?%hH~C4zA`,^+5';
ALTER LOGIN UserMary3 WITH PASSWORD = 'vmS28^4.(XNdM/U3?Y"5&n';
ALTER LOGIN UserMary3 WITH PASSWORD = '<password-place-holder>';

-- change login name
ALTER LOGIN UserMary3 WITH NAME = UserMary333;

-- unlocking a login
ALTER LOGIN [UserMary1] WITH PASSWORD = '<password-place-holder>' UNLOCK ;
GO

-- before cleaning-up these logins, execute scripts 300_B* to validate creating USERs
--		300_B1_A
--		300_B1_B
--		300_B1_C
--		300_B1_D



-- drop login
DROP LOGIN UserMary1;  
DROP LOGIN UserMary2;  
DROP LOGIN UserMary333333;  
--
DROP LOGIN UserJohn1;
DROP LOGIN UserJohn2;
GO


-- logins for demo 03F1, 03F2 (Roles)
CREATE LOGIN HR_Manager			WITH PASSWORD=N'<password-place-holder>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
CREATE LOGIN SalesManager		WITH PASSWORD=N'<password-place-holder>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
CREATE LOGIN SalesPerson		WITH PASSWORD=N'<password-place-holder>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
CREATE LOGIN OperationsManager	WITH PASSWORD=N'<password-place-holder>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

-- before cleaning-up these logins, you need to perform scripts:
--		300_B1_A
--		300_B1_B
--		300_B1_C
--		300_B1_D


-- clean up
DROP LOGIN HR_Manager			
DROP LOGIN SalesManager		
DROP LOGIN SalesPerson		
DROP LOGIN OperationsManager	
