-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user

USE [master]
GO

DROP SERVER AUDIT SPECIFICATION [Instance_ServerAuditSpec]
GO


-- Action Group Names from:
--  https://github.com/MicrosoftDocs/sql-docs/blob/live/docs/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions.md
CREATE SERVER AUDIT SPECIFICATION [Instance_ServerAuditSpec]
FOR SERVER AUDIT [Instance_ServerAudit]
	 ADD (APPLICATION_ROLE_CHANGE_PASSWORD_GROUP)--	This event is raised whenever a password is changed for an application role. Equivalent to the Audit App Role Change Password Event Class.

-- note the list of Audits being added to the Server-Audit
-- not all are being captured
-- special attention to events related to SENSITIVE* contents. In order to create those, it is needed to have columns registered as SENSITIVE data
--		this is done with script [060 - ALTER Database Audit Spec after data classification.sql]
--
ALTER SERVER AUDIT SPECIFICATION [Instance_ServerAuditSpec]
FOR SERVER AUDIT [Instance_ServerAudit]
	 ADD (AUDIT_CHANGE_GROUP)--	This event is raised whenever any audit is created, modified or deleted. This event is raised whenever any audit specification is created, modified, or deleted. Any change to an audit is audited in that audit. Equivalent to the Audit Change Audit Event Class.
--  , ADD (BACKUP_RESTORE_GROUP)--	This event is raised whenever a backup or restore command is issued. Equivalent to the Audit Backup and Restore Event Class.
--  , ADD (BATCH_COMPLETED_GROUP)--	This event is raised whenever any batch text, stored procedure, or transaction management operation completes executing. It is raised after the batch completes and will audit the entire batch or stored procedure text, as sent from the client, including the result. Added in SQL Server 2022. Equivalent to the SQL Batch Completed Event Class.
--  , ADD (BATCH_STARTED_GROUP)--	This event is raised whenever any batch text, stored procedure, or transaction management operation starts to execute. It is raised before execution and will audit the entire batch or stored procedure text, as sent from the client. Added in SQL Server 2022. Equivalent to the SQL Batch Started Event Class.
--  , ADD (BROKER_LOGIN_GROUP)--	This event is raised to report audit messages related to Service Broker transport security. Equivalent to the Audit Broker Login Event Class.
	,ADD (DATABASE_CHANGE_GROUP)--	This event is raised when a database is created, altered, or dropped. This event is raised whenever any database is created, altered or dropped. Equivalent to the Audit Database Management Event Class.
--,  ADD (DATABASE_LOGOUT_GROUP)--	This event is raised when a contained database user logs out of a database Equivalent to the Audit Logout Event Class.
--,  ADD (DATABASE_MIRRORING_LOGIN_GROUP)--	This event is raised to report audit messages related to database mirroring transport security. Equivalent to the Audit Database Mirroring Login Event Class.
--,  ADD (DATABASE_OBJECT_ACCESS_GROUP)--	This event is raised whenever database objects such as message type, assembly, contract are accessed. This event is raised for any access to any database. Note: This could potentially lead to large audit records.
		-- Equivalent to the Audit Database Object Access Event Class.
	,ADD (DATABASE_OBJECT_CHANGE_GROUP)--	This event is raised when a CREATE, ALTER, or DROP statement is executed on database objects, such as schemas. This event is raised whenever any database object is created, altered or dropped. Note: This could lead to very large quantities of audit records.
		-- Equivalent to the Audit Database Object Management Event Class.
	,ADD (DATABASE_OBJECT_OWNERSHIP_CHANGE_GROUP)--	This event is raised when a change of owner for objects within database scope. This event is raised for any object ownership change in any database on the server. Equivalent to the Audit Database Object Take Ownership Event Class.
	,ADD (DATABASE_OBJECT_PERMISSION_CHANGE_GROUP)--	This event is raised when a GRANT, REVOKE, or DENY has been issued for database objects, such as assemblies and schemas. This event is raised for any object permission change for any database on the server. Equivalent to the Audit Database Object GDR Event Class.
