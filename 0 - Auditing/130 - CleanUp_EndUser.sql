-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


--- after demo: clean up
ALTER ROLE [db_datareader] DROP MEMBER [User_DataReader]
GO
ALTER ROLE [db_datawriter] DROP MEMBER [User_DataReader]
GO
DROP USER User_DataReader 
GO
USE master
GO
DROP LOGIN User_DataReader 
GO
