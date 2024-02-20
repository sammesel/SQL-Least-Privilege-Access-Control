-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

-- -- these will fail -- --
ALTER ROLE [db_datareader] ADD MEMBER [UserMary1]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UserMary1]
GO

-- -- these will fail -- --
exec sp_addrolemember db_datareader, UserMary1

-- -- these will succeed -- --
GRANT UPDATE ON SCHEMA::Production TO UserMary1;
GRANT SELECT ON SCHEMA::Production to  UserMary1;
