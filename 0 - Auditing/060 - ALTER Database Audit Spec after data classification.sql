-- https://www.sqlshack.com/sql-data-classification-add-sensitivity-classification-in-sql-server-2019/
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-sensitivity-classifications-transact-sql?view=sql-server-ver16

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-- Disable Database Audit Specs
ALTER DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
WITH (STATE = OFF)
GO

-- these captures are only available when there are columns that are registered with SENSITIVITY CLASSIFICATION
-- see script [050 - Data Classification.SQL]
-- 
ALTER DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
ADD (SENSITIVITY_CLASSIFICATION_CHANGE_GROUP),
ADD (SENSITIVE_BATCH_COMPLETED_GROUP)

GO


-- AFTER executing this script: ENABLE current database spec
-- Disable Database Audit Specs
ALTER DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
WITH (STATE = ON)
GO
