-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

	-- select * from sys.objects where name = 'up_sp_DBCC_Statement'
	DROP PROC IF EXISTS dba_tools_dbcc.up_sp_DBCC_Statement
	GO
	CREATE OR ALTER PROC dba_tools_dbcc.up_sp_DBCC_statement
			@tsql_DBCC_command varchar(4000)
	WITH EXECUTE AS 'internal_principal_DBCC'
	AS
	-----------------------------------
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
	-----------------------------------
	declare @tsql nvarchar(1000)
	DECLARE @ParmDefinition NVARCHAR(500);  
	SET @ParmDefinition = N'@DBCC_Command varchar(2000)';  
	set @tsql = ' ' + @tsql_DBCC_command
	EXECUTE sp_executesql @tsql, @parmDefinition, @tsql_DBCC_command
	go

	-- Tests:
	---- fails due to ;
	declare @cmd varchar(2000)
	SET @cmd = 'DBCC SHRINKDATABASE (SQLSecurityDemoDB, 70);'
	EXECUTE dba_tools_dbcc.up_sp_DBCC_statement @cmd
	GO
	---- fails due to WITH
	declare @cmd varchar(2000)
	SET @cmd = 'DBCC SHRINKDATABASE ([SQLSecurityDemoDB], 80) WITH WAIT_AT_LOW_PRIORITY (ABORT_AFTER_WAIT = SELF);'
	EXECUTE dba_tools_dbcc.up_sp_DBCC_statement @cmd
	GO
	-- SQL Injection:
	---- fails due to DROP not part of the DBCC commands on SP wrapper 
	declare @cmd varchar(2000)
	SET @cmd = 'drop table HumanResources.Employee2;'
	EXECUTE dba_tools_dbcc.up_sp_DBCC_statement @cmd
	GO



---------------------------------------------------------------
---------------------------------------------------------------
-- Andreas suggest that is better to do 1 SP per DBCC command - as it is easier to GRANT to jr/sr/individual DBAs

	DROP PROC IF EXISTS dba_tools_dbcc.up_sp_DBCC_Statement_all_DBCCs
	GO
	CREATE OR ALTER PROC dba_tools_dbcc.up_sp_DBCC_Statement_all_DBCCs
			--@tsql_DBCC_command varchar(128),
			@tsql_DBCC_Param varchar(4000)
	WITH EXECUTE AS 'internal_principal_DBCC'
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
