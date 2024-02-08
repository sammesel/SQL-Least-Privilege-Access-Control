-- ================================================================================= --
-- LOGIN as:		[DBA_for_DBCC]
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- can this user SELECT from Tables?
	-- does user have access to objects in the Production SCHEMA?
	-- ??
	SELECT * FROM [Production].[Location]
	SELECT * FROM [Production].[Product]
	SELECT * FROM [Production].[ProductCategory]
	SELECT * FROM [Production].[ProductDescription]
	SELECT * FROM [Production].[ProductReview]
	SELECT * FROM [Production].[ScrapReason]
	SELECT * FROM [Production].[UnitMeasure]
	-- does user have access to objects in other SCHEMAs?
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

	-- Can DBA_for_DBCC change UNMASK permission?
	-- CAN'T DO IT
	REVOKE UNMASK TO DBA_for_DBCC;
	GRANT  UNMASK TO DBA_for_DBCC;

	-- CAN DBA_for_DBCC run DBCC SHOWSTATISTICS?
	-- yes
	DBCC SHOW_STATISTICS ("HumanResources.Employee", PK_Employee_BusinessEntityID);
	GO
	DBCC SHOW_STATISTICS ("HumanResources.Employee", PK_Employee_BusinessEntityID) WITH HISTOGRAM;
	GO
	-- CAN DBA_for_DBCC run DBCC_SHOWCONTIG?
	-- NO
	DBCC SHOWCONTIG ('HumanResources.Employee');
	GO
	-- CAN DBA_for_DBCC run DBCC SHRINKDATABASE?
	-- NO
	DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
	GO

-- execute SPs created previously
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 70)'
EXECUTE tools_DBCC.up_sp_DBCC_statement @cmd
GO

-- handling two single quote
-- WITH semicolon --> triggers SQL INJECTION validation
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHOWCONTIG (''HumanResources.Employee'');'
EXECUTE tools_DBCC.up_sp_DBCC_statement @cmd
GO
-- handling two single quote
-- WITHOUT semicolon --> 
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHOWCONTIG (''HumanResources.Employee'')'
EXECUTE tools_DBCC.up_sp_DBCC_statement @cmd
GO
	
-- will fail due to ;
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);'
EXECUTE tools_DBCC.up_sp_DBCC_statement @cmd
GO
-- will succeed
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10)'
EXECUTE tools_DBCC.up_sp_DBCC_statement @cmd
GO

-- test with SQL Injection
-- will fail
declare @cmd varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF); DROP TABLE X;'
EXECUTE tools_DBCC.up_sp_DBCC_statement @cmd 
GO

-- will succeed
declare @cmd varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- test rebuild index: invalid table
-- will fail
declare @cmd varchar(2000)
SET @cmd = 'DBREINDEX (''HumanResources.Employee_dont_exist'', PK_Employee_BusinessEntityID, 80)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO
-- test rebuild index: valid table
-- will succeed
declare @cmd varchar(2000)
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', PK_Employee_BusinessEntityID, 80)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO
-- test rebuild index: valid table/index
-- all will succeed
declare @cmd varchar(2000)
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', PK_Employee_BusinessEntityID, 80)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', AK_Employee_LoginID, 80)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', AK_Employee_NationalIDNumber, 80)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', IX_Employee_OrganizationLevel_OrganizationNode, 80)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO



-- TESTs
-- FAIL DUE TO SQL Injection detected
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF); DROP TABLE X;'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- PASS
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- test REBUILD index 
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'DBREINDEX (' + char(39) + 'HumanResources.Employee' + char(39) + ', PK_Employee_BusinessEntityID, 80)'
PRINT @cmd
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- test index defrag
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'INDEXDEFRAG (SQLSecurityDemoDB, ''HumanResources.Employee'', PK_Employee_BusinessEntityID)'
EXECUTE tools_DBCC.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

