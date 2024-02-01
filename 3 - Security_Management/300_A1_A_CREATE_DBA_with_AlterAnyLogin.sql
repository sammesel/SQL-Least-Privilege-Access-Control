/*

The ServerAdmin role and the ALTER ANY LOGIN permission are both server-level security features in SQL Server. However, they have different scopes and capabilities.
The ServerAdmin role is a fixed server role that grants its members the ability to configure and manage the SQL Server instance, such as changing server settings, shutting down the server, and creating linked servers123. The ServerAdmin role also implicitly includes the ALTER ANY LOGIN permission, which allows its members to create, modify, and drop any login account1.
The ALTER ANY LOGIN permission is a server-level permission that grants its members the ability to create, modify, and drop any login account4. This permission can be granted to individual logins or user-defined server roles. The ALTER ANY LOGIN permission does not include any other server-level permissions or roles.
Therefore, the difference between someone who has the ServerAdmin role and someone who has the ALTER ANY LOGIN permission is that the former can perform more actions on the SQL Server instance, while the latter can only manage login accounts.

1 https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/server-level-roles?view=sql-server-ver16
2 https://ourtechideas.com/understanding-sql-server-roles-server-admin-vs-sysadmin/
3 https://www.mssqltips.com/sqlservertip/1887/understanding-sql-server-fixed-server-roles/
4 https://learn.microsoft.com/en-us/sql/t-sql/statements/alter-login-transact-sql?view=sql-server-ver16

*/

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB

CREATE LOGIN [DBA_with_AlterAnyLogin] 
	WITH PASSWORD=N'<password-place-holder>', 
	CHECK_EXPIRATION=OFF, 
	CHECK_POLICY=OFF

use [master]
GO
CREATE USER [DBA_with_AlterAnyLogin] FROM LOGIN [DBA_with_AlterAnyLogin] 
GO
GRANT ALTER ANY LOGIN TO [DBA_with_AlterAnyLogin]
GO


-- now test if [DBA_with_AlterAnyLogin] can create new logins
-- use script [300_A1_B_x03D2_test_DBA_with_AlterAnyLogin.sql]

