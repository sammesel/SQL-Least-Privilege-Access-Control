-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

CREATE LOGIN [DBA_for_DBCC] 
	WITH PASSWORD=N'<password-place-holder>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF

-- Prepare the User to be used for the wrapper procedure
USE SQLSecurityDemoDB

CREATE USER DBA_for_DBCC
	FOR LOGIN [DBA_for_DBCC] 

