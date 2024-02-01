# Security Management

## This folder contains scripts to demonstrate the use of ACCESS CONTROL in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing them to perform Security Tasks.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

Use the following scripts in the order they appear in the table below:

## NOTE: all scripts display at the very top the **login name** that should be used for that script. 

| Script | Description |
| ----------- | ----------- |
| 300_A1_A_CREATE_DBA_with_AlterAnyLogin.sql | Create a **Security-DBA-for-LOGINs** with permission to create other logins  | 
| 300_A1_B_Test_DBA_with_AlterAnyLogin.sql | Login as Security-DBA-for-LOGINs to: <ul><li>create additional logins</li><li>Alter Logins: Enable/Disable</li><li>Reset Passwords</li><li>Drop Logins</li></ul> | 
| 300_A1_C_DROP_DBA_with_AlterAnyLogin.sql | Clean-Up Security-DBA-for-LOGINs  | 
| 300_B1_A_CREATE_DBA_with_AlterAnyUser.sql | Create a **Security-DBA-for-USERs** with permission to create database-users based on other logins (previously created by *Security-DBA-for-LOGINs* | 
| 300_B1_B_Test_DBA_with_AlterAnyUser_to_create_users.sql | Login as Security-DBA-for-USERs to: <ul><li>Try to SELECT from tables</li><li>Try to modify own Masking Settings</li><li>Try to execute DBCC</li><li>Try to execute DBCC commands</li><li>Create Database-Users</li><li>Drop Database-Users</li></ul> | 
| 300_B1_C_Test_DBA_with_AlterAnyUser_to_grant_users.sql | Login as Security-DBA-for-USERs to: <ul><li>Try to Add database-users to *Database-Roles*</li><li>Try to execute *sp_addrolemember* to add database-users to roles</li><li>Try to *GRANT* permissions to Database-Users</li></ul> | 
| 300_B1_D_Test_end_user.sql | Login using credentials created in previous scripts to:<ul><li>Execute *SELECT* on tables</li><li>Try to manipulate Masking settings</li><li>Try to execute DBCC commands</li></ul>  | 
| 300_B1_E_DROP_DBA_with_AlterAnyUser.sql | Clean-Up Security-DBA-for-Users | 
| 300_C1_A_CREATE_DBA_with._CreateRole.sql | | 
| 300_C1_B_CREATE_Roles_GrantPermissions_AddMembers.sql | | 
| 300_C1_C_Test_EndUsers_vs_Roles.sql | | 
| 300_C1_D_DROP_objects_created_by_DBA_with_CreateRole.sql | | 
| 300_C1_E_Drop_UserAndLogin_DBA_with_CreateRole.sql | | 
