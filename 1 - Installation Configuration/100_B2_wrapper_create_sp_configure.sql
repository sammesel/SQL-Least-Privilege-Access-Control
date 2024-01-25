--  https://learn.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-configure-transact-sql?view=sql-server-ver16#permissions
/*******************************************************************
Query Store access to sp_query_store_force_plan, demo solution
Accompanying article: Using Query Store with least privileges instead of db_owner to archive Separation of Duties

Schema Preparation script

Original script: 07/24/2019 Andreas Wolter, Microsoft

Applies to: SQL Server, Azure SQL Database, Azure SQL Database Managed Instance

*******************************************************************/

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE [master]
GO

-- Dedicated schema to allow granular permissions and not on whole database or a schema with other objects
CREATE SCHEMA tools
GO
	
-- Special wrapper stored proc that is executed under the context of the above created user: role_internal_principal_ALTER_DB
DROP PROCEDURE IF EXISTS tools.up_sp_configure_show_advanced_options
GO
CREATE OR ALTER PROC tools.up_sp_configure_show_advanced_options
--WITH EXECUTE AS OWNER -- 'user_internal_principal_spconfigure'
AS
-- whatever is being done within the body of this procedure, will be done by the internal_principal_ALTER_DB
-- therefore the deployment needs to be secured in that nobody can introduce malicious code here
-- calling the internal proc and passing on the parameter values:
EXEC sys.sp_configure N'show advanced options', N'1'  
RECONFIGURE WITH OVERRIDE
GO
-------------------------------------------------------------------------------
-- no need to grant execute directly to the user or login, grant to the ROLE -- 
-------------------------------------------------------------------------------
-- GRANT EXECUTE ON tools.up_sp_configure_show_advanced_options	TO user_internal_principal_spconfigure
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
GRANT EXECUTE ON tools.up_sp_configure_show_advanced_options	TO role_internal_principal_spconfigure -- WITH GRANT OPTION;  
-- tests
EXEC tools.up_sp_configure_show_advanced_options

select user_name(), suser_name()
EXECUTE AS LOGIN = 'LOGIN_internal_principal_spconfigure';
select user_name(), suser_name()
EXEC tools.up_sp_configure_show_advanced_options
REVERT
select user_name(), suser_name()


DROP PROC IF EXISTS tools.up_sp_configure
GO
CREATE OR ALTER PROC tools.up_sp_configure
WITH EXECUTE AS OWNER -- 'user_internal_principal_spconfigure'
AS
-- whatever is being done within the body of this procedure, will be done by the internal_principal_ALTER_DB
-- therefore the deployment needs to be secured in that nobody can introduce malicious code here
-- calling the internal proc and passing on the parameter values:
EXEC sys.sp_configure
GO
-------------------------------------------------------------------------------
-- no need to grant execute directly to the user or login, grant to the ROLE -- 
-------------------------------------------------------------------------------
-- GRANT EXECUTE ON tools.up_sp_configure	TO user_internal_principal_spconfigure
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
GRANT EXECUTE ON tools.up_sp_configure	TO role_internal_principal_spconfigure -- WITH GRANT OPTION;  


-- tests
EXEC tools.up_sp_configure

select user_name(), suser_name()
EXECUTE AS LOGIN = 'LOGIN_internal_principal_spconfigure';
select user_name(), suser_name()
EXEC tools.up_sp_configure
REVERT
select user_name(), suser_name()



