# https://learn.microsoft.com/en-us/powershell/module/az.sql/remove-azsqldatabaseaudit?view=azps-11.3.0

## Description
## The Remove-AzSqlDatabaseAudit cmdlet removes the auditing settings of an Azure SQL database. To use the cmdlet, 
## 	use the ResourceGroupName, ServerName, and DatabaseName parameters to identify the database.

### Examples
### Example 1: Remove the auditing settings of an Azure SQL database
Remove-AzSqlDatabaseAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -DatabaseName "Database01"


### Example 2: Remove, through pipeline, the auditing settings of an Azure SQL database
Get-AzSqlDatabase -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -DatabaseName "Database01" | Remove-AzSqlDatabaseAudit
