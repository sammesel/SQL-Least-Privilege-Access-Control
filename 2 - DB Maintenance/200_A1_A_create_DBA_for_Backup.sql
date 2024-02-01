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
CREATE LOGIN [DBA_for_BACKUP_master] WITH PASSWORD=N'<password-place-holder>', DEFAULT_DATABASE=[AdventureWorks2019], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE USER [DBA_for_BACKUP_master] FOR LOGIN [DBA_for_BACKUP_master] 
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DBA_for_BACKUP_master]
GO


USE [SQLSecurityDemoDB]
GO
CREATE USER [DBA_for_BACKUP_master] FOR LOGIN [DBA_for_BACKUP_master] 
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DBA_for_BACKUP_master]
GO


USE AdventureWorks2019
GO
CREATE USER [DBA_for_BACKUP_master] FOR LOGIN [DBA_for_BACKUP_master]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [DBA_for_BACKUP_master]
GO


-- for next step: make sure to open a new connection using the login: [DBA_for_BACKUP_master]
-- DO demos on files: 
--		200_A1_B_Login_with_DBA_for_BACKUP_and_take_backups.sql
--		200_A1_C_create_Enlarged_table_in_AdventureWorks.sql
--		200_A1_D_update_Enlarged_table_in_AdventureWorks.sql


