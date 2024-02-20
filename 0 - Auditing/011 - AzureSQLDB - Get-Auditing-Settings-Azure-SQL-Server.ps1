## https://learn.microsoft.com/en-us/powershell/module/az.sql/get-azsqlserveraudit?view=azps-11.3.0

## Get-AzSqlServerAudit -ResourceGroupName "resourcegroup01" -ServerName "server01"

<#
	ServerName                          : server01
	ResourceGroupName                   : resourcegroup01
	AuditActionGroup                    : {SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP, FAILED_DATABASE_AUTHENTICATION_GROUP,
										   BATCH_COMPLETED_GROUP, ...}
	PredicateExpression                 : statement <> 'select 1'
	BlobStorageTargetState              : Enabled
	StorageAccountResourceId            : /subscriptions/7fe3301d-31d3-4668-af5e-211a890ba6e3/resourceGroups/resourcegroup01/providers/Microsoft.Storage/storageAccounts/mystorage
	StorageKeyType                      : Primary
	RetentionInDays                     : 0
	EventHubTargetState                 : Enabled
	EventHubName                        : eventHubName
	EventHubAuthorizationRuleResourceId : EventHubAuthorizationRuleResourceId
	LogAnalyticsTargetState             : Enabled
	WorkspaceResourceId                 : "/subscriptions/4b9e8510-67ab-4e9a-95a9-e2f1e570ea9c/resourceGroups/insights-integration/providers/Microsoft.OperationalInsights/workspaces/viruela2"
#>

# example 1:
$ResourceGroup = 'azuresql-db-mi-demos'
$AzureSQLDB_ServerName = 'azuresql-db-server001'
$AzureSQLDB_DatabaseName= 'SQLSecurityDemoDB'

Get-AzSqlServerAudit -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName


# example 2:
Get-AzSqlServer -ResourceGroupName $ResourceGroup  -ServerName $AzureSQLDB_ServerName | Get-AzSqlServerAudit

<#
	PS C:\Users\sammes\OneDrive - Microsoft\GBB SHARE\customer presentation\Elevance\TDE_DDM\DDM_de,ps\2 - DB_Maintenance> Get-AzSqlServer -ResourceGroupName $ResourceGroup  -ServerName $AzureSQLDB_ServerName | Get-AzSqlServerAudit

	AuditActionGroup                    : {SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP, FAILED_DATABASE_AUTHENTICATION_GROUP, BATCH_COMPLETED_GROUP}
	PredicateExpression                 : 
	StorageKeyType                      : None
	RetentionInDays                     : 
	ResourceGroupName                   : azuresql-db-mi-demos
	ServerName                          : azuresql-db-server001
	BlobStorageTargetState              : Disabled
	StorageAccountResourceId            : 
	EventHubTargetState                 : Disabled
	EventHubName                        : 
	EventHubAuthorizationRuleResourceId : 
	LogAnalyticsTargetState             : Enabled
	WorkspaceResourceId                 : /subscriptions/7a137730-0356-45cf-a05f-10d040b5e69b/resourcegroups/azuresql-db-mi-demos/providers/microsoft.operationalinsights/workspaces/azuresql
										  dbmidemosloganalytics
#>

