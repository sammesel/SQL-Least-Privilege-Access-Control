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


		CREATE LOGIN [DBA_with_ServerAdmin] 
			WITH PASSWORD=N'<password-place-holder>', 
			CHECK_EXPIRATION=OFF, 
			CHECK_POLICY=OFF

		ALTER SERVER ROLE [serveradmin] ADD MEMBER [DBA_with_ServerAdmin]
		GO

		-- Prepare the User to be used for the wrapper procedure
		USE SQLSecurityDemoDB
		GO
		CREATE USER DBA_with_ServerAdmin
			FOR LOGIN [DBA_with_ServerAdmin] 


