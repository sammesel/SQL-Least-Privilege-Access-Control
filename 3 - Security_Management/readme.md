# Security Management

## This folder contains scripts to demonstrate the use of ACCESS CONTROL in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing them to perform Security Tasks.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

## NOTE: All scripts display at the very top the **login name** that should be used for that script.<br>
<ul>
<li>Execute the Query to display the username to make sure you are using the correct persona</li>
<li>For scripts that switch between MASTER and the SQLSecurityDemoDB databases:<ul>
  <li>After Switching the database, execute the query to display the username again, so you can see how that user is mapped</li>
  <li>When testing these scripts on Azure SQL Database the **USE** command will fail, you need to switch the database manually via SSMS toolbar</li>
  </ul>
</ul>
<br>

Use the following scripts in the order they appear in the table below:

| Script | Description | SQL Server on VM | Azure SQL MI | Azure SQL DB |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 300_A1_A_CREATE_DBA_with_AlterAnyLogin.sql | Create a **Security-DBA-for-LOGINs** with permission to create other logins  |  Y | Y | ? |
| 300_A1_B_Test_DBA_with_AlterAnyLogin.sql | Login as Security-DBA-for-LOGINs to: <ul><li>create additional logins</li><li>Alter Logins: Enable/Disable</li><li>Reset Passwords</li><li>Drop Logins</li></ul> |  Y | Y | ? |
| 300_B1_A_CREATE_DBA_with_AlterAnyUser.sql | Create a **Security-DBA-for-USERs** with permission to create database-users based on other logins (previously created by *Security-DBA-for-LOGINs* |  Y | Y | ? |
| 300_B1_B_Test_DBA_with_AlterAnyUser_to_create_users.sql | Login as Security-DBA-for-USERs to: <ul><li>Try to SELECT from tables</li><li>Try to modify own Masking Settings</li><li>Try to execute DBCC</li><li>Try to execute DBCC commands</li><li>Create Database-Users</li><li>Drop Database-Users</li></ul> |  Y | Y | ? |
| 300_B1_C_Test_DBA_with_AlterAnyUser_to_grant_users.sql | Login as Security-DBA-for-USERs to: <ul><li>Try to Add database-users to *Database-Roles*</li><li>Try to execute *sp_addrolemember* to add database-users to roles</li><li>Try to *GRANT* permissions to Database-Users</li></ul> |  Y | Y | ? |
| 300_B1_D_Test_end_user.sql | Login using credentials created in previous scripts to:<ul><li>Execute *SELECT* on tables</li><li>Try to manipulate Masking settings</li><li>Try to execute DBCC commands</li></ul>  |  Y | Y | ? |
| 300_C1_A_CREATE_DBA_with._CreateRole.sql | Create a **Security-DBA-for-Roles** |  Y | Y | ? |
| 300_C1_B_CREATE_Roles_GrantPermissions_AddMembers.sql | Login as Security-DBA-for-Roles to:<ul><li>Create Roles</li><li>Grant permissions to these new roles</li><li>Add Members into these Roles</li></ul> |  Y | Y | ? |
| 300_C1_C_Test_EndUsers_vs_Roles.sql | Test end-user access for those placed in the roles created |  Y | Y | ? |
| 300_C1_D_DROP_MembersFromRoles_and_Roles.sql | Login as Security-DBA-for-Roles to Clean-up:<ul><li>Remove members from Roles</li><li>Drop roles</li></ul> |  Y | Y | ? |
| 300_C1_E_Drop_UserAndLogin_DBA_with_CreateRole.sql | Login as sa to clean-up:<ul><li>Remove member *Security-DBA-for-Roles* from Roles</li><li>Drop User and Login *Security-DBA-for-Roles*</li></ul>  |  Y | Y | ? |
| 300_D1_A_DROP_DBA_with_AlterAnyUser.sql | Clean-Up Security-DBA-for-Users |  Y | Y | ? |
| 300_D1_B_DROP_DBA_with_AlterAnyLogin.sql | Clean-Up Security-DBA-for-LOGINs  |  Y | Y | ? |
