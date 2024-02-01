-- https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-addrolemember-transact-sql?view=sql-server-ver16


-- ================================================================================= --
-- LOGIN as:		DBA_with_AlterAnyUser
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- -- these will fail -- --
ALTER ROLE [db_datareader] ADD MEMBER [UserMary1]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [UserMary1]
GO

-- -- these will fail -- --
exec sp_addrolemember db_datareader, UserMary1
GRANT UPDATE ON SCHEMA::Data TO UserMary1;
