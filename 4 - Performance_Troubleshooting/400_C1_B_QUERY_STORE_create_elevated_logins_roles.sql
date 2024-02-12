-- in Azure SQL Database remove the "USE Database" statements and open a new connection if necessary

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
-- make sure to login as sa
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


	-- Dedicated schema to allow granular permissions and not on whole database or a schema with other objects
	SELECT * FROM SYS.schemas WHERE Name = 'tools_QueryStore'
	GO
	CREATE SCHEMA tools_QueryStore
	GO
	SELECT * FROM SYS.schemas WHERE Name = 'tools_QueryStore'
	GO

---- FOR STATEMENTS WHICH REQUIRE ALTER_DB: start
	SELECT * FROM sys.sysusers WHERE name = 'internal_principal_QueryStore'
	-- Prepare the User to be used for the wrapper procedure
	CREATE USER internal_principal_QueryStore
		WITHOUT LOGIN
	GO

	-- As a best practice use a Role
	CREATE ROLE role_internal_principal_QueryStore
	GO

	-- Add User to role
	ALTER ROLE role_internal_principal_QueryStore
		ADD MEMBER internal_principal_QueryStore
	GO

	-- Grant permissions
	GRANT
		ALTER
		TO role_internal_principal_QueryStore
	GO




