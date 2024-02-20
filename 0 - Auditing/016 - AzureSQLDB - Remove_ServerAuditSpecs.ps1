# https://learn.microsoft.com/en-us/powershell/module/az.sql/remove-azsqlserveraudit?view=azps-11.3.0

## Description
## The Remove-AzSqlServerAudit cmdlet removes the auditing settings of an Azure SQL server. Specify the ResourceGroupName 
##	and ServerName parameters to identify the server.

### Examples
### Example 1: Remove the auditing settings of an Azure SQL server
Remove-AzSqlServerAudit -ResourceGroupName "resourcegroup01" -ServerName "server01"

### Example 2: Remove, through pipeline, the auditing settings of an Azure SQL server
Get-AzSqlServer -ResourceGroupName "ResourceGroup01" -ServerName "Server01" | Remove-AzSqlServerAudit
