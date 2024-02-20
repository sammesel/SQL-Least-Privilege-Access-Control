-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

	-- CAN DBA_for_DBCC run DBCC SHOWSTATISTICS?
	-- yes
	DBCC SHOW_STATISTICS ("HumanResources.Employee", PK_Employee_BusinessEntityID);
	GO
	DBCC SHOW_STATISTICS ("HumanResources.Employee", PK_Employee_BusinessEntityID) WITH HISTOGRAM;
	GO
	-- CAN DBA_for_DBCC run DBCC_SHOWCONTIG?
	-- YES
	DBCC SHOWCONTIG ('HumanResources.Employee');
	GO
	-- CAN DBA_for_DBCC run DBCC SHRINKDATABASE?
	-- NO
	DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
	GO


-- execute SPs created previously
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 70)'
EXECUTE sp_DBCC_statement @cmd
GO

EXECUTE AS USER = '[user_Test_DBA]'
go
CREATE PROCEDURE #xploit AS ALTER ROLE db_owner ADD MEMBER [user_Test_DBA]
go
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHOWCONTIG (''HumanResources.Employee'');'
EXEC sp_DBCC_statement @cmd 
DROP PROCEDURE #xploit
SELECT is_member('db_owner') AS is_dbowner
go
REVERT


-- handling two single quote
-- WITH semicolon --> triggers SQL INJECTION validation
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHOWCONTIG (''HumanResources.Employee'');'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_statement @cmd
GO
-- handling two single quote
-- WITHOUT semicolon --> 
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHOWCONTIG (''HumanResources.Employee'')'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_statement @cmd
GO
	
-- will fail due to ;
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_statement @cmd
GO
-- will succeed
declare @cmd varchar(2000)
SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_statement @cmd
GO

-- test with SQL Injection
-- will fail
declare @cmd varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF); DROP TABLE X;'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_statement @cmd 
GO

-- will succeed
declare @cmd varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- test rebuild index: invalid table
-- will fail
declare @cmd varchar(2000)
SET @cmd = 'DBREINDEX (''HumanResources.Employee_dont_exist'', PK_Employee_BusinessEntityID, 80)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO
-- test rebuild index: valid table
-- will succeed
declare @cmd varchar(2000)
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', PK_Employee_BusinessEntityID, 80)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO
-- test rebuild index: valid table/index
-- all will succeed
declare @cmd varchar(2000)
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', PK_Employee_BusinessEntityID, 80)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', AK_Employee_LoginID, 80)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', AK_Employee_NationalIDNumber, 80)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
SET @cmd = 'DBREINDEX (''HumanResources.Employee'', IX_Employee_OrganizationLevel_OrganizationNode, 80)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

DBCC DBREINDEX ('HumanResources.Employee', PK_Employee_BusinessEntityID, 80)

-- TESTs
-- FAIL DUE TO SQL Injection detected
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF); DROP TABLE X;'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- PASS
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- test REBUILD index 
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'DBREINDEX (' + char(39) + 'HumanResources.Employee' + char(39) + ', PK_Employee_BusinessEntityID, 80)'
PRINT @cmd
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

-- test index defrag
declare @cmd varchar(2000)
declare @prm varchar(2000)
SET @cmd = 'INDEXDEFRAG (SQLSecurityDemoDB, ''HumanResources.Employee'', PK_Employee_BusinessEntityID)'
EXECUTE master.custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs @cmd 
GO

