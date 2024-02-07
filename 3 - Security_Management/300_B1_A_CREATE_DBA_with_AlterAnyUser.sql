/*

The ALTER ANY USER permission in SQL Server allows a user to change the default schema of any user1. 
This can cause a user to select data from the wrong table or execute code from the wrong schema. 
The permission also allows a user to create other database users. 
To change the name of a user, the ALTER ANY USER permission is required1.

Learn more:
1. https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-user-transact-sql?view=sql-server-ver16

*/


-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

use master
go
CREATE LOGIN [DBA_with_AlterAnyUser] 
	WITH PASSWORD=N'<password-place-holder>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF

use [SQLSecurityDemoDB]
GO

CREATE USER [DBA_with_AlterAnyUser] FROM LOGIN [DBA_with_AlterAnyUser]
GO
--
-- make sure to eliminate READ access from DBA_with_AlterAnyUser:
-- 
ALTER ROLE [db_denydatareader] ADD MEMBER [DBA_with_AlterAnyUser]
GO
--
-- no need to give db_owner to DBA_with_AlterAnyUser, ALTER ANY USER is enough:
--
--ALTER ROLE [db_owner] ADD MEMBER [DBA_with_AlterAnyUser]
--GO
GRANT ALTER ANY USER to [DBA_with_AlterAnyUser]
GO

