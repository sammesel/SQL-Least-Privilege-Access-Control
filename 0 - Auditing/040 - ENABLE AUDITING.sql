-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- Enable the SERVER AUDIT
-- 
use master
GO
ALTER SERVER AUDIT [Instance_ServerAudit] WITH (STATE = ON);

-- Enable the server audit SPECS
ALTER SERVER AUDIT SPECIFICATION [Instance_ServerAuditSpec]
WITH (STATE = ON);  
GO  

-- Enable Database Audit Specs
-- need to change database to where Database-Audit-Specification is created
--
USE [SQLSecurityDemoDB]
GO
ALTER DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
WITH (STATE = ON);  
GO  

