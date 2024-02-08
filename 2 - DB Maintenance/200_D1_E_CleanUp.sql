-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- CLEAN UP
-- remove permissions
ALTER ROLE [db_owner] DROP MEMBER [role_internal_principal_DBCC]
GO
ALTER ROLE [db_denydatareader] DROP MEMBER [role_internal_principal_DBCC]
GO

-- REMOVE Permissions to view the Query Store catalogue views and other DMVs
REVOKE
	VIEW DATABASE STATE
	TO role_internal_principal_DBCC
-- Permission to execute the Wrapper procedures via a dedicated Schema to the role
REVOKE
	EXECUTE
	ON SCHEMA::tools_DBCC
	TO role_internal_principal_DBCC
REVOKE
	EXECUTE
	ON SCHEMA::tools_DBCC
	TO DBA_for_DBCC

-- member in role
ALTER ROLE role_internal_principal_DBCC
	DROP MEMBER internal_principal_DBCC
-- drop Role
DROP ROLE role_internal_principal_DBCC
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE type_desc = 'SQL_User' and Name = 'DBA_for_DBCC')
	BEGIN
		PRINT 'Droping User: DBA_for_DBCC'
		DROP USER DBA_for_DBCC;
	END



use master
GO
IF EXISTS (SELECT * FROM sys.database_principals WHERE type_desc = 'SQL_User' and Name = 'DBA_for_DBCC')
	BEGIN
		PRINT 'Droping User: DBA_for_DBCC'
		DROP USER DBA_for_DBCC;
	END

IF EXISTS (SELECT * FROM sys.sql_logins WHERE type_desc = 'SQL_LOGIN' and Name = 'DBA_for_DBCC')
	BEGIN
		PRINT 'Droping Login: DBA_for_DBCC'
		DROP LOGIN DBA_for_DBCC;
	END


USE SQLSecurityDemoDB
GO
-- DROP OBJECTS
DROP PROC IF EXISTS tools_DBCC.up_sp_DBCC_Statement
GO
DROP PROC IF EXISTS tools_DBCC.up_sp_DBCC_Statement_all_DBCCs
GO
-- DROP User be used for the wrapper procedure
USE SQLSecurityDemoDB
GO
DROP USER internal_principal_DBCC
GO


-- DROP SCHEMA
DROP SCHEMA tools_DBCC
