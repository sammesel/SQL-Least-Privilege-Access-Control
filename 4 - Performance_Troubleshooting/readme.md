# Performance Troubleshooting

## This folder contains scripts to demonstrate the use of ACCESS CONTROL in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing them to perform Performance Troubleshooting tasks.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

Use the following scripts in the order they appear in the table below:

## NOTE: all scripts display at the very top the **login name** that should be used for that script. 

| Script | Description | SQL Server on VM | Azure SQL DB | Azure SQL MI |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 400_A1_test_DBAs_sys_log_on_AzureSQLDB.sql | This script is applicable for **Azure SQL Database** only.<br> Read EVENT-LOG records  | N | Y | ? |
| 400_A2_A_wrapper_create_sp_readerrorlog.sql | Create Login and User for an **ErrorLog-Principal**<br>Create a ROLE for **ErrorLog-Principal**<br>Grant:<ul><li>access to stored procedures: *xp_readerrorlog* and *sp_readerrorlog*</li><li>VIEW ANY ERROR LOG</li>Grant CONTROL to the Role<li></li><li>Grant ALTER to the role</li><li>Grant VIEW SERVER STATE to the login</li> | Y | ? | ? |
| 400_A2_B_Test_DBA_with_xp_errorlog.sql | Create wrapper stored procedures to:<ul><li>call *sp_readerrorlog*</li><li>call *sp_cycle_errorlog*</li></ul>   | Y | ? | ? |
| 400_A2_C_Test_WrapperCode.sql | Test executing wrapper code  | Y | ? | ? |
| 400_A2_D_DROP_WrapperCode_UserLogin.sql | Clean-Up  | Y | ? | ? |
| 400_A2_Z_Explanation.sql | Auxiliary queries to explain the grants given to the Login  | Y | ? | ? |
| 400_B1_A_x10A_Create_DBA_with_ServerPerformance.sql | Create Login **PerformanceTroubleshooting-DBA**<br>Create Role **PerformanceTroubleshooting-Role**<br>Add DBA into Role<br>Grant permisions to Role | Y | ? | ? |
| 400_B1_B1_x10A_x10B_Test_DMVs_DBA_With_PerformaceTroubleshooting.sql | Login as **PerformanceTroubleshooting-DBA**<br><ul><li>Try to add self to **db_datareader** database-role</li><li>Try to SELECT data from tables</li><li>Execute SELECT from performance related DMVs</li></ul> | Y | ? | ? |
| 400_B1_B2_x10A_x10B_Test_ErrorLog_DBA_With_PerformaceTroubleshooting.sql | Login as **PerformanceTroubleshooting-DBA**<br><ul><li>Execute xp_readerrorlog</li><li>Execute sys.sp_enumerrorlogs</li></ul> | Y | ? | ? |
| 400_B1_C_DROP_DBA_With_PerformaceTroubleshooting.sql | Clean-up Login / User / Role **PerformanceTroubleshooting-DBA**  | Y | ? | ? |
| 400_C1_A_x10E_Create_DBA_for_QueryStore.sql | Create Login User and Role for **QueryStore-DBA**<br>Grant VIEW DATABASE STATE to Role<br>Create Schema for **QueryStore-SPs**<br>Grant EXECUTE on Schema to the Role | Y | ? | ? |
| 400_C1_B_x16A_QUERY_STORE_create_elevated_logins_roles.sql |  | Y | ? | ? |
| 400_C1_C_x16A_QUERY_STORE_create_WrapperCode.sql |  | Y | ? | ? |
| 400_C1_D_x10F_Test_DBA_for_QueryStore.sql |  | Y | ? | ? |
| 400_C1_Z_DROP_DBA_for_QueryStore.sql.sql |  | Y | ? | ? |
| 400_E1_A_ExtendedEvent_Security_SQL2022.sql |  | Y | ? | ? |



| 300_A1_A_CREATE_DBA_with_AlterAnyLogin.sql | Create a **Security-DBA-for-LOGINs** with permission to create other logins  |  Y | ? | ? |
| 300_A1_B_Test_DBA_with_AlterAnyLogin.sql | Login as Security-DBA-for-LOGINs to: <ul><li>create additional logins</li><li>Alter Logins: Enable/Disable</li><li>Reset Passwords</li><li>Drop Logins</li></ul> |  Y | ? | ? |
| 300_A1_C_DROP_DBA_with_AlterAnyLogin.sql | Clean-Up Security-DBA-for-LOGINs  |  Y | ? | ? |
| 300_B1_A_CREATE_DBA_with_AlterAnyUser.sql | Create a **Security-DBA-for-USERs** with permission to create database-users based on other logins (previously created by *Security-DBA-for-LOGINs* |  Y | ? | ? |
| 300_B1_B_Test_DBA_with_AlterAnyUser_to_create_users.sql | Login as Security-DBA-for-USERs to: <ul><li>Try to SELECT from tables</li><li>Try to modify own Masking Settings</li><li>Try to execute DBCC</li><li>Try to execute DBCC commands</li><li>Create Database-Users</li><li>Drop Database-Users</li></ul> |  Y | ? | ? |
| 300_B1_C_Test_DBA_with_AlterAnyUser_to_grant_users.sql | Login as Security-DBA-for-USERs to: <ul><li>Try to Add database-users to *Database-Roles*</li><li>Try to execute *sp_addrolemember* to add database-users to roles</li><li>Try to *GRANT* permissions to Database-Users</li></ul> |  Y | ? | ? |
| 300_B1_D_Test_end_user.sql | Login using credentials created in previous scripts to:<ul><li>Execute *SELECT* on tables</li><li>Try to manipulate Masking settings</li><li>Try to execute DBCC commands</li></ul>  |  Y | ? | ? |
| 300_B1_E_DROP_DBA_with_AlterAnyUser.sql | Clean-Up Security-DBA-for-Users |  Y | ? | ? |
| 300_C1_A_CREATE_DBA_with._CreateRole.sql | Create a **Security-DBA-for-Roles** |  Y | ? | ? |
| 300_C1_B_CREATE_Roles_GrantPermissions_AddMembers.sql | Login as Security-DBA-for-Roles to:<ul><li>Create Roles</li><li>Grant permissions to these new roles</li><li>Add Members into these Roles</li></ul> |  Y | ? | ? |
| 300_C1_C_Test_EndUsers_vs_Roles.sql | Test end-user access for those placed in the roles created |  Y | ? | ? |
| 300_C1_D_DROP_objects_created_by_DBA_with_CreateRole.sql | Login as Security-DBA-for-Roles to Clean-up:<ul><li>Remove members from Roles</li><li>Drop roles</li></ul> |  Y | ? | ? |
| 300_C1_E_Drop_UserAndLogin_DBA_with_CreateRole.sql | Login as sa to clean-up:<ul><li>Remove member *Security-DBA-for-Roles* from Roles</li><li>Drop User and Login *Security-DBA-for-Roles*</li></ul>  |  Y | ? | ? |

