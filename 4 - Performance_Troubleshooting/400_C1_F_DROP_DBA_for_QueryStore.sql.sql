-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
-- make sure to login as sa
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- remove from role
use SQLSecurityDemoDB
GO
ALTER ROLE Role_Tuning_QueryStore
	DROP MEMBER [DBA_for_QueryStore]
GO
-- drop role 
use SQLSecurityDemoDB
GO
DROP ROLE Role_Tuning_QueryStore
GO
-- DROP USER
USE SQLSecurityDemoDB
GO
DROP USER [DBA_for_QueryStore]
GO
-- DROP LOGIN
USE master
GO
DROP USER [DBA_for_QueryStore]
GO
DROP LOGIN [DBA_for_QueryStore]
GO

DROP PROC IF EXISTS tools_QueryStore.up_sp_query_store_force_plan 
GO
DROP PROC IF EXISTS tools_QueryStore.up_sp_query_store_set_storage
GO
DROP SCHEMA IF EXISTS tools_QueryStore
GO


-- Grant permissions
REVOKE ALTER TO role_internal_principal_QueryStore
-- Add User to role
ALTER ROLE role_internal_principal_QueryStore
	DROP MEMBER internal_principal_QueryStore
-- As a best practice use a Role
DROP ROLE role_internal_principal_QueryStore
GO
DROP USER internal_principal_QueryStore

