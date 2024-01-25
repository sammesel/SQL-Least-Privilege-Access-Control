-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


-- Disable Database Audit Specs
-- these 2 commands may fail. you can ignore if this is the 1st time executing the script
ALTER DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
WITH (STATE = OFF)
GO
DROP DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
GO


-- -- Action group name	Description 
-- FROM https://github.com/MicrosoftDocs/sql-docs/blob/live/docs/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions.md
CREATE DATABASE AUDIT SPECIFICATION [SQLSecurityDemoDB_DatabaseAuditSpec]
FOR SERVER AUDIT [Instance_ServerAudit]
-- Action group name	Description
 ADD(APPLICATION_ROLE_CHANGE_PASSWORD_GROUP) -- 	This event is raised whenever a password is changed for an application role. Equivalent to the Audit App Role Change Password Event Class.
,ADD(AUDIT_CHANGE_GROUP) -- 	This event is raised whenever any audit is created, modified or deleted. This event is raised whenever any audit specification is created, modified, or deleted. Any change to an audit is audited in that audit. Equivalent to the Audit Change Audit Event Class.
--,ADD(BACKUP_RESTORE_GROUP) -- 	This event is raised whenever a backup or restore command is issued. Equivalent to the Audit Backup and Restore Event Class.
--,ADD(BATCH_COMPLETED_GROUP) -- 	This event is raised whenever any batch text, stored procedure, or transaction management operation completes executing. It is raised after the batch completes and will audit the entire batch or stored procedure text, as sent from the client, including the result. Added in SQL Server 2019.
--,ADD(BATCH_STARTED_GROUP) -- 	This event is raised whenever any batch text, stored procedure, or transaction management operation starts to execute. It is raised before execution and will audit the entire batch or stored procedure text, as sent from the client. Added in SQL Server 2019.
,ADD(DATABASE_CHANGE_GROUP) -- 	This event is raised when a database is created, altered, or dropped. Equivalent to the Audit Database Management Event Class.
--,ADD(DATABASE_LOGOUT_GROUP) -- 	This event is raised when a contained database user logs out of a database.
--,ADD(DATABASE_OBJECT_ACCESS_GROUP) -- 	This event is raised whenever database objects such as certificates and asymmetric keys are accessed. Equivalent to the Audit Database Object Access Event Class.
,ADD(DATABASE_OBJECT_CHANGE_GROUP) -- 	This event is raised when a CREATE, ALTER, or DROP statement is executed on database objects, such as schemas. Equivalent to the Audit Database Object Management Event Class.
,ADD(DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP) -- 	This event is raised when a change of owner for objects within database scope occurs. Equivalent to the Audit Database Object Take Ownership Event Class.
,ADD(DATABASE_OBJECT_PERMISSION_CHANGE_GROUP) -- 	This event is raised when a GRANT, REVOKE, or DENY has been issued for database objects, such as assemblies and schemas. Equivalent to the Audit Database Object GDR Event Class.
--,ADD(DATABASE_OPERATION_GROUP) -- 	This event is raised when operations in a database, such as checkpoint or subscribe query notification, occur. Equivalent to the Audit Database Operation Event Class.
,ADD(DATABASE_OWNERSHIP_CHANGE_GROUP) -- 	This event is raised when you use the ALTER AUTHORIZATION statement to change the owner of a database, and the permissions that are required to do that are checked. Equivalent to the Audit Change Database Owner Event Class.
,ADD(DATABASE_PERMISSION_CHANGE_GROUP) -- 	This event is raised whenever a GRANT, REVOKE, or DENY is issued for a statement permission by any user in [!INCLUDEssNoVersion] for database-only events such as granting permissions on a database. Equivalent to the Audit Database Scope GDR Event Class.
,ADD(DATABASE_PRINCIPAL_CHANGE_GROUP) -- 	This event is raised when principals, such as users, are created, altered, or dropped from a database. Equivalent to the Audit Database Principal Management Event Class. Also equivalent to the Audit Add DB User Event Class, which occurs on deprecated sp_grantdbaccess, sp_revokedbaccess, sp_adduser, and sp_dropuser stored procedures.
	-- This event is raised whenever a database role is added to or removed using deprecated sp_addrole and sp_droprole stored procedures. Equivalent to the Audit Add Role Event Class.
,ADD(DATABASE_PRINCIPAL_IMPERSONATION_GROUP) -- 	This event is raised when there is an impersonation within database scope such as EXECUTE AS <user>. Equivalent to the Audit Database Principal Impersonation Event Class.
,ADD(DATABASE_ROLE_MEMBER_CHANGE_GROUP) -- 	This event is raised whenever a login is added to or removed from a database role. This event class is used with the sp_addrolemember, sp_changegroup, and sp_droprolemember stored procedures.Equivalent to the Audit Add Member to DB Role Event Class
,ADD(DBCC_GROUP) -- 	This event is raised whenever a principal issues any DBCC command. Equivalent to the Audit DBCC Event Class.
,ADD(FAILED_DATABASE_AUTHENTICATION_GROUP) -- 	Indicates that a principal tried to log on to a contained database and failed. Events in this class are raised by new connections or by connections that are reused from a connection pool. This event is raised.
,ADD(SCHEMA_OBJECT_ACCESS_GROUP) -- 	This event is raised whenever an object permission has been used in the schema. Equivalent to the Audit Schema Object Access Event Class.
,ADD(SCHEMA_OBJECT_CHANGE_GROUP) -- 	This event is raised when a CREATE, ALTER, or DROP operation is performed on a schema. Equivalent to the Audit Schema Object Management Event Class.
	-- This event is raised on schema objects. Equivalent to the Audit Object Derived Permission Event Class. Also equivalent to the Audit Statement Permission Event Class.
,ADD(SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP) -- 	This event is raised when the permissions to change the owner of schema object such as a table, procedure, or function is checked. This occurs when the ALTER AUTHORIZATION statement is used to assign an owner to an object. Equivalent to the Audit Schema Object Take Ownership Event Class.
,ADD(SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP) -- 	This event is raised whenever a grant, deny, or revoke is issued for a schema object. Equivalent to the Audit Schema Object GDR Event Class.
,ADD(SENSITIVE_BATCH_COMPLETED_GROUP) -- 	This event is raised whenever any batch text, stored procedure, or transaction management operation completes executing on sensitive data classified using SQL Data Discovery & Classification. It is raised after the batch completes and will audit the entire batch or stored procedure text, as sent from the client, including the result. Added in SQL Server 2019.
-- ,ADD(SENSITIVE_BATCH_STARTED_GROUP) -- 	This event is raised whenever any batch text, stored procedure, or transaction management operation starts to execute on sensitive data classified using SQL Data Discovery & Classification. It is raised before execution and will audit the entire batch or stored procedure text, as sent from the client. Added in SQL Server 2019.
--,ADD(SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP) -- 	Indicates that a principal successfully logged in to a contained database.
,ADD(USER_CHANGE_PASSWORD_GROUP) -- 	This event is raised whenever the password of a contained database user is changed by using the ALTER USER statement.
,ADD(USER_DEFINED_AUDIT_GROUP) -- 	This group monitors events raised by using sp_audit_write (Transact-SQL).
,ADD(LEDGER_OPERATION_GROUP) -- 	This event is raised for following actions ENABLE LEDGER - When you create a new ledger table ,ALTER LEDGER - When you drop a ledger table and ALTER LEDGER CONFIGURATION Applies to Azure SQL Database.
