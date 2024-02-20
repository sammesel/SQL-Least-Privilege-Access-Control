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

-- CLEAN UP
USE [SQLSecurityDemoDB]
GO
ALTER ROLE [role_HR_Manager] DROP MEMBER [HR_Manager]
GO
ALTER ROLE [role_OperationsManager] DROP MEMBER [OperationsManager]
GO
ALTER ROLE [role_SalesManager] DROP MEMBER [SalesManager]
GO
ALTER ROLE [role_SalesPerson] DROP MEMBER [SalesPerson]
GO

-- CLEAN UP
USE [SQLSecurityDemoDB]
GO
DROP ROLE [role_HR_Manager] 
GO
DROP ROLE [role_OperationsManager] 
GO
DROP ROLE [role_SalesManager] 
GO
DROP ROLE [role_SalesPerson]
GO
