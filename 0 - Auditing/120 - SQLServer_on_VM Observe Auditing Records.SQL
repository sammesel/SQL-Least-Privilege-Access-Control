-- https://learn.microsoft.com/en-us/sql/relational-databases/system-functions/sys-fn-get-audit-file-transact-sql?view=sql-server-ver16


-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


SELECT 
	*
FROM
	sys.fn_get_audit_file('E:\XEvents\*.sqlaudit', DEFAULT, DEFAULT)
WHERE
	event_time >= dateadd( mi , -60 , getdate() )
	AND
	session_id = 58
	--(
	--server_principal_id <> 1
	--or 
	--server_principal_name IN ( 'user_datareader' )
	--or 
	--database_principal_name  IN ( 'user_datareader')
	--)
--	or

	succeeded = 1
	)
	AND
	event_time > '2024-01-11 16:00:00'

	or 
	server_principal_id = ??
	or
	database_principal_id = ?? 

GO


-- https://solutioncenter.apexsql.com/analyze-and-read-sql-server-audit-information/#Reading%20The%20Audit%20Information%20from%20The%20*.Sqlaudit%20Files
