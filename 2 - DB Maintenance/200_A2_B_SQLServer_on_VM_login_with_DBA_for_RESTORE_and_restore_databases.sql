-- ================================================================================= --
-- LOGIN as [DBA_for_RESTORE]
-- use password: '<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

USE master;
GO
-- AdventureWorks2019_Restored
-- restore FULL BACKUP
USE [master]
RESTORE DATABASE [AdventureWorks2019_Restored] FROM  
	DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\AdventureWorks2019_FULL.bak' -- N'<replace with path to your backup folder>\AdventureWorks2019_FULL.bak' 
	WITH  FILE = 1, 
		MOVE N'AdventureWorks2019' TO N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\DATA\AdventureWorks2019_Restored.mdf',  
		MOVE N'AdventureWorks2019_log' TO N'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\LOG\AdventureWorks2019_Restored_log.ldf',  
		NORECOVERY,  
		NOUNLOAD,  
		STATS = 5

-- restore DIFFERENTIAL BACKUP
RESTORE DATABASE [AdventureWorks2019_Restored] FROM  
	DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\AdventureWorks2019_DIFF.bak'  -- N'<replace with path to your backup folder>\AdventureWorks2019_DIFF.bak' 
	WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5

-- restore LOG BACKUP
RESTORE LOG [AdventureWorks2019_Restored] FROM  
	DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\AdventureWorks2019_TLOG.LOG'  -- N'<replace with path to your backup folder>\AdventureWorks2019_TLOG.LOG' 
	WITH  FILE = 1,  NOUNLOAD,  STATS = 5

GO





