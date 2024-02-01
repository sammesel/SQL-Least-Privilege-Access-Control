-- ================================================================================= --
-- LOGIN as:		DBA_with_CreateRole
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

CREATE ROLE role_HR_Manager
go
CREATE ROLE role_OperationsManager
GO
CREATE ROLE role_SalesManager
GO
CREATE ROLE role_SalesPerson
GO

/*

There are different ways to add permissions to a database role in SQL Server, depending on the type and level of permissions you want to grant. Here are some general steps:

To create a user-defined database role, use the CREATE ROLE statement or the graphical interface in SQL Server Management Studio.
To add users or other roles to a database role, use the ALTER ROLE statement with the ADD MEMBER option, or the sp_addrolemember stored procedure, or the graphical interface in SQL Server Management Studio.
To grant permissions on a database, such as CREATE TABLE or BACKUP DATABASE, use the GRANT statement with the name of the permission and the name of the database role, or the graphical interface in SQL Server Management Studio12.
To grant permissions on a schema, such as CREATE PROCEDURE or ALTER SCHEMA, use the GRANT statement with the name of the permission, the name of the schema, and the name of the database role, or the graphical interface in SQL Server Management Studio12.
To grant permissions on a specific object, such as a table, a view, or a stored procedure, use the GRANT statement with the name of the permission, the name of the object, and the name of the database role, or the graphical interface in SQL Server Management Studio12345.
To grant permissions on a specific column, use the GRANT statement with the name of the permission, the name of the column, and the name of the database role, or the graphical interface in SQL Server Management Studio12345.
For more details and examples, you can watch these videos678 or read these articles12345. I hope this helps you.

Learn more
1 https://learn.microsoft.com/en-us/sql/t-sql/statements/grant-database-permissions-transact-sql?view=sql-server-ver16
2 https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver16
3 https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/grant-a-permission-to-a-principal?view=sql-server-ver16
4 https://stackoverflow.com/questions/50185133/add-execute-permission-to-role-in-ms-sql
5 https://stackoverflow.com/questions/53526505/granting-full-sql-server-permissions-for-a-database
6 https://www.youtube.com/watch?v=nV-lRnbWr4g
7 https://www.youtube.com/watch?v=Mkw7tRfh2_8
8 https://www.youtube.com/watch?v=gkCkX5ogyzI
*/


-- assign permissions to ROLES
GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA :: HumanResources to role_HR_Manager 
GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA :: sales to role_SalesManager
GRANT          SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA :: sales to role_SalesPerson
GRANT EXECUTE, SELECT, INSERT, UPDATE, DELETE, REFERENCES ON SCHEMA :: production to role_OperationsManager


-- REVOKING Permissions from roles:
REVOKE UPDATE ON SCHEMA :: sales to role_SalesPerson;
GO


-- CREATE LOGINS USING SCRIPT [300_A1_B_Test_DBA_with_AlterAnyLogin.sql]
-- CREATE USERS  USING SCRIPT [300_B1_B_Test_DBA_with_AlterAnyUser_to_CreateUsers.sql]

-- add members to ROLES
USE [SQLSecurityDemoDB]
GO
ALTER ROLE [role_HR_Manager] ADD MEMBER [HR_Manager]
GO
ALTER ROLE [role_OperationsManager] ADD MEMBER [OperationsManager]
GO
ALTER ROLE [role_SalesManager] ADD MEMBER [SalesManager]
GO
ALTER ROLE [role_SalesPerson] ADD MEMBER [SalesPerson]
GO

