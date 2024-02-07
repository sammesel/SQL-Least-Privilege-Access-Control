-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
-- make sure to login as sa
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- CLEAN UP
USE master
go
SELECT * FROM sys.database_principals WHERE type_desc = 'SQL_User' and Name = 'DBA_with_AlterAnyLogin'
IF EXISTS (SELECT * FROM sys.database_principals WHERE type_desc = 'SQL_User' and Name = 'DBA_with_AlterAnyLogin')
	BEGIN
		PRINT 'Droping User: DBA_with_AlterAnyLogin'
		DROP USER DBA_with_AlterAnyLogin;
		PRINT 'Droping Login: DBA_with_AlterAnyLogin'
		DROP LOGIN DBA_with_AlterAnyLogin;
	END

