-- ================================================================================= --
-- LOGIN as [Login_Test_DBA]
-- use password: '<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

-- SQLSecurityDemoDB_Restored
-- restore FULL BACKUP
USE [master]
GO

-- obtain the list of files used in the .bak
RESTORE FILELISTONLY
    FROM DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_FULL.bak'

-- as the database SQLSecurityDemoDB_Restored was created from a restore of the AdventureWorks2019
--		data file and log file use the original LOGICAL name, which will need to be replaced 
--		if we want to restore it into another database - while the AdventureWorks2019 database is active

-- DROP DATABASE SQLSecurityDemoDB_Restored
	USE [master]
	GO
	ALTER DATABASE [SQLSecurityDemoDB_Restored] SET  SINGLE_USER WITH ROLLBACK IMMEDIATE
	GO
	USE [master]
	GO
	/****** Object:  Database [SQLSecurityDemoDB_Restored]    Script Date: 2/20/2024 10:20:34 AM ******/
	DROP DATABASE [SQLSecurityDemoDB_Restored]
	GO


RESTORE DATABASE [SQLSecurityDemoDB_Restored]
    FROM DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_FULL.bak'
    WITH NORECOVERY,
      MOVE 'AdventureWorks2019' TO 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\DATA\SQLSecurityDemoDB_Restored_Data.mdf',
      MOVE 'AdventureWorks2019_Log'  TO 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\LOG\SQLSecurityDemoDB_Restored_Log.ldf';

RESTORE DATABASE [SQLSecurityDemoDB_Restored]
    FROM DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_diff.bak'
      WITH NORECOVERY;


RESTORE LOG [SQLSecurityDemoDB_Restored]
    FROM DISK = 'E:\Microsoft SQL Server\MSSQL16.INST_2022_A\MSSQL\Backup\SQLSecurityDemoDB_TLOG.log'  
    WITH RECOVERY;







