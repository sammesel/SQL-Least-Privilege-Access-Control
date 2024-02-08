-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE master
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- Drop USER
DROP USER [user_internal_principal_spconfigure]
GO

-- Drop LOGIN
USE [master]
GO
-- Add User to role
ALTER ROLE role_internal_principal_spconfigure
	DROP MEMBER user_internal_principal_spconfigure
GO
DROP ROLE [role_internal_principal_spconfigure]
GO
DROP LOGIN [login_internal_principal_spconfigure]
GO
