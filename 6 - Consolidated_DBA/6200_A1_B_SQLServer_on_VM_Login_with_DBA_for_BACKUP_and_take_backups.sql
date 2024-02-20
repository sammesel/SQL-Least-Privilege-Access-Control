-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

-- master
use master
go
-- FULL BACKUP 
BACKUP DATABASE [master] TO  DISK = N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\master.bak' -- N'<replace with path to your backup folder>\master.bak' 
	WITH NOFORMAT, 
	NOINIT,  
	NAME = N'master-Full Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10, 
	CHECKSUM
GO

-- USE AdventureWorks2019
-- FULL BACKUP without verification
-- IT WILL FAIL, as the [Login_Test_DBA] does not have access to the AdventureWorks2019 database
BACKUP DATABASE [AdventureWorks2019] TO  DISK = N'<replace with path to your backup folder>\AdventureWorks2019_FULL.bak' 
BACKUP DATABASE [AdventureWorks2019] TO  DISK = N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\AdventureWorks2019_FULL.bak' 
	WITH NOFORMAT, 
	INIT,  
	NAME = N'AdventureWorks2019-Full Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO

-- TRY NOW WITH THE SQLSecurityDemoDB
BACKUP DATABASE [SQLSecurityDemoDB] TO  DISK = N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_FULL.bak' 
	WITH NOFORMAT, 
	INIT,  
	NAME = N'SQLSecurityDemoDB-Full Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO

-- run script [200_A1_C_create_Enlarged_table_in_AdventureWorks.sql]
-- to CREATE TABLE Sales.SalesOrderHeaderEnlarged
-- then take a differtial backup next


-- AdventureWorks2019
-- DIFFERENTIAL BACKUP without verification
-- BACKUP DATABASE [[SQLSecurityDemoDB]] TO  DISK = N'<replace with path to your backup folder>\AdventureWorks2019_diff.bak' 
BACKUP DATABASE [SQLSecurityDemoDB] TO  DISK = N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_diff.bak' 
WITH  DIFFERENTIAL , 
	NOFORMAT, 
	NOINIT,  
	NAME = N'SQLSecurityDemoDB-Diff Database Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO

-- run script [200_A1_D_update_Enlarged_table_in_AdventureWorks.sql]
-- then take a TLOG backup next

-- AdventureWorks2019
-- TLOG BACKUP without verification
-- BACKUP LOG [SQLSecurityDemoDB] TO  DISK = N'<replace with path to your backup folder>\SQLSecurityDemoDB_TLOG.LOG' 
BACKUP LOG [SQLSecurityDemoDB] TO  DISK = N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_TLOG.LOG' 
	WITH NOFORMAT, 
	NOINIT,  
	NAME = N'AdventureWorks2019-LOG Backup', 
	SKIP, 
	NOREWIND, 
	NOUNLOAD,  
	STATS = 10
GO

-- SHOW contents on Drive/folder used for backup:
-- <replace with path to your backup folder>

-- go to restore operation:
-- demo 11C and 11D
-- SQLSecurityDemoDB
-- FULL BACKUP without verification

