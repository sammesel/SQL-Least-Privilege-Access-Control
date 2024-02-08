-- ================================================================================= --
-- LOGIN as [DBA_for_RESTORE]
-- use password: '<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

USE master;
GO

-- https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url-best-practices-and-troubleshooting?view=sql-server-ver16
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-transact-sql?view=azuresqldb-mi-current&preserve-view=true

-- limitations: https://learn.microsoft.com/en-us/sql/t-sql/statements/restore-statements-transact-sql?view=azuresqldb-mi-current&preserve-view=true#limitations---sql-managed-instance

/*
	SYNTAX
	------------------

	--To Restore an Entire Database from a Full database backup (a Complete Restore):
	RESTORE DATABASE { database_name | @database_name_var }
	FROM URL = { 'physical_device_name' | @physical_device_name_var } [ ,...n ]
	[;]

*/

-- AdventureWorks2019_Restored
-- restore FULL BACKUP
USE [master]
go
RESTORE DATABASE [SQLSecurityDemoDB_Restored] 
	FROM  URL = 'https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/SQLSecurityDemoDB_full_20240207.bak' -- N'<replace with path to your backup folder>\database_FULL.bak' 
	


-- use this query on another session to track RESTORE PROGRESS
SELECT query = a.text, start_time, percent_complete,
    eta = dateadd(second,estimated_completion_time/1000, getdate())
FROM sys.dm_exec_requests r
    CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
WHERE r.command = 'RESTORE DATABASE'
