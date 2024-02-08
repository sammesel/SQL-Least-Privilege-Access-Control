--  https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-configure-transact-sql?view=sql-server-ver16#permissions
/*******************************************************************
Query Store access to sp_query_store_force_plan, demo solution
Accompanying article: Using Query Store with least privileges instead of db_owner to archive Separation of Duties

Schema Preparation script

Original script: 07/24/2019 Andreas Wolter, Microsoft

Applies to: SQL Server, Azure SQL Database, Azure SQL Database Managed Instance

*******************************************************************/

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE [master]
GO

-- CREATE LOGIN
CREATE LOGIN [login_internal_principal_spconfigure] 
	WITH PASSWORD=N'<password-place-holder>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO

-- CREATE user mapping to login
-- Prepare the User to be used for the wrapper procedure
CREATE USER user_internal_principal_spconfigure
	FOR LOGIN [login_internal_principal_spconfigure] 
GO

-- As a best practice use a Role
CREATE ROLE role_internal_principal_spconfigure
GO

-- Add User to role
ALTER ROLE role_internal_principal_spconfigure
	ADD MEMBER user_internal_principal_spconfigure
GO

-- Grant permissions
GRANT
	ALTER SETTINGS
	TO login_internal_principal_spconfigure
GO
