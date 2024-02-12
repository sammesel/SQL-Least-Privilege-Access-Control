-- ================================================================================= --
-- LOGIN as:		LOGIN_internal_principal_errorlog ????
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-- test SQLSecurityDemoDB database access for login_internal_principal_errorlog:
--	start:

	-- USER [user_internal_principal_errorlog] does not have SELECT into SQLSecurityDemoDB database
		-- -- everything in the next block fail
		USE SQLSecurityDemoDB
		SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
		-- as [user_internal_principal_errorlog] cannot access SQLSecurityDemoDB database, next requests will fail:
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

		-- AS user_internal_principal_errorlog try Removing the UNMASK permission
		-- CAN'T DO IT
		REVOKE UNMASK TO user_internal_principal_errorlog;
		GRANT  UNMASK TO user_internal_principal_errorlog;

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
	-- USER [user_internal_principal_errorlog] does not have access to SQLSecurityDemoDB database

--	END:
-- test access for user_internal_principal_errorlog:
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------


use master
go
-- now test with wrapper code:
execute sp_readerrorlog 
execute tools_errorlog.up_sp_readerrorlog 
execute tools_errorlog.up_sp_readerrorlog NULL, 1,'UTC'
execute tools_errorlog.up_sp_readerrorlog NULL, 1,'process ID is'

-- these will error out on Azure SQL MI/DB due to the infrastructure not making available previous errorlogs
execute tools_errorlog.up_sp_readerrorlog 2
execute tools_errorlog.up_sp_readerrorlog 2,1
execute tools_errorlog.up_sp_readerrorlog 2,1,'process ID is'

-- recycling errorlog
-- this will not work on Azure SQL MI / DB
exec sp_cycle_errorlog
exec tools_errorlog.up_sp_cycle_errorlog



-- tests
EXEC tools_errorlog.up_sp_readerrorlog
