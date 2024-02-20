----------------------------------------------------------
-- LOGIN as		sa
-- use password: '<P@ssw0rd-Pl@c3-H0ld3r>'
----------------------------------------------------------
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO


-- script [300_B1_A_CREATE_DBA_with_AlterAnyUser.sql]
	-- succeeds as it expects a LOGIN 
	GRANT ALTER ANY USER to [role_DBA_master]
	GO

-- script [300_C1_A_CREATE_DBA_with._CreateRole.sql]
	ALTER ROLE [db_securityadmin] ADD MEMBER [role_DBA_master]
	GO
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'server_role_DBA_master')
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'role_DBA_master')
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'Login_Test_DBA')
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'user_Test_DBA')

	ALTER ROLE [db_securityadmin] ADD MEMBER [user_Test_DBA]
	GO
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'server_role_DBA_master')
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'role_DBA_master')
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'Login_Test_DBA')
	SELECT IS_SRVROLEMEMBER ('db_securityadmin', 'user_Test_DBA')

	-- 
	SELECT IS_ROLEMEMBER ('db_datareader', 'user_Test_DBA')
	SELECT IS_ROLEMEMBER ('db_securityadmin', 'user_Test_DBA')


-- users of the server-role db_securityadmin	
SELECT 
	L.name AS LoginName, R.name AS RoleName
FROM 
	sys.server_role_members RM
	JOIN sys.server_principals L 
		ON RM.member_principal_id = L.principal_id
	JOIN sys.server_principals R 
		ON RM.role_principal_id = R.principal_id
WHERE 
	R.name = 'db_securityadmin'

-- users of the database-role db_securityadmin
SELECT	
	U.name AS UserName, R.name AS RoleName
FROM 
	sys.database_role_members RM
	JOIN sys.database_principals U 
		ON RM.member_principal_id = U.principal_id
	JOIN sys.database_principals R 
		ON RM.role_principal_id = R.principal_id
WHERE 
	R.name = 'db_securityadmin'



-- does the 'user_test_dba' have permissions to add a user into db_datareader?
-- YES if the results below show db_owner or db_securityadmin
EXEC sp_helpuser 'user_test_dba'


-- use this section of the script to create LOGINs for Test_DBA to use 
USE master
go
-- create login with password
CREATE LOGIN UserMary1 WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>',
	CHECK_EXPIRATION=OFF, 	
	CHECK_POLICY=OFF;
GO
CREATE LOGIN UserMary2 WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>', 	
	CHECK_POLICY=OFF,
    CHECK_EXPIRATION = OFF;
GO
-- create login with password
CREATE LOGIN UserMary3 WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>',
	CHECK_EXPIRATION=OFF, 	
	CHECK_POLICY=OFF;
GO
-- create login with password
CREATE LOGIN UserJohn1 WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>',
	CHECK_EXPIRATION=OFF, 	
	CHECK_POLICY=OFF;
GO

GO
CREATE LOGIN UserJohn2 WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>',
	CHECK_EXPIRATION=OFF, 	
	CHECK_POLICY=OFF;
GO

-- create a login from a Windows domain account
-- CREATE LOGIN [<domainName>\<login_name>] FROM WINDOWS;
-- GO

-- change password
-- https://passwordsgenerator.net/
ALTER LOGIN UserMary1 WITH PASSWORD = '<P@ssw0rd-Pl@c3-H0ld3r>';

-- logins for demo 300_C1* (Roles)
CREATE LOGIN HR_Manager			WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN SalesManager		WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN SalesPerson		WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN OperationsManager	WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>', CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO




-- before cleaning-up these logins, execute scripts 300_B1* to validate creating USERs with these LOGINs
--		300_B1_A
--		300_B1_B
--		300_B1_C
--		300_B1_D



-- drop logins
DROP LOGIN UserMary1;  
DROP LOGIN UserMary2;  
DROP LOGIN UserMary333333;  
--
DROP LOGIN UserJohn1;
DROP LOGIN UserJohn2;
GO



-- before cleaning-up these logins, you need to perform scripts:
--		300_B1_A
--		300_B1_B
--		300_B1_C
--		300_B1_D


-- clean up
DROP LOGIN HR_Manager			
DROP LOGIN SalesManager		
DROP LOGIN SalesPerson		
DROP LOGIN OperationsManager	
