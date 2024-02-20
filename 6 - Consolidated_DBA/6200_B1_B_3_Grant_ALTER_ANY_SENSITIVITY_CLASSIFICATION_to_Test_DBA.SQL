-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()

---------------------- ADD [Login_Test_DBA]  to SQLSecurityDemoDB ---------------------- 
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

GRANT ALTER ANY SENSITIVITY CLASSIFICATION to [role_DBA_master]
