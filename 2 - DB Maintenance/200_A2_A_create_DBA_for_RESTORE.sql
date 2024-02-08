-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

USE [master]
GO
CREATE LOGIN [DBA_for_RESTORE] WITH PASSWORD=N'<password-place-holder>', 
	DEFAULT_DATABASE=[master], 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF
GO
CREATE USER [DBA_for_RESTORE] FOR LOGIN [DBA_for_RESTORE] 
GO
use [master]
GO
GRANT CREATE ANY DATABASE TO [DBA_for_RESTORE]; -- https://learn.microsoft.com/en-us/sql/t-sql/statements/create-database-transact-sql?view=sql-server-ver16&tabs=sqlpool#permissions
GO


USE [SQLSecurityDemoDB]
GO
CREATE USER [DBA_for_RESTORE] FOR LOGIN [DBA_for_RESTORE]
GO
USE AdventureWorks2019
GO
CREATE USER [DBA_for_RESTORE] FOR LOGIN [DBA_for_RESTORE]
GO

-- review needed permissions at: https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-transact-sql?view=sql-server-ver16#permissions
-- GRANT Database Permissions: https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-database-permissions-transact-sql?view=sql-server-ver16


