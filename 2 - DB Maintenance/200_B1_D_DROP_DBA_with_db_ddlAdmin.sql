-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

	-- User 
	USE SQLSecurityDemoDB
	GO


	-- role
	ALTER ROLE role_DBA_With_DB_DDLAdmin
		DROP MEMBER DBA_With_DB_DDLAdmin
	GO

	--  permissions
	ALTER ROLE [db_ddladmin] DROP MEMBER [role_DBA_With_DB_DDLAdmin]
	GO
	ALTER ROLE [db_denydatareader] DROP MEMBER [role_DBA_With_DB_DDLAdmin]
	GO
	REVOKE ALTER ANY SENSITIVITY CLASSIFICATION to [role_DBA_With_DB_DDLAdmin]
	GO

	-- Role
	DROP ROLE role_DBA_With_DB_DDLAdmin
	GO

	--	USER 
	DROP USER DBA_With_DB_DDLAdmin

	-- LOGIN
	DROP LOGIN [DBA_With_DB_DDLAdmin] 
