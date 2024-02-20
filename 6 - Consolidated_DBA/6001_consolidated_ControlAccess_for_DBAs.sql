----------------------------------------------------------
-- LOGIN as		sa
-- use password: '<P@ssw0rd-Pl@c3-H0ld3r>'
----------------------------------------------------------
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
use master
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

-- clean-up
	ALTER ROLE [db_backupoperator] DROP MEMBER [role_DBA_master]
	GO
	ALTER ROLE [db_owner] DROP MEMBER [role_DBA_master]
	GO
	ALTER ROLE [db_ddladmin] DROP  MEMBER [role_DBA_master]
	GO
	REVOKE ALTER ANY SENSITIVITY CLASSIFICATION to role_DBA_master
	GO
	ALTER ROLE [db_securityadmin] DROP MEMBER [role_DBA_master]
	GO
	use SQLSecurityDemoDB
	GO
	EXEC sp_helprolemember
	GO
	EXEC sp_helprole
	GO

	REVOKE SELECT ON DATABASE::SQLSecurityDemoDB TO [user_Test_DBA]
	GO
	ALTER ROLE [db_datareader] DROP MEMBER [user_Test_DBA]
	GO
	REVOKE SELECT ON DATABASE::SQLSecurityDemoDB TO [user_Test_DBA]
	GO		
	ALTER ROLE [db_datareader] DROP MEMBER [user_Test_DBA]
	GO
	DROP USER [user_Test_DBA]
	GO

use master
GO
	exec sp_helpdbfixedrole ;
	GO
	SELECT	
		 roles.principal_id							AS RolePrincipalID
		,roles.name									AS RolePrincipalName
		,server_role_members.member_principal_id		AS MemberPrincipalID
		,members.name								AS MemberPrincipalName
	FROM 
		sys.server_role_members AS server_role_members
		INNER JOIN sys.server_principals AS roles
			ON server_role_members.role_principal_id = roles.principal_id
		INNER JOIN sys.server_principals AS members 
			ON server_role_members.member_principal_id = members.principal_id  ;

	ALTER ROLE role_DBA_master DROP MEMBER [user_Test_DBA]
	GO
	DROP ROLE role_DBA_master
	GO
	ALTER SERVER ROLE server_role_DBA_master DROP MEMBER [login_Test_DBA]
	GO
	DROP SERVER ROLE server_role_DBA_master
	GO
	DROP USER [user_Test_DBA]
	GO
	DROP Login [Login_Test_DBA]
	GO

	sp_helprolemember
	


-- SELECT 'DROP PROCEDURE ' + 'custom_DBA_tools.'+name  FROM sys.objects where schema_id = schema_id('custom_DBA_tools')
DROP PROCEDURE custom_DBA_tools.up_sp_configure_show_advanced_options
GO
DROP PROCEDURE custom_DBA_tools.up_sp_configure
GO
DROP PROCEDURE custom_DBA_tools.up_sp_configure_option_value
GO
DROP PROCEDURE custom_DBA_tools.up_sp_configure_advanced_option_value
GO
DROP PROCEDURE custom_DBA_tools.up_sp_DBCC_statement
GO
DROP PROCEDURE custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs
GO
DROP PROCEDURE custom_DBA_tools.up_sp_readerrorlog
GO
DROP PROCEDURE custom_DBA_tools.up_sp_cycle_errorlog
GO
DROP PROCEDURE custom_DBA_tools.up_sp_query_store_set_storage
GO
DROP PROCEDURE custom_DBA_tools.up_sp_query_store_force_plan
GO
DROP SCHEMA custom_DBA_tools
GO

-- As a best practice use a Role
CREATE ROLE role_DBA_master
GO

CREATE SERVER ROLE server_role_DBA_master
GO

CREATE SCHEMA custom_DBA_tools
GO
------------------------------------------------------------------------------------



-- script [100_B1_create_Login_User.sql] 
	-- Grant permissions: FAILS
	-- used for WRAPPER CODE --> REVIEW
	--GRANT
	--	ALTER SETTINGS
	--	TO role_DBA_master
	--GO
	-- Grant permissions: succeed when granted to server role
	GRANT ALTER SETTINGS TO 	[server_role_DBA_master]
	GO

-- script [100_B2_wrapper_create_sp_configure.sql]

