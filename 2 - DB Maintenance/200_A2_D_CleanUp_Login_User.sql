-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

/*
** CLEAN UP
*/
USE [SQLSecurityDemoDB]
GO
DROP USER [DBA_for_RESTORE] 
GO
USE AdventureWorks2019
GO
DROP USER [DBA_for_RESTORE]
GO
USE [master]
GO
DROP USER [DBA_for_RESTORE]
GO
DROP LOGIN [DBA_for_RESTORE]
GO
