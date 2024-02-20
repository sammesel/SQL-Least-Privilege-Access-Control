# https://learn.microsoft.com/en-us/powershell/module/az.sql/set-azsqlservermssupportaudit?view=azps-11.3.0

## Description
## The Set-AzSqlServerMSSupportAudit cmdlet changes the Microsoft support operations auditing settings of an Azure SQL 
##	server. To use the cmdlet, use the ResourceGroupName and ServerName parameters to identify the server. When blob 
##	storage is a destination for audit logs, specify the StorageAccountResourceId parameter to determine the storage 
##	account for the audit logs.

### Examples
### Example 1: Enable the blob storage Microsoft support operations auditing policy of an Azure SQL server
Set-AzSqlServerMSSupportAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -BlobStorageTargetState Enabled -StorageAccountResourceId "/subscriptions/7fe3301d-31d3-4668-af5e-211a890ba6e3/resourceGroups/resourcegroup01/providers/Microsoft.Storage/storageAccounts/mystorage"

### Example 2: Disable the blob storage Microsoft support operations auditing policy of an Azure SQL serve
Set-AzSqlServerMSSupportAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -BlobStorageTargetState Disabled

### Example 3: Enable the event hub Microsoft support operations auditing policy of an Azure SQL server
Set-AzSqlServerMSSupportAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -EventHubTargetState Enabled -EventHubName "EventHubName" -EventHubAuthorizationRuleResourceId "EventHubAuthorizationRuleResourceId"

### Example 4: Disable the event hub Microsoft support operations auditing policy of an Azure SQL server
Set-AzSqlServerMSSupportAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -EventHubTargetState Disabled

