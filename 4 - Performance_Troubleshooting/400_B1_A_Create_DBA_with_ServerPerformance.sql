-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, @@servername, db_name()
GO
USE [master]
GO
CREATE LOGIN [DBA_with_PerformanceTroubleshooting] WITH PASSWORD=N'<P@ssw0rd-Pl@c3-H0ld3r>'
	, DEFAULT_DATABASE=[SQLSecurityDemoDB]
	, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE USER [DBA_with_PerformanceTroubleshooting] FOR LOGIN [DBA_with_PerformanceTroubleshooting] 
GO

-- THIS IS FOR SQL Server on VM or Azure SQL Managed Instance
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-server-permissions-transact-sql?view=sql-server-ver16
CREATE SERVER ROLE Role_TuningTeam_DMVs
GO

-- THIS IS for Azure SQL Database:
CREATE ROLE Role_TuningTeam_DMVs
GO

-- THIS IS FOR SQL Server on VM or Azure SQL Managed Instance
ALTER SERVER ROLE Role_TuningTeam_DMVs
	ADD MEMBER [DBA_with_PerformanceTroubleshooting]
GO
-- THIS IS VM or Azure SQL Database:
ALTER ROLE Role_TuningTeam_DMVs
	ADD MEMBER [DBA_with_PerformanceTroubleshooting]
GO


-- THIS IS FOR SQL Server on VM or Azure SQL Managed Instance
use [master]
GO
GRANT VIEW SERVER PERFORMANCE STATE TO Role_TuningTeam_DMVs
GO
GRANT VIEW SERVER STATE TO Role_TuningTeam_DMVs
GO

-- THIS IS VM or Azure SQL Database:
GRANT VIEW DATABASE PERFORMANCE STATE TO DBA_with_PerformanceTroubleshooting --Role_TuningTeam_DMVs
GO
GRANT VIEW SERVER STATE TO Role_TuningTeam_DMVs
GO



-- GRANT exec on sys.sp_readerrorlog TO [DBA_with_PerformanceTroubleshooting]
GRANT exec on xp_readerrorlog  TO [DBA_with_PerformanceTroubleshooting]
GRANT exec on sys.sp_enumerrorlogs  TO [DBA_with_PerformanceTroubleshooting]
GRANT exec on sys.sp_cycle_errorlog  TO [DBA_with_PerformanceTroubleshooting]
GRANT EXECUTE ON sp_cycle_errorlog TO [DBA_with_PerformanceTroubleshooting];


USE [SQLSecurityDemoDB]
GO
CREATE USER [DBA_with_PerformanceTroubleshooting] FOR LOGIN [DBA_with_PerformanceTroubleshooting]
GO


-- for next step: make sure to open a new connection using the login: [DBA_with_PerformanceTroubleshooting]
-- DO demos on file: [400_B1_B_Test_DBA_With_PerformaceTroubleshooting.sql] 

/*
** CLEAN UP
*/
-- file: [400_B1_C_DROP_DBA_With_PerformaceTroubleshooting.sql] 
