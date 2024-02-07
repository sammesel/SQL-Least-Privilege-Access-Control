-- https://learn.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-get-audit-file-transact-sql?view=sql-server-ver16

-- for storage account location, use the following:
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-get-audit-file-transact-sql?view=sql-server-ver16#azure-sql-database
-- 
-- SELECT *
-- FROM sys.fn_get_audit_file('https://mystorage.blob.core.windows.net/sqldbauditlogs/ShiraServer/MayaDB/SqlDbAuditing_Audit/2017-07-14/10_45_22_173_1.xel', DEFAULT, DEFAULT);
-- GO



-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

SELECT 
	distinct session_id, session_server_principal_name
FROM
	sys.fn_get_audit_file('https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/azuresql-mi-gp-001/master/Instance_ServerAudit_NoRetention/2024-02-07/20_13_13_669_0.xel', DEFAULT, DEFAULT)



SELECT 
	*
FROM
	sys.fn_get_audit_file('https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/azuresql-mi-gp-001/master/Instance_ServerAudit_NoRetention/2024-02-07/20_13_13_669_0.xel', DEFAULT, DEFAULT)
WHERE
	event_time >= dateadd( mi , -60 , getdate() )
	AND
	database_principal_name = 'User_DataReader'
	AND
	database_name = 'SQLSecurityDemoDB'
GO


-- https://solutioncenter.apexsql.com/analyze-and-read-sql-server-audit-information/#Reading%20The%20Audit%20Information%20from%20The%20*.Sqlaudit%20Files
