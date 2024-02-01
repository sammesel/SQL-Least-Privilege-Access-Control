-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- CLEAN UP
USE SQLSecurityDemoDB
IF EXISTS (SELECT * FROM sys.database_principals WHERE type_desc = 'SQL_User' and Name = 'DBA_with_AlterAnyUser')
	BEGIN
		
		PRINT 'Droping User: DBA_with_AlterAnyUser'
		DROP USER DBA_with_AlterAnyUser;

		use master
		DROP LOGIN DBA_with_AlterAnyUser;
	END

