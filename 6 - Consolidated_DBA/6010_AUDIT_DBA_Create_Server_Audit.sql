-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO


/****** Object:  Audit [Instance_ServerAudit]    Script Date: 1/6/2024 5:17:12 PM ******/
--
-- these 2 commands will fail if there isn't SERVER AUDIT - or the name doesn't match
-- you may ignore these errors. 
USE [master]
GO
ALTER SERVER AUDIT [Instance_ServerAudit]
WITH (STATE = OFF)
GO
USE [master]
GO
DROP SERVER AUDIT [Instance_ServerAudit]
GO


/*
** REFERENCES
** ===========
** AUDITING FOR AZURE SQL MI: https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/auditing-configure?view=azuresql
*/

-- Cretes a Server-Audit object
-- modify the path for drive\folder to be used to log the audit entries:
-- 
-- <REVIEW> FILEPATH
-- 
CREATE SERVER AUDIT [Instance_ServerAudit]
TO FILE 
(	FILEPATH = N'E:\XEVENTS\'
	,MAXSIZE = 0 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = '22c6a93a-b3b2-4252-a5c3-546358d413a3')
ALTER SERVER AUDIT [Instance_ServerAudit] WITH (STATE = OFF)
GO

-- starts the Server-Audit :
ALTER SERVER AUDIT [Instance_ServerAudit]
WITH (STATE = ON);  
GO  

--- [Login_Test_DBA] is not able to CREATE/ALTER/DROP a SERVER AUDIT
--  in order to do so, we need to add  ALTER ANY SERVER AUDIT or the CONTROL SERVER permission.
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/create-server-audit-transact-sql?view=sql-server-ver16#permissions
