-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- in Azure SQL Database remove the "USE Database" statements and open a new connection if necessary

use SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

---- FOR STATEMENTS WHICH REQUIRE DB_DDLAdmin: start
----
	select* from sys.syslogins where name = 'DBA_With_DB_DDLAdmin'
	CREATE LOGIN [DBA_With_DB_DDLAdmin] 
		WITH PASSWORD=N'<password-place-holder>', 
		CHECK_EXPIRATION=OFF, 
		CHECK_POLICY=OFF

	use SQLSecurityDemoDB
	go
	SELECT * FROM sys.sysusers WHERE name = 'DBA_With_DB_DDLAdmin'
	-- Prepare the User to be used for the wrapper procedure
	CREATE USER DBA_With_DB_DDLAdmin
		FROM LOGIN DBA_With_DB_DDLAdmin
	GO
	-- verify added user
	SELECT * FROM sys.sysusers WHERE name = 'DBA_With_DB_DDLAdmin'

	-- As a best practice use a Role
	CREATE ROLE role_DBA_With_DB_DDLAdmin
	GO

	-- Add User to role
	ALTER ROLE role_DBA_With_DB_DDLAdmin
		ADD MEMBER DBA_With_DB_DDLAdmin
	GO

	-- LIST ROLES for DBA_with_DB_DDLAdmin
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
		Members.Name = 'DBA_With_DB_DDLAdmin' ;  

	-- Grant permissions
	ALTER ROLE [db_ddladmin] ADD MEMBER [role_DBA_With_DB_DDLAdmin]
	GO
	ALTER ROLE [db_denydatareader] ADD MEMBER [role_DBA_With_DB_DDLAdmin]
	GO

	--
	-- this permission is to be added only during the test on script: 200_B1_B
	-- 
	-- GRANT ALTER ANY SENSITIVITY CLASSIFICATION to [role_DBA_With_DB_DDLAdmin]
	--