-->>> create the stored procedures on script [100_B2_wrapper_create_sp_configure.sql]

-->>>>> START: custom_DBA_tools.up_sp_configure_show_advanced_options
	-----------------------------------------------------------------------------------
	CREATE OR ALTER PROC custom_DBA_tools.up_sp_configure_show_advanced_options
	AS
	EXEC sys.sp_configure N'show advanced options', N'1'  
	RECONFIGURE WITH OVERRIDE
	GO
	GRANT EXECUTE ON custom_DBA_tools.up_sp_configure_show_advanced_options	TO [role_DBA_master]
	GO
	-- tests
	-- EXEC custom_DBA_tools.up_sp_configure_show_advanced_options
	-- 
	-----------------------------------------------------------------------------------
-->>>>> END: custom_DBA_tools.up_sp_configure_show_advanced_options

-->>>>> START: 
	-----------------------------------------------------------------------------------
	CREATE OR ALTER PROC custom_DBA_tools.up_sp_configure
	WITH EXECUTE AS OWNER -- 'user_internal_principal_spconfigure'
	AS
	EXEC sys.sp_configure
	GO
	GRANT EXECUTE ON custom_DBA_tools.up_sp_configure	TO [role_DBA_master]
	GO
	-- tests
	-- EXEC custom_DBA_tools.up_sp_configure
	-----------------------------------------------------------------------------------
-->>>>> END: 

-->>>>> START: 
	-----------------------------------------------------------------------------------
	CREATE OR ALTER PROC custom_DBA_tools.up_sp_configure_option_value
	@param_option Nvarchar(70),
	@param_value int = NULL
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
	GO
	GRANT EXECUTE ON custom_DBA_tools.up_sp_configure_option_value	TO [role_DBA_master]
	GO

	-----------------------------------------------------------------------------------
-->>>>> END: 


-->>>>> START: 
	-----------------------------------------------------------------------------------
	CREATE OR ALTER PROC custom_DBA_tools.up_sp_configure_advanced_option_value
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

	GRANT EXECUTE ON custom_DBA_tools.up_sp_configure_advanced_option_value TO [role_DBA_master]
	GO
	-----------------------------------------------------------------------------------
-->>>>> END: 

-->>> create the stored procedures on script [100_B2_wrapper_create_sp_configure.sql]


-- script [DB_Maintenance\200_A1_A_create_DBA_for_Backup.sql]
	ALTER ROLE [db_backupoperator] ADD MEMBER [role_DBA_master]
	GO

-- script [DB_Maintenance\200_D1_B_create_elevated_logins_roles.sql]
--- SKIPPED -----------------------------------------------------------
	-- SKIP -- ALTER ROLE [db_owner] ADD MEMBER [role_DBA_master]
	-- SKIP --GO
--- SKIPPED -----------------------------------------------------------

	-- we need to let DBAs to read masked data
	-- ALTER ROLE [db_denydatareader] ADD MEMBER [role_DBA_master]
	-- GO

	-- Permissions to view the Query Store catalogue views and other DMVs
	GRANT
		VIEW DATABASE STATE
		TO role_DBA_master

	-- Grant Permission to execute the Wrapper procedures via a dedicated Schema to the role
	GRANT
		EXECUTE
		ON SCHEMA::custom_DBA_tools
		TO role_DBA_master
	GO
-- script [200_D1_C_create_elevated_SPs.sql]
-->>> create the stored procedures on script [200_D1_C_create_elevated_SPs.sql]