-- for a list of all server configurations: https://learn.microsoft.com/en-us/sql/database-engine/configure-windows/server-configuration-options-sql-server?view=sql-server-ver16
-- select * from sys.configurations where is_advanced=0
-- select * from sys.configurations where is_advanced=1
-- sp_help 'sys.configurations'
DROP PROC IF EXISTS tools.up_sp_configure_option_value
GO
CREATE OR ALTER PROC tools.up_sp_configure_option_value
@param_option Nvarchar(70),
@param_value int = NULL
--WITH EXECUTE AS 'sa' -- OWNER --- 'user_internal_principal_spconfigure'
AS
	-----------------------------------
	-- PREVENT SQL INJECTION
	-----------------------------------
	-- validate input parameter: @param_option
	IF PATINDEX('%;%',@param_option) + PATINDEX('%--%',@param_option) + PATINDEX('%/*%',@param_option) + PATINDEX('%*/%',@param_option) <> 0 	   --  + PATINDEX('%''%',@param_option) 
	BEGIN
		IF PATINDEX('%;%',@param_option) <> 0   PRINT 'using ;'     + ' at: ' + CAST(PATINDEX('%;%'  ,@param_option) as CHAR(10))	--IF PATINDEX('%''%',@param_option)  <> 0 PRINT 'using '      + ' at: ' + CHAR(39) + CHAR(39) + ' at: ' + CAST(PATINDEX('%''%' ,@param_option) as CHAR(10))
		IF PATINDEX('%--%',@param_option) <> 0  PRINT 'using --'    + ' at: ' + CAST(PATINDEX('%--%' ,@param_option) as CHAR(10))
		IF PATINDEX('%/*%',@param_option) <> 0  PRINT 'using /*'    + ' at: ' + CAST(PATINDEX('%/*%' ,@param_option) as CHAR(10))
		IF PATINDEX('%*/%',@param_option) <> 0  PRINT 'using */'    + ' at: ' + CAST(PATINDEX('%*/%' ,@param_option) as CHAR(10))
		IF PATINDEX('%xp_%',@param_option) <> 0  PRINT 'using xp_'  + ' at: ' + CAST(PATINDEX('%xp_%',@param_option) as CHAR(10))
		PRINT 'smells like trouble !'
		RETURN
	END
	-----------------------------------
	-- PREVENT SQL INJECTION
	-----------------------------------
	declare @tsql nvarchar(1000)
	declare @valid smallint = 0
	--PRINT '@param_option = ' + '*' + RTRIM(LTRIM(@param_option))+'*'
	--PRINT '@param_value =  ' + '*' + ISNULL( CONVERT(char(10),RTRIM(LTRIM(@param_value))),'NULL' )+'*'
	IF RTRIM(LTRIM(@param_option)) = 'allow updates'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'nested triggers'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'server trigger recursion'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'remote access'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'default language'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'cross db ownership chaining'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'show advanced options'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'remote proc trans'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'remote login timeout (s)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'remote query timeout (s)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'user options'							SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'max text repl size (B)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'clr enabled'							SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'remote admin connections'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'backup compression default'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'filestream access level'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'backup checksum default'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'external scripts enabled'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'column encryption enclave type'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Data processed daily limit in TB'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Data processed weekly limit in TB'	SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Data processed monthly limit in TB'	SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'backup compression algorithm'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'contained database authentication'	SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'hadoop connectivity'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'polybase network encryption'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'remote data archive'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'allow polybase export'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'polybase enabled'						SET @valid  = 1
	-- advanced options
	IF RTRIM(LTRIM(@param_option)) = 'access check cache bucket count'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'access check cache quota'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Ad Hoc Distributed Queries'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ADR cleaner retry timeout (min)'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ADR Cleaner Thread Count'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ADR Preallocation Factor'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'affinity I/O mask'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'affinity mask'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'affinity64 I/O mask'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'affinity64 mask'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Agent XPs'							SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'allow filesystem enumeration'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'automatic soft-NUMA disabled'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'blocked process threshold (s)'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'c2 audit mode'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'clr strict security'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'common criteria compliance enabled'	SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'cost threshold for parallelism'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'cursor threshold'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Database Mail XPs'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'default full-text language'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'default trace enabled'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'disallow results from triggers'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'EKM provider enabled'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'fill factor (%)'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ft crawl bandwidth (max)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ft crawl bandwidth (min)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ft notify bandwidth (max)'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'ft notify bandwidth (min)'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'hardware offload config'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'hardware offload enabled'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'hardware offload mode'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'index create memory (KB)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'in-doubt xact resolution'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'lightweight pooling'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'locks'								SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'max degree of parallelism'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'max full-text crawl range'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'max server memory (MB)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'max worker threads'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'media retention'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'min memory per query (KB)'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'min server memory (MB)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'network packet size (B)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Ole Automation Procedures'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'open objects'							SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'openrowset auto_create_statistics'	SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'optimize for ad hoc workloads'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'PH timeout (s)'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'precompute rank'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'priority boost'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'query governor cost limit'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'query wait (s)'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'recovery interval (min)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Replication XPs'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'scan for startup procs'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'set working set size'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'SMO and DMO XPs'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'suppress recovery model errors'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'tempdb metadata memory-optimized'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'transform noise words'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'two digit year cutoff'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'user connections'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'version high part of SQL Server'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'version low part of SQL Server'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'xp_cmdshell'							SET @valid  = -1

	IF @valid  = -1
		BEGIN
			PRINT 'use tools.up_sp_configure_advanced_option_value'
			RETURN
		END
	IF @valid  = 0
		BEGIN
			PRINT 'invalid command'
			RETURN
		END

	BEGIN TRY
		DECLARE @ParamList NVARCHAR(2000)
		IF @param_value IS NULL 
			BEGIN
				SET @ParamList = N'@sp_configure_option Nvarchar(70)';  
				set @tsql = 'EXEC sp_configure ' + char(39) + @param_option + char(39)
				EXECUTE sp_executesql @tsql , @ParamList , @sp_configure_option = @param_option 
			END
		ELSE
			BEGIN
				SET @ParamList = N'@sp_configure_option Nvarchar(70), @sp_configure_value int';  
				set @tsql = 'EXEC sp_configure ' + char(39) + @param_option + char(39) + ',' + convert(char(10),@param_value)
				EXECUTE sp_executesql @tsql , @ParamList , @sp_configure_option = @param_option ,  @sp_configure_value = @param_value
			END
	END TRY
	BEGIN CATCH
		-- Execute error retrieval routine.
		SELECT
			 ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH; 
	go
