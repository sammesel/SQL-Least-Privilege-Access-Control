-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
USE SQLSecurityDemoDB
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()

-- as [Login_Test_DBA] cannot use the target database:
-- run script [___4_Create_USER_for_Test_DBA_OnTargetDatabase.sql] that will add that principal into 
--		the target database: SQLSecurityDemoDB