-->>>>> START: 
	-----------------------------------------------------------------------------------
		CREATE OR ALTER PROC custom_DBA_tools.up_sp_DBCC_statement
				@tsql_DBCC_command varchar(4000)
		--WITH EXECUTE AS 'internal_principal_DBCC'
		AS
	
		-- validate input parameters: 
		IF PATINDEX('%;%',@tsql_DBCC_command) + PATINDEX('%--%',@tsql_DBCC_command) + PATINDEX('%/*%',@tsql_DBCC_command) + PATINDEX('%*/%',@tsql_DBCC_command) <> 0 	   --  + PATINDEX('%''%',@tsql_DBCC_Param) 
		BEGIN
			IF PATINDEX('%;%',@tsql_DBCC_command) <> 0   PRINT 'using ;'    + ' at column: ' + CAST(PATINDEX('%;%'  ,@tsql_DBCC_command) as CHAR(10))		--IF PATINDEX('%''%',@@tsql_DBCC_command)  <> 0 PRINT 'using '      + ' at: ' + CHAR(39) + CHAR(39) + ' at: ' + CAST(PATINDEX('%''%' ,@tsql_DBCC_Param) as CHAR(10))
			IF PATINDEX('%--%',@tsql_DBCC_command) <> 0  PRINT 'using --'   + ' at column: ' + CAST(PATINDEX('%--%' ,@tsql_DBCC_command) as CHAR(10))
			IF PATINDEX('%/*%',@tsql_DBCC_command) <> 0  PRINT 'using /*'   + ' at column: ' + CAST(PATINDEX('%/*%' ,@tsql_DBCC_command) as CHAR(10))
			IF PATINDEX('%*/%',@tsql_DBCC_command) <> 0  PRINT 'using */'   + ' at column: ' + CAST(PATINDEX('%*/%' ,@tsql_DBCC_command) as CHAR(10))
			IF PATINDEX('%xp_%',@tsql_DBCC_command) <> 0 PRINT 'using xp_'  + ' at column: ' + CAST(PATINDEX('%xp_%',@tsql_DBCC_command) as CHAR(10))
			RAISERROR ('invalid parameters' , 16 , 1);
			RETURN
		END
	
		declare @tsql nvarchar(1000)
		DECLARE @ParmDefinition NVARCHAR(500);  
		SET @ParmDefinition = N'@DBCC_Command varchar(2000)';  
		set @tsql = ' ' + @tsql_DBCC_command
		EXECUTE sp_executesql @tsql, @parmDefinition, @tsql_DBCC_command
		go

	GRANT EXECUTE ON custom_DBA_tools.up_sp_DBCC_statement TO [role_DBA_master]
	GO
	-----------------------------------------------------------------------------------

-->>>>> END: 


-->>>>> START: 
	-----------------------------------------------------------------------------------
		CREATE OR ALTER PROC custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs
				--@tsql_DBCC_command varchar(128),
				@tsql_DBCC_Param varchar(4000)
		-- WITH EXECUTE AS 'internal_principal_DBCC'
		AS
		-----------------------------------
		-- PREVENT SQL INJECTION
		-----------------------------------
		-- validate input parameter: @tsql_DBCC_command
		IF PATINDEX('%;%',@tsql_DBCC_Param) + PATINDEX('%--%',@tsql_DBCC_Param) + PATINDEX('%/*%',@tsql_DBCC_Param) + PATINDEX('%*/%',@tsql_DBCC_Param) <> 0 
		   --  + PATINDEX('%''%',@tsql_DBCC_Param) 
		BEGIN
			IF PATINDEX('%;%',@tsql_DBCC_Param) <> 0   PRINT 'using ;'     + ' at: ' + CAST(PATINDEX('%;%'  ,@tsql_DBCC_Param) as CHAR(10))
			--IF PATINDEX('%''%',@tsql_DBCC_Param)  <> 0 PRINT 'using '      + ' at: ' + CHAR(39) + CHAR(39) + ' at: ' + CAST(PATINDEX('%''%' ,@tsql_DBCC_Param) as CHAR(10))
			IF PATINDEX('%--%',@tsql_DBCC_Param) <> 0  PRINT 'using --'    + ' at: ' + CAST(PATINDEX('%--%' ,@tsql_DBCC_Param) as CHAR(10))
			IF PATINDEX('%/*%',@tsql_DBCC_Param) <> 0  PRINT 'using /*'    + ' at: ' + CAST(PATINDEX('%/*%' ,@tsql_DBCC_Param) as CHAR(10))
			IF PATINDEX('%*/%',@tsql_DBCC_Param) <> 0  PRINT 'using */'    + ' at: ' + CAST(PATINDEX('%*/%' ,@tsql_DBCC_Param) as CHAR(10))
			IF PATINDEX('%xp_%',@tsql_DBCC_Param) <> 0  PRINT 'using xp_'  + ' at: ' + CAST(PATINDEX('%xp_%',@tsql_DBCC_Param) as CHAR(10))
			PRINT 'smells like trouble !'
			RETURN
		END
		-----------------------------------
		-- PREVENT SQL INJECTION
		-----------------------------------

		declare @tsql nvarchar(1000)
		declare @valid bit = 0
		declare @tsql_DBCC_command varchar(128)
		SET @tsql_DBCC_command = SUBSTRING( @tsql_DBCC_Param , 1 , (CHARINDEX( ' ' , @tsql_DBCC_Param))-1) 
		-- PRINT '*'+RTRIM(LTRIM(@tsql_DBCC_command))+'*'
		-- PRINT '@tsql_DBCC_Param = ' + @tsql_DBCC_Param 
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKALLOC'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKCATALOG'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKCONSTRAINTS'	SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKDB'				SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKFILEGROUP'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKIDENT'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CHECKTABLE'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CLEANTABLE'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'CLONEDATABASE'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'DBREINDEX'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'dllname'				SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'DROPCLEANBUFFERS'	SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'FREEPROCCACHE'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'FREESESSIONCACHE'	SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'FREESYSTEMCACHE'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'HELP'				SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'INDEXDEFRAG'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'INPUTBUFFER'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'OPENTRAN'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'OUTPUTBUFFER'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'PROCCACHE'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'SHOW_STATISTICS'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'SHOWCONTIG'			SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'SHRINKDATABASE'		SET @valid  = 1
		IF RTRIM(LTRIM(@tsql_DBCC_command)) = 'SHRINKFILE'			SET @valid  = 1
		IF @valid  = 0
			BEGIN
				PRINT 'invalid DBCC command'
				RETURN
			END

		BEGIN TRY
			DECLARE @ParamList NVARCHAR(2000)
			SET @ParamList = N'@DBCC_command Nvarchar(2000)';  
			set @tsql = 'DBCC ' + @tsql_DBCC_Param 
			EXECUTE sp_executesql @tsql-- , @ParamList , @tsql_DBCC_Param 
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
	GRANT EXECUTE ON custom_DBA_tools.up_sp_DBCC_Statement_all_DBCCs TO [role_DBA_master]
	GO
	-----------------------------------------------------------------------------------

