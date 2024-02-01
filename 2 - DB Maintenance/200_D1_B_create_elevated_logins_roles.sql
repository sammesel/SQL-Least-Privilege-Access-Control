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

-- in Azure SQL Database remove the "USE Database" statements and open a new connection if necessary

	-- Dedicated schema to allow granular permissions and not on whole database or a schema with other objects
	SELECT * FROM SYS.schemas WHERE Name = 'dba_tools_DBCC'
	GO
	CREATE SCHEMA dba_tools_DBCC
	GO
	SELECT * FROM SYS.schemas WHERE Name = 'dba_tools_DBCC'
	GO


---- FOR STATEMENTS WHICH REQUIRE DB_OWNER: start
----

	use SQLSecurityDemoDB
	go
	SELECT * FROM sys.sysusers WHERE name = 'internal_principal_DBCC'
	-- Prepare the User to be used for the wrapper procedure
	CREATE USER internal_principal_DBCC
		WITHOUT LOGIN
	GO

	-- As a best practice use a Role
	CREATE ROLE role_internal_principal_DBCC
	GO

	-- Add User to role
	ALTER ROLE role_internal_principal_DBCC
		ADD MEMBER internal_principal_DBCC
	GO

	-- LIST ROLES for DBA_for_DBCC
	SELECT    
		 roles.principal_id							AS RolePrincipalID
		,roles.name									AS RolePrincipalName
		,database_role_members.member_principal_id	AS MemberPrincipalID
		,members.name								AS MemberPrincipalName
	FROM 
		sys.database_role_members AS database_role_members  
		JOIN sys.database_principals AS roles  
			ON database_role_members.role_principal_id = roles.principal_id  
		JOIN sys.database_principals AS members  
			ON database_role_members.member_principal_id = members.principal_id
	WHERE 
		Members.Name = 'internal_principal_DBCC' ;  

	-- Grant permissions
	ALTER ROLE [db_owner] ADD MEMBER [role_internal_principal_DBCC]
	GO
	ALTER ROLE [db_denydatareader] ADD MEMBER [role_internal_principal_DBCC]
	GO

	-- Permissions to view the Query Store catalogue views and other DMVs
	GRANT
		VIEW DATABASE STATE
		TO role_internal_principal_DBCC
	-- Grant Permission to execute the Wrapper procedures via a dedicated Schema to the role
	GRANT
		EXECUTE
		ON SCHEMA::dba_tools_DBCC
		TO role_internal_principal_DBCC
	GRANT
		EXECUTE
		ON SCHEMA::dba_tools_DBCC
		TO DBA_for_DBCC

		
