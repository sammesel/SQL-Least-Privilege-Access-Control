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
ALTER ROLE [db_backupoperator] DROP MEMBER [DBA_for_BACKUP]
GO
DROP USER [DBA_for_BACKUP] 
GO
USE AdventureWorks2019
GO
ALTER ROLE [db_backupoperator] DROP MEMBER [DBA_for_BACKUP]
GO
DROP USER [DBA_for_BACKUP] 
GO
USE [master]
GO
ALTER ROLE [db_backupoperator] DROP MEMBER [DBA_for_BACKUP]
GO
DROP USER [DBA_for_BACKUP] 
GO
DROP LOGIN [DBA_for_BACKUP]
GO