-- whatever is being done within the body of this procedure, will be done by the internal_principal_ALTER_DB
-- therefore the deployment needs to be secured in that nobody can introduce malicious code here
-- calling the internal proc and passing on the parameter values:
GO
-------------------------------------------------------------------------------
-- no need to grant execute directly to the user or login, grant to the ROLE -- 
-------------------------------------------------------------------------------
--GRANT EXECUTE ON tools.up_sp_configure_option_value	TO user_internal_principal_spconfigure
--GRANT EXECUTE ON tools.up_sp_configure				TO user_internal_principal_spconfigure
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
GRANT EXECUTE ON tools.up_sp_configure_option_value	TO role_internal_principal_spconfigure -- WITH GRANT OPTION;  

-- go to 8B to show how DBAs can use these SPs
-- login as "login_internal_principal_spconfigure"
-- '<password-place-holder>' 



DROP PROC IF EXISTS tools.up_sp_configure_advanced_option_value -- up_sp_configure_option_value
GO
CREATE OR ALTER PROC tools.up_sp_configure_advanced_option_value
@param_option Nvarchar(70),
@param_value int = NULL
--WITH EXECUTE AS 'sa' -- OWNER --- 'user_internal_principal_spconfigure'
AS
	-----------------------------------
	-- PREVENT SQL INJECTION
	-----------------------------------
	-- validate input parameter: @param_option
	IF PATINDEX('%;%',@param_option) + PATINDEX('%--%',@param_option) + PATINDEX('%/*%',@param_option) + PATINDEX('%*/%',@param_option) <> 0 	   --  + PATINDEX('%''%',@param_option) 
	BEGIN
		IF PATINDEX('%;%',@param_option) <> 0   PRINT 'using ;'     + ' at: ' + CAST(PATINDEX('%;%'  ,@param_option) as CHAR(10))	--IF PATINDEX('%''%',@param_option)  <> 0 PRINT 'using '      + ' at: ' + CHAR(39) + CHAR(39) + ' at: ' + CAST(PATINDEX('%''%' ,@param_option) as CHAR(10))
		IF PATINDEX('%--%',@param_option) <> 0  PRINT 'using --'    + ' at: ' + CAST(PATINDEX('%--%' ,@param_option) as CHAR(10))
		IF PATINDEX('%/*%',@param_option) <> 0  PRINT 'using /*'    + ' at: ' + CAST(PATINDEX('%/*%' ,@param_option) as CHAR(10))
		IF PATINDEX('%*/%',@param_option) <> 0  PRINT 'using */'    + ' at: ' + CAST(PATINDEX('%*/%' ,@param_option) as CHAR(10))
		IF PATINDEX('%xp_%',@param_option) <> 0  PRINT 'using xp_'  + ' at: ' + CAST(PATINDEX('%xp_%',@param_option) as CHAR(10))
		PRINT 'smells like trouble !'
		RETURN
	END
	-----------------------------------
	-- PREVENT SQL INJECTION
	-----------------------------------
	declare @tsql nvarchar(1000)
	declare @valid smallint = 0
	--PRINT '@param_option = ' + '*' + RTRIM(LTRIM(@param_option))+'*'
	--PRINT '@param_value =  ' + '*' + ISNULL( CONVERT(char(10),RTRIM(LTRIM(@param_value))),'NULL' )+'*'
	IF RTRIM(LTRIM(@param_option)) = 'allow updates'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'nested triggers'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'server trigger recursion'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'remote access'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'default language'						SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'cross db ownership chaining'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'show advanced options'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'remote proc trans'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'remote login timeout (s)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'remote query timeout (s)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'user options'							SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'max text repl size (B)'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'clr enabled'							SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'remote admin connections'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'backup compression default'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'filestream access level'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'backup checksum default'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'external scripts enabled'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'column encryption enclave type'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Data processed daily limit in TB'		SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Data processed weekly limit in TB'	SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'Data processed monthly limit in TB'	SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'backup compression algorithm'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'contained database authentication'	SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'hadoop connectivity'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'polybase network encryption'			SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'remote data archive'					SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'allow polybase export'				SET @valid  = -1
	IF RTRIM(LTRIM(@param_option)) = 'polybase enabled'						SET @valid  = -1
	-- advanced options
	IF RTRIM(LTRIM(@param_option)) = 'access check cache bucket count'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'access check cache quota'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Ad Hoc Distributed Queries'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ADR cleaner retry timeout (min)'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ADR Cleaner Thread Count'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ADR Preallocation Factor'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'affinity I/O mask'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'affinity mask'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'affinity64 I/O mask'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'affinity64 mask'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Agent XPs'							SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'allow filesystem enumeration'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'automatic soft-NUMA disabled'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'blocked process threshold (s)'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'c2 audit mode'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'clr strict security'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'common criteria compliance enabled'	SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'cost threshold for parallelism'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'cursor threshold'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Database Mail XPs'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'default full-text language'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'default trace enabled'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'disallow results from triggers'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'EKM provider enabled'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'fill factor (%)'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ft crawl bandwidth (max)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ft crawl bandwidth (min)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ft notify bandwidth (max)'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'ft notify bandwidth (min)'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'hardware offload config'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'hardware offload enabled'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'hardware offload mode'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'index create memory (KB)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'in-doubt xact resolution'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'lightweight pooling'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'locks'								SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'max degree of parallelism'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'max full-text crawl range'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'max server memory (MB)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'max worker threads'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'media retention'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'min memory per query (KB)'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'min server memory (MB)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'network packet size (B)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Ole Automation Procedures'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'open objects'							SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'openrowset auto_create_statistics'	SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'optimize for ad hoc workloads'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'PH timeout (s)'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'precompute rank'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'priority boost'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'query governor cost limit'			SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'query wait (s)'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'recovery interval (min)'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'Replication XPs'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'scan for startup procs'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'set working set size'					SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'SMO and DMO XPs'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'suppress recovery model errors'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'tempdb metadata memory-optimized'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'transform noise words'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'two digit year cutoff'				SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'user connections'						SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'version high part of SQL Server'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'version low part of SQL Server'		SET @valid  = 1
	IF RTRIM(LTRIM(@param_option)) = 'xp_cmdshell'							SET @valid  = 1

	IF @valid  = -1
		BEGIN
			PRINT 'use tools.up_sp_configure_option_value'
			RETURN
		END
	IF @valid  = 0
		BEGIN
			PRINT 'invalid command'
			RETURN
		END

	BEGIN TRY
		DECLARE @ParamList NVARCHAR(2000)
		IF @param_value IS NULL 
			BEGIN
				SET @ParamList = N'@sp_configure_option Nvarchar(70)';  
				set @tsql = 'EXEC sp_configure ' + char(39) + @param_option + char(39)
				EXECUTE sp_executesql @tsql , @ParamList , @sp_configure_option = @param_option 
			END
		ELSE
			BEGIN
				SET @ParamList = N'@sp_configure_option Nvarchar(70), @sp_configure_value int';  
				set @tsql = 'EXEC sp_configure ' + char(39) + @param_option + char(39) + ',' + convert(char(10),@param_value)
				EXECUTE sp_executesql @tsql , @ParamList , @sp_configure_option = @param_option ,  @sp_configure_value = @param_value
			END
	END TRY
	BEGIN CATCH
		-- Execute error retrieval routine.
		SELECT
			 ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH; 
	go
-- whatever is being done within the body of this procedure, will be done by the internal_principal_ALTER_DB
-- therefore the deployment needs to be secured in that nobody can introduce malicious code here
-- calling the internal proc and passing on the parameter values:
--
-------------------------------------------------------------------------------
-- no need to grant execute directly to the user or login, grant to the ROLE -- 
-------------------------------------------------------------------------------
-- GRANT EXECUTE ON tools.up_sp_configure_advanced_option_value TO user_internal_principal_spconfigure
-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
GRANT EXECUTE ON tools.up_sp_configure_advanced_option_value TO role_internal_principal_spconfigure -- WITH GRANT OPTION;  

use SQLSecurityDemoDB
GO
