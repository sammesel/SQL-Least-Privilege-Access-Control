# https://learn.microsoft.com/en-us/powershell/module/az.sql/get-azsqldatabaseaudit?view=azps-11.3.0

##Description
##The Get-AzSqlDatabaseAudit cmdlet gets the auditing settings of an Azure SQL database. To use the cmdlet, use the ResourceGroupName, ServerName, and DatabaseName parameters to identify the database.

##Examples
##Example 1: Get the auditing settings of an Azure SQL database


$ResourceGroup = 'azuresql-db-mi-demos'
$AzureSQLDB_ServerName = 'azuresql-db-server001'
$AzureSQLDB_DatabaseName= 'SQLSecurityDemoDB'

Get-AzSqlDatabaseAudit -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName -DatabaseName $AzureSQLDB_DatabaseName

##Example 2: Get, through pipeline, the auditing settings of an Azure SQL database
Get-AzSqlDatabase -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName -DatabaseName $AzureSQLDB_DatabaseName | Get-AzSqlDatabaseAudit

<#

	PS C:\Users\sammes\OneDrive - Microsoft\GBB SHARE\customer presentation\Elevance\TDE_DDM\DDM_de,ps\2 - DB_Maintenance> Get-AzSqlDatabase -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName -DatabaseName $AzureSQLDB_DatabaseName | Get-AzSqlDatabaseAudit

	WARNING: Upcoming breaking changes in the cmdlet 'Get-AzSqlDatabase' :
	- The output type 'Microsoft.Azure.Commands.Sql.Database.Model.AzureSqlDatabaseModel' is changing
	- The following properties in the output type are being deprecated : 'BackupStorageRedundancy'
	- The following properties are being added to the output type : 'CurrentBackupStorageRedundancy' 'RequestedBackupStorageRedundancy'
	- The change is expected to take effect from the version : '3.0.0'
	Note : Go to https://aka.ms/azps-changewarnings for steps to suppress this breaking change warning, and other information on breaking changes in Azure PowerShell.


	DatabaseName                        : SQLSecurityDemoDB
	AuditAction                         : {}
	AuditActionGroup                    : {SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP, FAILED_DATABASE_AUTHENTICATION_GROUP, BATCH_COMPLETED_GROUP}
	PredicateExpression                 : 
	StorageKeyType                      : Primary
	RetentionInDays                     : 93
	ResourceGroupName                   : azuresql-db-mi-demos
	ServerName                          : azuresql-db-server001
	BlobStorageTargetState              : Enabled
	StorageAccountResourceId            : /subscriptions/7a137730-0356-45cf-a05f-10d040b5e69b/resourceGroups/azuresql-db-mi-demos/providers/Microsoft.Storage/storageAccounts/st4dbxferdatalo
										  gbackups
	EventHubTargetState                 : Disabled
	EventHubName                        : 
	EventHubAuthorizationRuleResourceId : 
	LogAnalyticsTargetState             : Enabled
	WorkspaceResourceId                 : /subscriptions/7a137730-0356-45cf-a05f-10d040b5e69b/resourcegroups/azuresql-db-mi-demos/providers/microsoft.operationalinsights/workspaces/azuresql
										  dbmidemosloganalytics


#>
