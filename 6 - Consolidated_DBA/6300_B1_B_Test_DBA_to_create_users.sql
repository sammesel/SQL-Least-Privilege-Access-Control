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


CREATE  USER UserMary1 FROM LOGIN  UserMary1;
GO
CREATE  USER UserMary2 FROM LOGIN  UserMary2;
GO
CREATE  USER UserMary3 FROM LOGIN  UserMary3;
GO
CREATE  USER UserJohn1 FROM LOGIN  UserJohn1;
GO
CREATE  USER UserJohn2 FROM LOGIN  UserJohn2;
GO


-- 
USE [SQLSecurityDemoDB]
GO
CREATE USER HR_Manager			FROM LOGIN HR_Manager			
GO
CREATE USER SalesManager		FROM LOGIN SalesManager		
GO
CREATE USER SalesPerson			FROM LOGIN SalesPerson	
GO
CREATE USER OperationsManager	FROM LOGIN OperationsManager
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
