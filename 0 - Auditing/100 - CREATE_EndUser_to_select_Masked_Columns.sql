-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-- create login with password
-- replace the password. it will be used on next script [110 - Test_EndUser_selecting_Masked_Columns.sql]
USE master
GO
CREATE LOGIN User_DataReader WITH PASSWORD = '<password-place-holder>';
GO

USE [SQLSecurityDemoDB]
GO
CREATE USER User_DataReader FROM LOGIN User_DataReader
GO

-- allow LOGIN to access all tables for read/write operations
ALTER ROLE [db_datareader] ADD MEMBER [User_DataReader]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [User_DataReader]
GO


