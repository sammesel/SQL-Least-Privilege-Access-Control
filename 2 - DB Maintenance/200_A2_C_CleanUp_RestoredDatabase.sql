-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


USE [master]
GO

EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdventureWorks2019_Restored'
GO
USE [master]
GO


-- IF Database is in "Restoring..." mode
/****** Object:  Database [AdventureWorks2019_Restored]    Script Date: 1/31/2024 7:19:21 PM ******/
DROP DATABASE [AdventureWorks2019_Restored]
GO

-- IF Database is availabe
ALTER DATABASE [AdventureWorks2019_Restored] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
USE [master]
GO
/****** Object:  Database [AdventureWorks2019_Restored]    Script Date: 1/9/2024 4:13:45 PM ******/
DROP DATABASE [AdventureWorks2019_Restored]
GO
