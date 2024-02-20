# https://learn.microsoft.com/en-us/powershell/module/az.sql/set-azsqlserveraudit?view=azps-11.3.0

` ##  Description
` ##  The Set-AzSqlServerAudit cmdlet changes the auditing settings of an Azure SQL server. To use the cmdlet, use the 
` ## 	ResourceGroupName and ServerName parameters to identify the server. When blob storage is a destination for audit 
` ## 	logs, specify the StorageAccountResourceId parameter to determine the storage account for the audit logs and the 
` ## 	StorageKeyType parameter to define the storage keys. You can also define retention for the audit logs by setting 
` ## 	the value of the RetentionInDays parameter to define the period for the audit logs.

` ## # Examples
` ## # Example 1: Enable the blob storage auditing policy of an Azure SQL server
Set-AzSqlServerAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -BlobStorageTargetState Enabled -StorageAccountResourceId "/subscriptions/7fe3301d-31d3-4668-af5e-211a890ba6e3/resourceGroups/resourcegroup01/providers/Microsoft.Storage/storageAccounts/mystorage"


` ## # Example 2: Disable the blob storage auditing policy of an Azure SQL server
Set-AzSqlServerAudit -ResourceGroupName "ResourceGroup01" -ServerName "Server01" -BlobStorageTargetState Disabled

/*

There are many possible action groups for Server that you can use to audit different types of events. According to the documentation, some of the server-level audit action groups are:

APPLICATION_ROLE_CHANGE_PASSWORD_GROUP: This event is raised whenever a password is changed for an application role.
AUDIT_CHANGE_GROUP: This event is raised whenever any audit or audit specification is created, modified, or deleted.
BACKUP_RESTORE_GROUP: This event is raised whenever a backup or restore command is issued.
BATCH_COMPLETED_GROUP: This event is raised whenever any batch text, stored procedure, or transaction management operation completes executing.
BATCH_STARTED_GROUP: This event is raised whenever any batch text, stored procedure, or transaction management operation starts executing.
DATABASE_CHANGE_GROUP: This event is raised whenever a database is created, altered, or dropped.
DATABASE_OBJECT_CHANGE_GROUP: This event is raised whenever a database object, such as a table or a view, is created, altered, or dropped.
DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a database object, such as a table or a view, is changed.
DATABASE_OBJECT_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a database object, such as a table or a view, are changed.
DATABASE_OPERATION_GROUP: This event is raised whenever a database operation, such as a checkpoint or a shrink, is performed.
DATABASE_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a database is changed.
DATABASE_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a database are changed.
DATABASE_PRINCIPAL_CHANGE_GROUP: This event is raised whenever a database principal, such as a user or a role, is created, altered, or dropped.
DATABASE_PRINCIPAL_IMPERSONATION_GROUP: This event is raised whenever a database principal, such as a user or a role, is impersonated.
DATABASE_ROLE_MEMBER_CHANGE_GROUP: This event is raised whenever a database role membership is changed, such as adding or removing users from a role.
FAILED_LOGIN_GROUP: This event is raised whenever a login attempt fails.
LOGIN_CHANGE_PASSWORD_GROUP: This event is raised whenever a login changes their own password.
LOGOUT_GROUP: This event is raised whenever a user logs out of the server.
SCHEMA_OBJECT_CHANGE_GROUP: This event is raised whenever a schema object, such as a table or a view, is created, altered, or dropped.
SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a schema object, such as a table or a view, is changed.
SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a schema object, such as a table or a view, are changed.
SERVER_OBJECT_CHANGE_GROUP: This event is raised whenever a server object, such as a database or an endpoint, is created, altered, or dropped.
SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP: This event is raised whenever the ownership of a server object, such as a database or an endpoint, is changed.
SERVER_OBJECT_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on a server object, such as a database or an endpoint, are changed.
SERVER_OPERATION_GROUP: This event is raised whenever a server operation, such as creating a linked server or modifying the configuration, is performed.
SERVER_PERMISSION_CHANGE_GROUP: This event is raised whenever the permissions on the server are changed.
SERVER_PRINCIPAL_CHANGE_GROUP: This event is raised whenever a server principal, such as a login or a server role, is created, altered, or dropped.
SERVER_PRINCIPAL_IMPERSONATION_GROUP: This event is raised whenever a server principal, such as a login or a server role, is impersonated.
SERVER_ROLE_MEMBER_CHANGE_GROUP: This event is raised whenever a server role membership is changed, such as adding or removing logins from a role.
SUCCESSFUL_LOGIN_GROUP: This event is raised whenever a login attempt succeeds.
TRACE_CHANGE_GROUP: This event is raised whenever a trace is started or stopped.
USER_CHANGE_PASSWORD_GROUP: This event is raised whenever a user changes their own password.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
This is not a complete list of all the possible action groups for Server. You can find more information about the available action groups and how to use them in the documentation or this web page. I hope this helps. ??

-- https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions?view=sql-server-ver16
-- https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/



# Set the variables
$ResourceGroup = 'azuresql-db-mi-demos'
$AzureSQLDB_ServerName = 'azuresql-db-server001'
$AzureSQLDB_DatabaseName= 'SQLSecurityDemoDB'



$resourceGroupName = "ResourceGroup01"
$serverName = "Server01"
$storageAccountResourceId = "/subscriptions/7fe3301d-31d3-4668-af5e-211a890ba6e3/resourceGroups/resourcegroup01/providers/Microsoft.Storage/storageAccounts/storageaccount01"

# Enable the server-level auditing policy with the DATABASE_OPERATION_GROUP, DATABASE_ROLE_MEMBER_CHANGE_GROUP, and SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP action groups
Set-AzSqlServerAudit -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName -AuditActionGroup` #DATABASE_OPERATION_GROUP, DATABASE_ROLE_MEMBER_CHANGE_GROUP, SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP
 APPLICATION_ROLE_CHANGE_PASSWORD_GROUP` ##  This event is raised whenever a password is changed for an application role.
,AUDIT_CHANGE_GROUP` ##  This event is raised whenever any audit or audit specification is created, modified, or deleted.
,BACKUP_RESTORE_GROUP` ##  This event is raised whenever a backup or restore command is issued.
,BATCH_COMPLETED_GROUP` ##  This event is raised whenever any batch text, stored procedure, or transaction management operation completes executing.
,BATCH_STARTED_GROUP` ##  This event is raised whenever any batch text, stored procedure, or transaction management operation starts executing.
,DATABASE_CHANGE_GROUP` ##  This event is raised whenever a database is created, altered, or dropped.
,DATABASE_OBJECT_CHANGE_GROUP` ##  This event is raised whenever a database object, such as a table or a view, is created, altered, or dropped.
,DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP` ##  This event is raised whenever the ownership of a database object, such as a table or a view, is changed.
,DATABASE_OBJECT_PERMISSION_CHANGE_GROUP` ##  This event is raised whenever the permissions on a database object, such as a table or a view, are changed.
,DATABASE_OPERATION_GROUP` ##  This event is raised whenever a database operation, such as a checkpoint or a shrink, is performed.
,DATABASE_OWNERSHIP_CHANGE_GROUP` ##  This event is raised whenever the ownership of a database is changed.
,DATABASE_PERMISSION_CHANGE_GROUP` ##  This event is raised whenever the permissions on a database are changed.
,DATABASE_PRINCIPAL_CHANGE_GROUP` ##  This event is raised whenever a database principal, such as a user or a role, is created, altered, or dropped.
,DATABASE_PRINCIPAL_IMPERSONATION_GROUP` ##  This event is raised whenever a database principal, such as a user or a role, is impersonated.
,DATABASE_ROLE_MEMBER_CHANGE_GROUP` ##  This event is raised whenever a database role membership is changed, such as adding or removing users from a role.
,FAILED_LOGIN_GROUP` ##  This event is raised whenever a login attempt fails.
,LOGIN_CHANGE_PASSWORD_GROUP` ##  This event is raised whenever a login changes their own password.
,LOGOUT_GROUP` ##  This event is raised whenever a user logs out of the server.
,SCHEMA_OBJECT_CHANGE_GROUP` ##  This event is raised whenever a schema object, such as a table or a view, is created, altered, or dropped.
,SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP` ##  This event is raised whenever the ownership of a schema object, such as a table or a view, is changed.
,SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP` ##  This event is raised whenever the permissions on a schema object, such as a table or a view, are changed.
,SERVER_OBJECT_CHANGE_GROUP` ##  This event is raised whenever a server object, such as a database or an endpoint, is created, altered, or dropped.
,SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP` ##  This event is raised whenever the ownership of a server object, such as a database or an endpoint, is changed.
,SERVER_OBJECT_PERMISSION_CHANGE_GROUP` ##  This event is raised whenever the permissions on a server object, such as a database or an endpoint, are changed.
,SERVER_OPERATION_GROUP` ##  This event is raised whenever a server operation, such as creating a linked server or modifying the configuration, is performed.
,SERVER_PERMISSION_CHANGE_GROUP` ##  This event is raised whenever the permissions on the server are changed.
,SERVER_PRINCIPAL_CHANGE_GROUP` ##  This event is raised whenever a server principal, such as a login or a server role, is created, altered, or dropped.
,SERVER_PRINCIPAL_IMPERSONATION_GROUP` ##  This event is raised whenever a server principal, such as a login or a server role, is impersonated.
,SERVER_ROLE_MEMBER_CHANGE_GROUP` ##  This event is raised whenever a server role membership is changed, such as adding or removing logins from a role.
,SUCCESSFUL_LOGIN_GROUP` ##  This event is raised whenever a login attempt succeeds.
,TRACE_CHANGE_GROUP` ##  This event is raised whenever a trace is started or stopped.
,USER_CHANGE_PASSWORD_GROUP ##  This event is raised whenever a user changes their own password.




# -BlobStorageTargetState Enabled -StorageAccountResourceId $storageAccountResourceId 



## with the complete set of actions:
Set-AzSqlServerAudit -ResourceGroupName $ResourceGroup -ServerName $AzureSQLDB_ServerName -AuditActionGroup BATCH_STARTED_GROUP, BATCH_COMPLETED_GROUP, APPLICATION_ROLE_CHANGE_PASSWORD_GROUP, BACKUP_RESTORE_GROUP, DATABASE_LOGOUT_GROUP, DATABASE_OBJECT_CHANGE_GROUP, `
DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP, DATABASE_OBJECT_PERMISSION_CHANGE_GROUP, DATABASE_OPERATION_GROUP, DATABASE_PERMISSION_CHANGE_GROUP, DATABASE_PRINCIPAL_CHANGE_GROUP, `
DATABASE_PRINCIPAL_IMPERSONATION_GROUP, DATABASE_ROLE_MEMBER_CHANGE_GROUP, FAILED_DATABASE_AUTHENTICATION_GROUP, SCHEMA_OBJECT_ACCESS_GROUP, SCHEMA_OBJECT_CHANGE_GROUP, `
SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP, SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP, SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP, USER_CHANGE_PASSWORD_GROUP, LEDGER_OPERATION_GROUP, DBCC_GROUP, DATABASE_OWNERSHIP_CHANGE_GROUP, DATABASE_CHANGE_GROUP