-->>>>> END: 



-->>> create the stored procedures on script [200_D1_C_create_elevated_SPs.sql]

-- script [200_A2_A_create_DBA_for_RESTORE.sql]
	-- FAILS: needs to grant to a LOGIN
	--GRANT CREATE ANY DATABASE TO role_DBA_master
	--GO
	-- SUCCEED when granting to SERVER ROLE
	GRANT CREATE ANY DATABASE TO [server_role_DBA_master]
	GO
	--  this works, so we need to validate/compare CREATE DATABASE vs CREATE ANY DATABASE 
	GRANT CREATE DATABASE TO role_DBA_master
	GO
	-- FAILS: needs to grant to a LOGIN
	--GRANT ALTER ANY DATABASE TO role_DBA_master
	--GO
	-- SUCCEED when granting to server role
	GRANT ALTER ANY DATABASE TO [server_role_DBA_master]
	GO

-- script [200_B1_A_Create_DBA_with_db_ddlAdmin.sql]
	-- Grant permissions
	ALTER ROLE [db_ddladmin] ADD MEMBER [role_DBA_master]
	GO

-- script [200_B1_B_test_DBA_with_db_ddlAdmin_index_Maintenance.sql]
	GRANT ALTER ANY SENSITIVITY CLASSIFICATION 	to role_DBA_master
	GO
-- script [200_D1_B_create_elevated_logins_roles.sql]
	-- Grant permissions
	---------------------------------------------------------------
	-- WE DON'T WANT TO GRANT db_owner
	-- as anyone in db_owner can change his/her own access/rights
	---------------------------------------------------------------
	--ALTER ROLE [db_owner] ADD MEMBER [role_internal_principal_DBCC]
	--GO
	-- Permissions to view the Query Store catalogue views and other DMVs
	GRANT
		VIEW DATABASE STATE
		TO role_DBA_master
	GO
	-- Grant Permission to execute the Wrapper procedures via a dedicated Schema to the role
	GRANT
		EXECUTE
		ON SCHEMA::custom_DBA_tools
		TO role_DBA_master
	GO

