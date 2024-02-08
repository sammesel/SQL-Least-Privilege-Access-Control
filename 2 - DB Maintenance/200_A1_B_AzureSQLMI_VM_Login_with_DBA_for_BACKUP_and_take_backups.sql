-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

-- THIS CREDENTIAL MAY ALREADY EXIST FROM [AUDITING] script: [010 - Azure_SQL_MI  CREATE AUDIT SERVER.sql]


-- https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/auditing-configure?view=azuresql

/*
CREATE CREDENTIAL [<container_url>]
WITH IDENTITY='SHARED ACCESS SIGNATURE',
SECRET = '<SAS KEY>'
GO
*/

DROP CREDENTIAL [https://st4dbxferdatalogbackups.blob.core.windows.net/auditing]
GO
CREATE CREDENTIAL [https://st4dbxferdatalogbackups.blob.core.windows.net/auditing]
WITH IDENTITY='SHARED ACCESS SIGNATURE',
-- Remove the question mark (?) character from the beginning of the token
SECRET = 'sv=2022-11-02&ss=bfqt&srt=s&sp=rwdlactfx&se=2029-02-07T19:00:00Z&st=2024-02-07T19:00:00Z&spr=https&sig=FFygqAW10I5RrfcXVgxGpBZi2xYPo7D4HhCSz0asLB8%3D'
GO

-- https://learn.microsoft.com/en-us/sql/relational-databases/backup-restore/sql-server-backup-to-url-best-practices-and-troubleshooting?view=sql-server-ver16
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/backup-transact-sql?view=azuresqldb-mi-current&preserve-view=true
/*
	Azure SQL Managed Instance
	===========================
	Azure SQL Managed Instance has automatic backups. 
	You can create full database COPY_ONLY backups. 
	Differential, log, and file snapshot backups are not supported.

	Syntax
	--------------------------------------------------------------------------------------
	BACKUP DATABASE { database_name | @database_name_var }
	  TO URL = { 'physical_device_name' | @physical_device_name_var }[ ,...n ]
	  WITH COPY_ONLY [, { <general_WITH_options> } ]
	[;]

	<general_WITH_options> [ ,...n ]::=

	--Media Set Options
	   MEDIADESCRIPTION = { 'text' | @text_variable }
	 | MEDIANAME = { media_name | @media_name_variable }
	 | BLOCKSIZE = { blocksize | @blocksize_variable }

	--Data Transfer Options
	   BUFFERCOUNT = { buffercount | @buffercount_variable }
	 | MAXTRANSFERSIZE = { maxtransfersize | @maxtransfersize_variable }

	--Error Management Options
	   { NO_CHECKSUM | CHECKSUM }
	 | { STOP_ON_ERROR | CONTINUE_AFTER_ERROR }

	--Compatibility Options
	   RESTART

	--Monitoring Options
	   STATS [ = percentage ]

	--Encryption Options
	 ENCRYPTION (ALGORITHM = { AES_128 | AES_192 | AES_256 | TRIPLE_DES_3KEY } , encryptor_options ) <encryptor_options> ::=
	   SERVER CERTIFICATE = Encryptor_Name | SERVER ASYMMETRIC KEY = Encryptor_Name


*/
BACKUP DATABASE master
TO URL = 'https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/master_full_20240207.bak'
WITH STATS = 5, COPY_ONLY;


BACKUP DATABASE SQLSecurityDemoDB
TO URL = 'https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/SQLSecurityDemoDB_full_20240207.bak'
WITH STATS = 5, COPY_ONLY;



/*
-- as the BACKUP for Azure SQL MI only supports FULL BACK-UP the next block is for demonstration purposes 
-- to show DIFF backup will fail
-- start:
*/

	-- to generate changes in the database, execute the script [200_A1_C_create_Enlarged_table_in_AdventureWorks.sql] as sa

	-- AdventureWorks2019
	-- DIFFERENTIAL BACKUP without verification
	BACKUP DATABASE SQLSecurityDemoDB 
	TO URL = 'https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/SQLSecurityDemoDB_diff_20240207.bak'
		WITH  DIFFERENTIAL , 
		NOFORMAT, 
		NOINIT,  
		NAME = N'SQLSecurityDemoDB_diff Database Backup', 
		SKIP, 
		NOREWIND, 
		NOUNLOAD,  
		COPY_ONLY,
		STATS = 10
	GO

/*
-- end:
*/


/*
-- as the BACKUP for Azure SQL MI only supports FULL BACK-UP the next block is for demonstration purposes 
-- to show DIFF backup will fail
-- start:
*/

	-- run script [200_A1_D_update_Enlarged_table_in_AdventureWorks.sql]
	-- then take a TLOG backup next

	-- AdventureWorks2019
	-- TLOG BACKUP without verification
	BACKUP LOG [AdventureWorks2019] 
	TO URL = 'https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/SQLSecurityDemoDB_TLOG_20240207_001.log'
		WITH NOFORMAT, 
		NOINIT,  
		NAME = N'SQLSecurityDemoDB-TLOG-001 Backup', 
		SKIP, 
		NOREWIND, 
		NOUNLOAD,  
		STATS = 10
	GO