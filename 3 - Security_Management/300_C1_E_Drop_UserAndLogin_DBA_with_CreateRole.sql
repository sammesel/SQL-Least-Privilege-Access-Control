-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE [SQLSecurityDemoDB]
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

ALTER ROLE [db_securityadmin] DROP MEMBER [DBA_with_CreateRole]
GO
ALTER ROLE [db_denydatareader] DROP MEMBER [DBA_with_AlterAnyUser]
GO
DROP USER [DBA_with_CreateRole] 
GO
use master
go
DROP LOGIN [DBA_with_CreateRole] 
