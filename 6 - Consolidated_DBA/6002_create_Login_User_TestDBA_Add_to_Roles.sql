-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()

Use Master
GO
CREATE LOGIN [Login_Test_DBA] WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>'
--, DEFAULT_DATABASE=[SQLSecurityDemoDB], 
,CHECK_EXPIRATION=OFF
, CHECK_POLICY=OFF
GO
CREATE USER [User_Test_DBA]  FOR LOGIN [Login_Test_DBA] 
GO

ALTER ROLE role_DBA_master ADD MEMBER [User_Test_DBA] 
GO

ALTER SERVER ROLE server_role_DBA_master ADD MEMBER [Login_Test_DBA] 
GO

