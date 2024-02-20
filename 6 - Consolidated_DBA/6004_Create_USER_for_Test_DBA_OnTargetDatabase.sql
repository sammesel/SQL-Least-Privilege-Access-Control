-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
go
---------------------- ADD [Login_Test_DBA]  to SQLSecurityDemoDB ---------------------- 
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
CREATE USER [User_Test_DBA]  FOR LOGIN [Login_Test_DBA] 
GO


CREATE ROLE role_DBA_master
GO
ALTER ROLE role_DBA_master ADD MEMBER [User_Test_DBA] 
GO

-- add the [role_DBA_master] to the ROLE [db_backupoperator] for each database the DBA will perform backup 
USE SQLSecurityDemoDB
GO

ALTER ROLE [db_backupoperator] ADD MEMBER [role_DBA_master]
GO

ALTER ROLE [db_ddladmin]  ADD MEMBER [role_DBA_master]
GO

GRANT ALTER ON DATABASE::[SQLSecurityDemoDB] TO [role_DBA_master];

GRANT CREATE TABLE TO [role_DBA_master];
GO
---------------------- Execute script [6005_Login_and_Test_DBA_on_Target_Database.sql] ---------------------- 
