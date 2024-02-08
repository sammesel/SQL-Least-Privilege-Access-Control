-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


Use Master
GO
CREATE LOGIN [DBA_for_BACKUP] WITH PASSWORD=N'<password-place-holder>', DEFAULT_DATABASE=[AdventureWorks2019], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE USER [DBA_for_BACKUP] FOR LOGIN [DBA_for_BACKUP] 
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DBA_for_BACKUP]
GO


USE [SQLSecurityDemoDB]
GO
CREATE USER [DBA_for_BACKUP] FOR LOGIN [DBA_for_BACKUP] 
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DBA_for_BACKUP]
GO


USE AdventureWorks2019
GO
CREATE USER [DBA_for_BACKUP] FOR LOGIN [DBA_for_BACKUP]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DBA_for_BACKUP]
GO