-- script [200_D27_A_Create_DBA_with_ServerAdmin.sql]
	-------------------------------------------------------------------
	----------------- used to stop/start/restart SQL  -----------------
	-------------------------- NEEDS TO BE REVIEWED -------------------
	-------------------------------------------------------------------

	/*
		ALTER SERVER ROLE [serveradmin] ADD MEMBER [DBA_with_ServerAdmin]
		GO
	*/

	---------------------------------------------------------------
	-- WE DON'T WANT TO GRANT serveradmin to anyone
	-- as anyone in serveradmin can change his/her own access/rights
	---------------------------------------------------------------
	-- ALTER SERVER ROLE [serveradmin] ADD MEMBER [DBA_with_ServerAdmin]
	-- GO
	-------------------------------------------------------------------
	----------------- used to stop/start/restart SQL  -----------------
	-------------------------- NEEDS TO BE REVIEWED -------------------
	-------------------------------------------------------------------

-- script [300_A1_A_CREATE_DBA_with_AlterAnyLogin.sql]
	-- FAILS as it expects a LOGIN 
	-- GRANT ALTER ANY LOGIN TO [role_DBA_master]
	-- GO
	-- but will  succeed if we grant to the SERVER ROLE
	GRANT ALTER ANY LOGIN TO [server_role_DBA_master]
	GO

-- script [300_B1_A_CREATE_DBA_with_AlterAnyUser.sql]
	-- succeeds as it expects a LOGIN 
	GRANT ALTER ANY USER to [role_DBA_master]
	GO


-- script [300_C1_A_CREATE_DBA_with._CreateRole.sql]
	ALTER ROLE [db_securityadmin] ADD MEMBER [role_DBA_master]
	GO

-- script [400_A2_A_Create_Internal_LoginUserRole_for_errorlog.sql]
	-- Grant the user the EXECUTE permission on xp_readerrorlog
	GRANT EXECUTE ON xp_readerrorlog TO [role_DBA_master]
	GO
	GRANT EXECUTE ON sp_readerrorlog TO [role_DBA_master]
	GO
	-- FAILS as it expect a login
	-- GRANT VIEW ANY ERROR LOG TO [role_DBA_master]
	-- GO
	-- succeeds 
	GRANT VIEW ANY ERROR LOG TO [server_role_DBA_master]
	GO
	--------------------------------------------------------------------------------------
	-- to check if needed:
	--------------------------------------------------------------------------------------
	/*
	GRANT -- revoke
		CONTROL
		--	TO login_internal_principal_spconfigure
		TO role_internal_principal_errorlog
	GO

	GRANT
		ALTER
		--	TO login_internal_principal_spconfigure
		TO role_internal_principal_errorlog
	GO

	--IF (not is_srvrolemember(N'securityadmin') = 1) AND (not HAS_PERMS_BY_NAME(null, null, 'VIEW SERVER STATE') = 1) AND (not HAS_PERMS_BY_NAME(null, null, 'VIEW ANY ERROR LOG') = 1)
	GRANT
		VIEW SERVER STATE
		TO [login_internal_principal_errorlog]
	GO
	*/
	--------------------------------------------------------------------------------------
	-- to check if needed:
	--------------------------------------------------------------------------------------

-- script [400_A2_B_create_wrapper_code_for_errorlog.sql]
-->>> create the stored procedures on script [400_A2_B_create_wrapper_code_for_errorlog.sql]

-->>>>> START: 

	-----------------------------------------------------------------------------------
		CREATE OR ALTER PROC custom_DBA_tools.up_sp_readerrorlog
			@par1 int = 0, -- log number
			@par2 int = null, -- product id: 1 for SQL Server, 2 for Agent 
			@par3 nvarchar(4000) = NULL, -- string-to-search-1
			@par4 nvarchar(4000) = NULL -- string-to-search-2
		AS
		if (@par2 is NULL)
			EXEC sys.sp_readerrorlog @par1
		else
			EXEC sys.sp_readerrorlog @par1, @par2, @par3, @par4 
		GO
		-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
		GRANT EXECUTE ON OBJECT::custom_DBA_tools.up_sp_readerrorlog TO [role_DBA_master]
		GO
		GRANT EXECUTE ON OBJECT::sys.sp_readerrorlog TO [role_DBA_master]
		GO

	-----------------------------------------------------------------------------------

