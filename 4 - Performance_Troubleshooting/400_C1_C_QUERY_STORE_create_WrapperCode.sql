-- in Azure SQL Database remove the "USE Database" statements and open a new connection if necessary

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
-- make sure to login as sa
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


	-- Special wrapper stored proc that is executed under the context of the above created user: role_internal_principal_QueryStore
	DROP PROC IF EXISTS tools_QueryStore.up_sp_query_store_force_plan 
	GO
	CREATE OR ALTER PROC tools_QueryStore.up_sp_query_store_force_plan 
			@query_id bigint
		,	@plan_id bigint
	WITH EXECUTE AS 'internal_principal_QueryStore'
	AS
	-- whatever is being done within the body of this procedure, will be done by the internal_principal_QueryStore
	-- therefore the deployment needs to be secured in that nobody can introduce malicious code here
	-- calling the internal proc and passing on the parameter values:
	EXECUTE sp_query_store_force_plan
			@query_id	=  @query_id 
		,	@plan_id	=  @plan_id 
	GO

	DROP PROC IF EXISTS tools_QueryStore.up_sp_query_store_set_storage
	GO
	CREATE OR ALTER PROC tools_QueryStore.up_sp_query_store_set_storage
			@max_storage bigint
	WITH EXECUTE AS 'internal_principal_QueryStore'
	AS
	declare @tsql nvarchar(1000)
	DECLARE @ParmDefinition NVARCHAR(500);  
	SET @ParmDefinition = N'@maxstorage int';  
	set @tsql = 'ALTER DATABASE [SQLSecurityDemoDB]
		SET QUERY_STORE (MAX_STORAGE_SIZE_MB = ' + convert(char(5),@max_storage) + ')'
	EXECUTE sp_executesql @tsql, @parmDefinition, @max_storage
	go

