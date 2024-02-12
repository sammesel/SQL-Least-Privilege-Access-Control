/*******************************************************************
Query Store access to sp_query_store_force_plan, demo solution
Accompanying article: Using Query Store with least privileges instead of db_owner to archive Separation of Duties

Permissions script

07/24/2019 Andreas Wolter, Microsoft

Applies to: SQL Server, Azure SQL Database, Azure SQL Database Managed Instance

*******************************************************************/

-- in Azure SQL Database remove the "USE Database" statements and open a new connection if necessary
--USE SQLSecurityDemoDB
--GO

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- Azure SQL Database
-- Creating a contained User for Demo and Testing purposes
	------CREATE USER [DBA_for_QueryStore]
	------	WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>'	-- CHANGE in your environment!
	------GO

-- SQL Server and Azure SQL Database Managed Instance
-- Creating a User based on a Login for Demo and Testing purposes
	USE master
	GO
	CREATE LOGIN [DBA_for_QueryStore]
		WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>',	-- CHANGE in your environment!
		CHECK_EXPIRATION=OFF, 
		CHECK_POLICY=OFF
	GO
	CREATE USER [DBA_for_QueryStore]
		FROM LOGIN [DBA_for_QueryStore]
	GO
	USE SQLSecurityDemoDB
	GO
	CREATE USER [DBA_for_QueryStore]
		FROM LOGIN [DBA_for_QueryStore]
	GO
	--	GRANT ALTER ANY SCHEMA TO DBA_for_QueryStore;
	--	GRANT ALTER ON SCHEMA::Data TO DBA_for_QueryStore;
	-->>GRANT SELECT ON SCHEMA::Data TO DBA_for_QueryStore;

-- Create role as best practice even for our tests
use SQLSecurityDemoDB
GO
CREATE ROLE Role_Tuning_QueryStore
GO

ALTER ROLE Role_Tuning_QueryStore
	ADD MEMBER [DBA_for_QueryStore]
GO

-- Permissions to view the Query Store catalogue views and other DMVs
GRANT
	VIEW DATABASE STATE
	TO Role_Tuning_QueryStore
	
-- Dedicated schema to allow granular permissions and not on whole database or a schema with other objects
-- CHECK the existence of a 'tools_QueryStore' schema
SELECT * FROM SYS.schemas WHERE Name = 'tools_QueryStore'
CREATE SCHEMA tools_QueryStore
GO
SELECT * FROM SYS.schemas WHERE Name = 'tools_QueryStore'

-- Grant Permission to execute the Wrapper procedures via a dedicated Schema to the role
GRANT
	EXECUTE
	ON SCHEMA::tools_QueryStore
	TO Role_Tuning_QueryStore
-- needed for special proc in decicated schema