-->>>>> END: 


-->>>>> START: 

	-----------------------------------------------------------------------------------
		CREATE OR ALTER PROC custom_DBA_tools.up_sp_cycle_errorlog
		AS
		EXEC sys.sp_cycle_errorlog 
		GO
		-------------------------------------------------------------------------------
		-- no need to grant execute directly to the user or login, grant to the ROLE -- 
		-------------------------------------------------------------------------------
		-- https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-transact-sql?view=sql-server-ver16#with-grant-option
		GRANT EXECUTE ON OBJECT::custom_DBA_tools.up_sp_cycle_errorlog TO [role_DBA_master]
		GO
	-----------------------------------------------------------------------------------

-->>>>> END: 
-->>> create the stored procedures on script [400_A2_B_create_wrapper_code_for_errorlog.sql]


	GRANT EXECUTE ON OBJECT::sys.sp_readerrorlog TO [role_DBA_master]
	GO
	GRANT EXECUTE ON OBJECT::custom_DBA_tools.up_sp_cycle_errorlog TO [role_DBA_master]
	GO
	GRANT EXECUTE ON sp_cycle_errorlog TO [role_DBA_master]
	GO
	-- this is for Azure SQL MI
	GRANT EXECUTE ON sys.sp_helpdb TO [role_DBA_master]
	GO
	GRANT EXECUTE ON sys.sp_cycle_errorlog TO [role_DBA_master]
	GO
	GRANT EXECUTE ON OBJECT::sys.sp_cycle_errorlog TO [role_DBA_master]
	GO  



-- script [400_B1_A_Create_DBA_with_ServerPerformance.sql]
	-- THIS IS FOR SQL Server on VM or Azure SQL Managed Instance
	use [master]
	GO
	GRANT VIEW SERVER PERFORMANCE STATE TO [server_role_DBA_master]
	GO
	GRANT VIEW SERVER STATE TO [server_role_DBA_master]
	GO
	-- THIS IS VM or Azure SQL Database:
	GRANT VIEW DATABASE PERFORMANCE STATE TO [role_DBA_master]
	GO
	GRANT VIEW SERVER STATE TO [server_role_DBA_master]
	GO
	-- GRANT exec on sys.sp_readerrorlog TO [DBA_with_PerformanceTroubleshooting]
	GRANT exec on xp_readerrorlog  TO [role_DBA_master]
	GO
	GRANT exec on sys.sp_enumerrorlogs  TO [role_DBA_master]
	GO
	GRANT exec on sys.sp_cycle_errorlog  TO [role_DBA_master]
	GO
	GRANT EXECUTE ON sp_cycle_errorlog TO [role_DBA_master]
	GO


-- script [400_B1_C1_SQLServer_on_VM_Grant_AlterAnyConnection_to_DBA_with_ServerPerformance.sql]
	GRANT ALTER ANY CONNECTION TO [server_role_DBA_master]
	GO

-- script [400_C1_A_Create_DBA_for_QueryStore.sql:]
-- Permissions to view the Query Store catalogue views and other DMVs
	GRANT VIEW DATABASE STATE TO [role_DBA_master]
	GO
	-- Grant Permission to execute the Wrapper procedures via a dedicated Schema to the role
	GRANT EXECUTE ON SCHEMA::custom_DBA_tools TO [role_DBA_master]
	GO

-- script [400_C1_B_QUERY_STORE_create_elevated_logins_roles.sql]
	-- Grant permissions
	GRANT ALTER TO [role_DBA_master]
	GO

-- script [400_C1_C_QUERY_STORE_create_WrapperCode.sql]
-->>> create the stored procedures on script [400_C1_C_QUERY_STORE_create_WrapperCode.sql]

-->>>>> START: 
	-----------------------------------------------------------------------------------
		CREATE OR ALTER PROC custom_DBA_tools.up_sp_query_store_force_plan 
				@query_id bigint
			,	@plan_id bigint
		-- WITH EXECUTE AS 'internal_principal_QueryStore'
		AS
		-- whatever is being done within the body of this procedure, will be done by the internal_principal_QueryStore
		-- therefore the deployment needs to be secured in that nobody can introduce malicious code here
		-- calling the internal proc and passing on the parameter values:
		EXECUTE sp_query_store_force_plan
				@query_id	=  @query_id 
			,	@plan_id	=  @plan_id 
		GO
		GRANT EXECUTE ON OBJECT::custom_DBA_tools.up_sp_query_store_force_plan TO [role_DBA_master]
		GO
	-----------------------------------------------------------------------------------