--, ADD (DATABASE_OPERATION_GROUP)--	This event is raised when operations in a database, such as checkpoint or subscribe query notification, occur. This event is raised on any database operation on any database. Equivalent to the Audit Database Operation Event Class.
	,ADD (DATABASE_OWNERSHIP_CHANGE_GROUP)--	This event is raised when you use the ALTER AUTHORIZATION statement to change the owner of a database, and the permissions that are required to do that are checked. This event is raised for any database ownership change on any database on the server. Equivalent to the Audit Change Database Owner Event Class.
	,ADD (DATABASE_PERMISSION_CHANGE_GROUP)--	This event is raised whenever a GRANT, REVOKE, or DENY is issued for a statement permission by any principal in [!INCLUDEssNoVersion] (This applies to database-only events, such as granting permissions on a database).
		-- This event is raised for any database permission change (GDR) for any database in the server. Equivalent to the Audit Database Scope GDR Event Class.
	,ADD (DATABASE_PRINCIPAL_CHANGE_GROUP)--	This event is raised when principals, such as users, are created, altered, or dropped from a database. Equivalent to the Audit Database Principal Management Event Class. (Also equivalent to the Audit Add DB Principal Event Class, which occurs on the deprecated sp_grantdbaccess, sp_revokedbaccess, sp_addPrincipal, and sp_dropPrincipal stored procedures.)
		-- This event is raised whenever a database role is added to or removed by using the sp_addrole, sp_droprole stored procedures. This event is raised whenever any database principals are created, altered, or dropped from any database. Equivalent to the Audit Add Role Event Class.
	,ADD (DATABASE_PRINCIPAL_IMPERSONATION_GROUP)--	This event is raised when there is an impersonation operation in the database scope such as EXECUTE AS <principal> or SETPRINCIPAL. This event is raised for impersonations done in any database. Equivalent to the Audit Database Principal Impersonation Event Class.
	,ADD (DATABASE_ROLE_MEMBER_CHANGE_GROUP)--	This event is raised whenever a login is added to or removed from a database role. This event class is raised for the sp_addrolemember, sp_changegroup, and sp_droprolemember stored procedures. This event is raised on any Database role member change in any database. Equivalent to the Audit Add Member to DB Role Event Class.
--,  ADD (DBCC_GROUP)--	This event is raised whenever a principal issues any DBCC command. Equivalent to the Audit DBCC Event Class.
	,ADD (EXTGOV_OPERATION_GROUP)--	This event is raised on external governance feature enablement, external governance feature disablement, external governance policies synchronization, and external governance policies based permissions enforcement.
	,ADD (FAILED_DATABASE_AUTHENTICATION_GROUP)--	Indicates that a principal tried to log on to a contained database and failed. Events in this class are raised by new connections or by connections that are reused from a connection pool. Equivalent to the Audit Login Failed Event Class.
	,ADD (FAILED_LOGIN_GROUP)--	Indicates that a principal tried to log on to [!INCLUDEssNoVersion] and failed. Events in this class are raised by new connections or by connections that are reused from a connection pool. Equivalent to the Audit Login Failed Event Class. This audit does not apply to Azure SQL Database.
--,  ADD (FULLTEXT_GROUP)--	Indicates fulltext event occurred. Equivalent to the Audit Fulltext Event Class.
	,ADD (LOGIN_CHANGE_PASSWORD_GROUP)--	This event is raised whenever a login password is changed by way of ALTER LOGIN statement or sp_password stored procedure. Equivalent to the Audit Login Change Password Event Class.
--,  ADD (LOGOUT_GROUP)--	Indicates that a principal has logged out of [!INCLUDEssNoVersion]. Events in this class are raised by new connections or by connections that are reused from a connection pool. Equivalent to the Audit Logout Event Class.
	,ADD (SCHEMA_OBJECT_ACCESS_GROUP)--	This event is raised whenever an object permission has been used in the schema. Equivalent to the Audit Schema Object Access Event Class.
	,ADD (SCHEMA_OBJECT_CHANGE_GROUP)--	This event is raised when a CREATE, ALTER, or DROP operation is performed on a schema. Equivalent to the Audit Schema Object Management Event Class.
		-- This event is raised on schema objects. Equivalent to the Audit Object Derived Permission Event Class.
		-- This event is raised whenever any schema of any database changes. Equivalent to the Audit Statement Permission Event Class.
	,ADD (SCHEMA_OBJECT_OWNERSHIP_CHANGE_GROUP)--	This event is raised when the permissions to change the owner of schema object (such as a table, procedure, or function) is checked. This occurs when the ALTER AUTHORIZATION statement is used to assign an owner to an object. This event is raised for any schema ownership change for any database on the server. Equivalent to the Audit Schema Object Take Ownership Event Class.
	,ADD (SCHEMA_OBJECT_PERMISSION_CHANGE_GROUP)--	This event is raised whenever a grant, deny, revoke is performed against a schema object. Equivalent to the Audit Schema Object GDR Event Class.
	,ADD (SENSITIVE_BATCH_COMPLETED_GROUP)--	This event is raised whenever any batch text, stored procedure, or transaction management operation completes executing on sensitive data classified using SQL Data Discovery & Classification. It is raised after the batch completes and will audit the entire batch or stored procedure text, as sent from the client, including the result. Added in SQL Server 2019.
