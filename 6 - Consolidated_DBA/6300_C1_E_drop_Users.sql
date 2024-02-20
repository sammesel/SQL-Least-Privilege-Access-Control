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


-- clean up
USE [SQLSecurityDemoDB]
GO
DROP USER HR_Manager			
GO
DROP USER SalesManager		
GO
DROP USER SalesPerson			
GO
DROP USER OperationsManager	
GO

-- clean up
DROP USER UserMary1;
GO
DROP USER UserMary2;
GO
DROP USER UserMary3;
GO
DROP USER UserJohn1;
GO
DROP USER UserJohn2;
GO
