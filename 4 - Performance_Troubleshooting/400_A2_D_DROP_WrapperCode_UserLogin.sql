-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
/*
********* ******** ********* 
********* CLEAN-UP ********* 
********* ******** ********* 
*/ 

USE SQLSecurityDemoDB
GO
DROP USER [user_internal_principal_errorlog] 

USE [master]
GO


/****** Object:  StoredProcedure [tools].[up_sp_configure]    Script Date: 12/21/2023 11:56:48 AM ******/
DROP PROCEDURE IF EXISTS [tools_errorlog].[up_sp_readerrorlog]
DROP PROCEDURE IF EXISTS [tools_errorlog].[up_sp_cycle_errorlog]
DROP PROCEDURE IF EXISTS [tools_errorlog].[up_sp_cycle_agent_errorlog]
GO
/****** Object:  Schema [tools_errorlog]    Script Date: 12/21/2023 12:00:21 PM ******/
DROP SCHEMA [tools_errorlog]
GO

ALTER ROLE [role_internal_principal_errorlog] DROP MEMBER  [user_internal_principal_errorlog]

/****** Object:  User [internal_principal_errorlog]    Script Date: 12/21/2023 11:54:15 AM ******/
DROP USER IF EXISTS [user_internal_principal_errorlog]
GO
/****** Object:  Login [internal_principal_errorlog]    Script Date: 12/21/2023 11:53:51 AM ******/
DROP LOGIN [login_internal_principal_errorlog]
GO
DROP ROLE [role_internal_principal_errorlog]
GO