--,  ADD (SENSITIVE_BATCH_STARTED_GROUP)--	This event is raised whenever any batch text, stored procedure, or transaction management operation starts to execute on sensitive data classified using SQL Data Discovery & Classification. It is raised before execution and will audit the entire batch or stored procedure text, as sent from the client. Added in SQL Server 2019.
--	,ADD (SENSITIVE_SERVER_OBJECT_CHANGE_GROUP)--	This event is raised for CREATE, ALTER, or DROP operations on server objects. Equivalent to the Audit Server Object Management Event Class.
	,ADD (SERVER_OBJECT_OWNERSHIP_CHANGE_GROUP)--	This event is raised when the owner is changed for objects in server scope. Equivalent to the Audit Server Object Take Ownership Event Class.
	,ADD (SERVER_OBJECT_PERMISSION_CHANGE_GROUP)--	This event is raised whenever a GRANT, REVOKE, or DENY is issued for a server object permission by any principal in [!INCLUDEssNoVersion]. Equivalent to the Audit Server Object GDR Event Class.
	,ADD (SERVER_OPERATION_GROUP)--	This event is raised when Security Audit operations such as altering settings, resources, external access, or authorization are used. Equivalent to the Audit Server Operation Event Class.
	,ADD (SERVER_PERMISSION_CHANGE_GROUP)--	This event is raised when a GRANT, REVOKE, or DENY is issued for permissions in the server scope. Equivalent to the Audit Server Scope GDR Event Class.
	,ADD (SERVER_PRINCIPAL_CHANGE_GROUP)--	This event is raised when server principals are created, altered, or dropped. Equivalent to the Audit Server Principal Management Event Class.
		-- This event is raised when a principal issues the sp_defaultdb or sp_defaultlanguage stored procedures or ALTER LOGIN statements. Equivalent to the Audit Addlogin Event Class.
		-- This event is raised on the sp_addlogin and sp_droplogin stored procedures. Also equivalent to the Audit Login Change Property Event Class.
		-- This event is raised for the sp_grantlogin or sp_revokelogin stored procedures. Equivalent to the Audit Login GDR Event Class.
	,ADD (SERVER_PRINCIPAL_IMPERSONATION_GROUP)--	This event is raised when there is an impersonation within server scope, such as EXECUTE AS <login>. Equivalent to the Audit Server Principal Impersonation Event Class.
	,ADD (SERVER_ROLE_MEMBER_CHANGE_GROUP)--	This event is raised whenever a login is added or removed from a fixed server role. This event is raised for the sp_addsrvrolemember and sp_dropsrvrolemember stored procedures. Equivalent to the Audit Add Login to Server Role Event Class.
	,ADD (SERVER_STATE_CHANGE_GROUP)--	This event is raised when the [!INCLUDEssNoVersion] service state is modified. Equivalent to the Audit Server Starts and Stops Event Class.
--,  ADD (SUCCESSFUL_DATABASE_AUTHENTICATION_GROUP)--	Indicates that a principal successfully logged in to a contained database.
--,  ADD (SUCCESSFUL_LOGIN_GROUP)--	Indicates that a principal has successfully logged in to [!INCLUDEssNoVersion]. Events in this class are raised by new connections or by connections that are reused from a connection pool. Equivalent to the Audit Login Event Class.
	,ADD (TRACE_CHANGE_GROUP)--	This event is raised for all statements that check for the ALTER TRACE permission. Equivalent to the Audit Server Alter Trace Event Class.
--,  ADD (TRANSACTION_GROUP)--	This event is raised for BEGIN TRANSACTION, ROLLBACK TRANSACTION, and COMMIT TRANSACTION operations, both for explicit calls to those statements and implicit transaction operations. This event is also raised for UNDO operations for individual statements caused by the rollback of a transaction.
	,ADD (USER_CHANGE_PASSWORD_GROUP)--	This event is raised whenever the password of a contained database user is changed by using the ALTER USER statement.
--,  ADD (USER_DEFINED_AUDIT_GROUP)--	This group monitors events raised by using sp_audit_write (Transact-SQL). Typically triggers or stored procedures include calls to sp_audit_write to enable auditing of important events.
	,ADD (LEDGER_OPERATION_GROUP)--	This event is raised for following actions GENERATE LEDGER DIGEST - When you generate a ledger digest ,VERIFY LEDGER - When you verify a ledger digest. Applies to Azure SQL Database.
