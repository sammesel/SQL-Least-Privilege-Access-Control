-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE [master]
GO

CREATE LOGIN [login_internal_principal_errorlog] 
	WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO

-- Prepare the User to be used for the wrapper procedure
CREATE USER user_internal_principal_errorlog
	FOR LOGIN [login_internal_principal_errorlog] 
GO

-- As a best practice use a Role
CREATE ROLE role_internal_principal_errorlog
GO

-- Add User to role
ALTER ROLE role_internal_principal_errorlog
	ADD MEMBER user_internal_principal_errorlog
GO

USE SQLSecurityDemoDB
GO
CREATE USER [user_internal_principal_errorlog] FROM LOGIN [login_internal_principal_errorlog] 
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [user_internal_principal_errorlog]
GO


-- Grant permissions
USE master
go
-- Grant the user the EXECUTE permission on xp_readerrorlog
GRANT EXECUTE ON xp_readerrorlog TO [user_internal_principal_errorlog];
GRANT EXECUTE ON sp_readerrorlog TO [user_internal_principal_errorlog];

GRANT
	VIEW ANY ERROR LOG
	TO [login_internal_principal_errorlog]
GO



---------------- REMOVE [
---------------- Grant the user the EXECUTE permission on xp_readerrorlog
--------------GRANT EXECUTE ON xp_readerrorlog TO SQLUser;

---------------- Optionally, deny the user other permissions that are not needed
--------------DENY CONNECT SQL TO SQLUser;
--------------DENY ALTER ANY LOGIN TO SQLUser;
---------------- ] REMOVE 

-- Grant permissions
GRANT -- revoke
	CONTROL
	--	TO login_internal_principal_spconfigure
	TO role_internal_principal_errorlog
GO

GRANT
	ALTER
	--	TO login_internal_principal_spconfigure
	TO role_internal_principal_errorlog
GO

--IF (not is_srvrolemember(N'securityadmin') = 1) AND (not HAS_PERMS_BY_NAME(null, null, 'VIEW SERVER STATE') = 1) AND (not HAS_PERMS_BY_NAME(null, null, 'VIEW ANY ERROR LOG') = 1)
GRANT
	VIEW SERVER STATE
	TO [login_internal_principal_errorlog]
GO


--ALTER SERVER ROLE [sysadmin] DROP MEMBER [login_internal_principal_errorlog]
--GO



--ALTER SERVER ROLE [serveradmin] ADD MEMBER [login_internal_principal_errorlog]
--GO
-- lets test is login [login_internal_principal_errorlog] has access to the SQLSecurityDemoDB database objects

