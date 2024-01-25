-- ================================================================================= --
-- STOP:
-- do not run this script until you have tested the complete solution.
-- this means, testing the scripts on the following folders:
--
--	0 - AUDITING                                                                                                                           
--	1 - Installation_Configuration                                                                                                         
--	2 - DB_Maintenance                                                                                                                     
--	3 - Security_Management                                                                                                                
--	4 - Performance_Troubleshooting                                                                                                        
--	5 - Object_Management                                                                                                                  
--	6 - End_User_Testing                                                                                                                       
--
-- ================================================================================= --


-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user



-- Disable Database Audit Specs
USE [SQLSecurityDemoDB]
GO
ALTER DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
WITH (STATE = OFF)
GO
USE [SQLSecurityDemoDB]
GO
DROP DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
GO


-- go to master
-- stop and delete the server audit spec
USE [master]
GO
ALTER SERVER AUDIT SPECIFICATION [Instance_ServerAuditSpec]
WITH (STATE = OFF)
GO
USE [master]
GO
DROP SERVER AUDIT SPECIFICATION [Instance_ServerAuditSpec]
GO


-- go to master
-- stop and delete the server audit 
-- 
GO
USE [master]
GO
ALTER SERVER AUDIT [Instance_ServerAudit]
WITH (STATE = OFF)
GO
USE [master]
GO
/****** Object:  Audit [inst_2022_A_ServerAudit]    Script Date: 1/24/2024 3:49:23 PM ******/
DROP SERVER AUDIT [Instance_ServerAudit]
GO


