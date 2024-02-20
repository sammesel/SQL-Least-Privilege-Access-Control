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


EXEC sp_readerrorlog
GO
EXEC sp_readerrorlog 2
GO
EXEC sp_readerrorlog NULL, 1,'UTC'
GO
EXEC sp_readerrorlog NULL, 1,'process ID is'
GO

exec xp_readerrorlog  
GO
exec sys.sp_enumerrorlogs  
GO