-->>>>> END: 



-->>>>> START: 
	-----------------------------------------------------------------------------------
		CREATE OR ALTER PROC custom_DBA_tools.up_sp_query_store_set_storage
				@max_storage bigint
		-- WITH EXECUTE AS 'internal_principal_QueryStore'
		AS
		declare @tsql nvarchar(1000)
		DECLARE @ParmDefinition NVARCHAR(500);  
		SET @ParmDefinition = N'@maxstorage int';  
		set @tsql = 'ALTER DATABASE [SQLSecurityDemoDB]
			SET QUERY_STORE (MAX_STORAGE_SIZE_MB = ' + convert(char(5),@max_storage) + ')'
		EXECUTE sp_executesql @tsql, @parmDefinition, @max_storage
		go
		GRANT EXECUTE ON OBJECT::custom_DBA_tools.up_sp_query_store_set_storage TO [role_DBA_master]
		GO
	-----------------------------------------------------------------------------------

-->>>>> END: 

-->>> create the stored procedures on script [400_C1_C_QUERY_STORE_create_WrapperCode.sql]



-- script [400_E1_B1_A_Create_DBA_with_ALTER_ANY_EVENT_SESSION.sql]
	-- FAILS as it requires a LOGIN
	-- GRANT ALTER ANY EVENT SESSION TO [role_DBA_master]
	-- SUCCEEED as it allows a server-role
	GRANT ALTER ANY EVENT SESSION TO [server_role_DBA_master]
	GO


-- script [400_E1_B1_B_Create_DBA_with_VIEW_SERVER_PERFORMANCE_STATE_for_XEVENTS.SQL]
	-- FAILS as it requires a LOGIN
	-- GRANT VIEW SERVER PERFORMANCE STATE TO [role_DBA_master] 
	-- SUCCEEED as it allows a server-role
	GRANT VIEW SERVER PERFORMANCE STATE TO  [server_role_DBA_master]
	GO


-- script [400_E1_B2_Create_DBA_with_ALTER_ANY_DATABASE_EVENT_SESSION.SQL]
	GRANT ALTER ANY EVENT SESSION TO [server_role_DBA_master]
	GO


-- script []


-- script [Performance_Troubleshooting\400_A2_A_Create_Internal_LoginUserRole_for_errorlog.sql]
-- no need to execute as this is 'repeated' from script [DB_Maintenance\200_D1_B_create_elevated_logins_roles.sql]
	-- we want DBAs to read from tables - they will read masked data
	-- ALTER ROLE [db_denydatareader] ADD MEMBER [role_DBA_master]
	-- GO
	-- Grant the user the EXECUTE permission on xp_readerrorlog
	GRANT EXECUTE ON xp_readerrorlog TO [role_DBA_master]
	GO
	GRANT EXECUTE ON sp_readerrorlog TO [role_DBA_master]
	GO
	-- 
	GRANT
		VIEW ANY ERROR LOG
		TO [server_role_DBA_master]
	GO
	-- line 61-78 (not executed on original script, need to review if it is needed)
	-- Grant permissions
	GRANT -- revoke
		CONTROL
		TO [role_DBA_master]
	GO
	GRANT
		ALTER
		TO [role_DBA_master]
	GO
	-- 
	GRANT
		VIEW SERVER STATE
		TO [server_role_DBA_master]
	GO

-- script [Performance_Troubleshooting\400_C1_A_Create_DBA_for_QueryStore.sql]
	-- Permissions to view the Query Store catalogue views and other DMVs
	GRANT
		VIEW DATABASE STATE
		TO [role_DBA_master]

	GRANT
		EXECUTE
		ON SCHEMA::custom_DBA_tools
		TO [role_DBA_master]
	GO
-- script [Performance_Troubleshooting\400_C1_B_QUERY_STORE_create_elevated_logins_roles.sql]
	-- Grant permissions
	GRANT
		ALTER
		TO [role_DBA_master]
	GO
