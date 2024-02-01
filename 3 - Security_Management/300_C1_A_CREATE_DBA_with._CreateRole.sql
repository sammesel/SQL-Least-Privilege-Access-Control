-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE MASTER
GO

CREATE LOGIN [DBA_with_CreateRole] 
	WITH PASSWORD=N'<password-place-holder>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF

use [SQLSecurityDemoDB]
GO

CREATE USER [DBA_with_CreateRole] FROM LOGIN [DBA_with_CreateRole]
GO

--
-- make sure to eliminate READ access from DBA_with_AlterAnyUser:
-- 
ALTER ROLE [db_denydatareader] ADD MEMBER [DBA_with_AlterAnyUser]
GO

--
-- no need to give db_owner to DBA_with_AlterAnyUser, [db_securityadmin] is enough:
--
ALTER ROLE [db_securityadmin] ADD MEMBER [DBA_with_CreateRole]
GO


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

