-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE [master]
GO

SELECT * FROM SYS.schemas WHERE Name = 'tools_errorlog'
CREATE SCHEMA tools_errorlog
GO
SELECT * FROM SYS.schemas WHERE Name = 'tools_errorlog'

-- Special wrapper stored proc that is executed under the context of the above created user: role_internal_principal_xxxxxxxxxx
DROP PROCEDURE IF EXISTS tools_errorlog.up_sp_readerrorlog
GO
CREATE OR ALTER PROC tools_errorlog.up_sp_readerrorlog
	@par1 int = 0, -- log number
	@par2 int = null, -- product id: 1 for SQL Server, 2 for Agent 
	@par3 nvarchar(4000) = NULL, -- string-to-search-1
	@par4 nvarchar(4000) = NULL -- string-to-search-2
AS
if (@par2 is NULL)
	EXEC sys.sp_readerrorlog @par1
else
	EXEC sys.sp_readerrorlog @par1, @par2, @par3, @par4 
GO
-------------------------------------------------------------------------------
-- no need to grant execute directly to the user or login, grant to the ROLE -- 
-------------------------------------------------------------------------------
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
GRANT EXECUTE ON OBJECT::tools_errorlog.up_sp_readerrorlog TO role_internal_principal_errorlog -- WITH GRANT OPTION;  
GO
GRANT EXECUTE ON OBJECT::sys.sp_readerrorlog TO role_internal_principal_errorlog -- WITH GRANT OPTION;  
GO

DROP PROCEDURE IF EXISTS tools_errorlog.up_sp_cycle_errorlog
GO
CREATE OR ALTER PROC tools_errorlog.up_sp_cycle_errorlog
AS
EXEC sys.sp_cycle_errorlog 
GO
-------------------------------------------------------------------------------
-- no need to grant execute directly to the user or login, grant to the ROLE -- 
-------------------------------------------------------------------------------
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
GRANT EXECUTE ON OBJECT::tools_errorlog.up_sp_cycle_errorlog TO role_internal_principal_errorlog -- WITH GRANT OPTION;  

---------------------------------------------------------------------------------
--- DO NOT EXECUTE REMAINING CODE if this is for Azure SQL MI or Azure SQL DB ---
---------------------------------------------------------------------------------

USE mssqlsystemresource
GO
GRANT EXECUTE ON sp_cycle_errorlog TO role_internal_principal_errorlog -- WITH GRANT OPTION;  
GRANT EXECUTE ON sp_cycle_errorlog TO role_internal_principal_errorlog ;


USE master
GO
-- this is for SQL on VM
GRANT EXECUTE ON resourcedb.sys.sp_helpdb TO role_internal_principal_errorlog;
-- this is for Azure SQL MI
GRANT EXECUTE ON sys.sp_helpdb TO role_internal_principal_errorlog;
GRANT EXECUTE ON sys.sp_cycle_errorlog TO role_internal_principal_errorlog;
GRANT EXECUTE ON OBJECT::sys.sp_cycle_errorlog
     TO role_internal_principal_errorlog;
GO  
