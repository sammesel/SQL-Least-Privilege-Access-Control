## https://learn.microsoft.com/en-us/powershell/module/az.sql/set-azsqldatabaseaudit?view=azps-11.3.0

## Description
## The Set-AzSqlDatabaseAudit cmdlet changes the auditing settings of an Azure SQL Database. To use the cmdlet, 
##	use the ResourceGroupName, ServerName, and DatabaseName parameters to identify the database. When blob storage 
##	is a destination for audit logs, specify the StorageAccountResourceId parameter to determine the storage account 
##	for the audit logs and the StorageKeyType parameter to define the storage keys. You can also define retention 
##	for the audit logs by setting the value of the RetentionInDays parameter to define the period for the audit logs.

## Examples
## Example 1: Enable the blob storage auditing policy of an Azure SQL Database
Set-AzSqlDatabaseAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -DatabaseName "Database01" -BlobStorageTargetState Enabled  -StorageAccountResourceId "/subscriptions/7fe3301d-31d3-4668-af5e-211a890ba6e3/resourceGroups/resourcegroup01/providers/Microsoft.Storage/storageAccounts/mystorage"

## Example 2: Disable the blob storage auditing policy of an Azure SQL Database
Set-AzSqlDatabaseAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -DatabaseName "Database01" -BlobStorageTargetState Disabled

## from copilot: on how to specify a set of ACTIONS:
Set-AzSqlDatabaseAudit -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName -DatabaseName $AzureSQLDB_DatabaseName  -AuditActionGroup USER_CHANGE_PASSWORD_GROUP, DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP

/*
There are many possible action groups for databases that you can use to audit different types of events. According to the documentation, some of the database-level audit action groups are:

APPLICATION_ROLE_CHANGE_PASSWORD_GROUP: This event is raised whenever a password is changed for an application role.
DATABASE_CHANGE_GROUP: This event is raised whenever a database is created, altered, or dropped.
DATABASE_OBJECT_ACCESS_GROUP: This event is raised whenever a database object, such as a table or a view, is accessed.
DATABASE_OBJECT_CHANGE_GROUP: This event is raised whenever a database object, such as a table or a view, is created, altered, or dropped.
DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a database object, such as a table or a view, is changed.
DATABASE_OBJECT_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a database object, such as a table or a view, are changed.
DATABASE_OPERATION_GROUP: This event is raised whenever a database operation, such as a checkpoint or a shrink, is performed.
DATABASE_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a database is changed.
DATABASE_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a database are changed.
DATABASE_PRINCIPAL_CHANGE_GROUP: This event is raised whenever a database principal, such as a user or a role, is created, altered, or dropped.
DATABASE_PRINCIPAL_IMPERSONATION_GROUP: This event is raised whenever a database principal, such as a user or a role, is impersonated.
DATABASE_ROLE_MEMBER_CHANGE_GROUP: This event is raised whenever a database role membership is changed, such as adding or removing users from a role.
FAILED_DATABASE_AUTHENTICATION_GROUP: This event is raised whenever a database authentication fails.
SCHEMA_OBJECT_ACCESS_GROUP: This event is raised whenever a schema object, such as a table or a view, is accessed.
SCHEMA_OBJECT_CHANGE_GROUP: This event is raised whenever a schema object, such as a table or a view, is created, altered, or dropped.
SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a schema object, such as a table or a view, is changed.
SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a schema object, such as a table or a view, are changed.
SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP: This event is raised whenever a database authentication succeeds.
USER_CHANGE_PASSWORD_GROUP: This event is raised whenever a user changes their own password.
USER_DEFINED_AUDIT_GROUP: This event is raised whenever a user-defined event occurs.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This is not a complete list of all the possible action groups for databases. You can find more information about the available action groups and how to use them in the documentation or this web page. I hope this helps. ??

	-- https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions?view=sql-server-ver16
	-- https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/create-a-server-audit-and-database-audit-specification?view=sql-server-ver16

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/
