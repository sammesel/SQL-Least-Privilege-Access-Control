-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE [master]
GO


/****** Object:  StoredProcedure [tools_sp_configure.].[up_sp_configure]    Script Date: 12/21/2023 11:56:48 AM ******/
DROP PROCEDURE IF EXISTS [tools_sp_configure.].[up_sp_configure]
GO
DROP PROCEDURE IF EXISTS [tools_sp_configure.].[up_sp_configure_option_value]
GO
DROP PROCEDURE IF EXISTS [tools_sp_configure.].[up_sp_configure_show_advanced_options]
GO
DROP PROCEDURE IF EXISTS [tools_sp_configure.].[up_sp_configure_advanced_option_value]
GO
/****** Object:  Schema [tools_sp_configure.]    Script Date: 12/21/2023 12:00:21 PM ******/
DROP SCHEMA [tools_sp_configure.]
GO
/****** Object:  User [internal_principal_spconfigure]    Script Date: 12/21/2023 11:54:15 AM ******/
DROP USER [user_internal_principal_spconfigure]
GO
/****** Object:  Login [internal_principal_spconfigure]    Script Date: 12/21/2023 11:53:51 AM ******/
DROP LOGIN [login_internal_principal_spconfigure]
GO
DROP ROLE [role_internal_principal_spconfigure]
GO
