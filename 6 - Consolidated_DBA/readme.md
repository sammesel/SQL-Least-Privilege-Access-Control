# Consolidated DBA

## This folder contains scripts to demonstrate how to consolidate all granular permissions to a single DBA, and yet prevent this principal of seeing unmasked data.

### NOTE: there are pending actions on this folder:
<ul>
  <li>clean-up of the scripts</li>
  <li>Elimination of unnecessary wrapper code</li>
  <li>further optimization</li>
</ul>

## NOTES: 

### All scripts display at the very top the **login name** that should be used for that script.<br>
<ul>
<li>Execute the Query to display the username to make sure you are using the correct persona</li>
<li>For scripts that switch between MASTER and the SQLSecurityDemoDB databases:<ul>
  <li>After Switching the database, execute the query to display the username again, so you can see how that user is mapped</li>
  <li>When testing these scripts on Azure SQL Database the **USE** command will fail, you need to switch the database manually via SSMS toolbar</li>
  </ul>
</ul>
<br>

### The script filenames use the digit 6 (six) as prefix, and the subsequent initials are taken from the files on the other folders<br>
for instance:<br>
| Script on this folder | Original folder | Original Script | Description |
| ----------- | ----------- | ----------- | ----------- | 
| **6**500_B1_AlterColumn.sql | 5 - Object Management | 500_B1_AlterColumn.sql | Uses the same t-sql code to modify tables and validate that consolidated permissions for DBA work |


## Scripts
Use the following scripts in the order they appear in the table below:

| Script | Description | SQL Server on VM | Azure SQL MI | Azure SQL DB |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 6001_consolidated_ControlAccess_for_DBAs.sql | <li>Create a Database Role<br><li>Create a Server Role<br><li>Create a Schame for wrapper-code<br><li>Grant permissions to the roles<br><li>Create Stored Procedures in the schema | Y | ? | ? |
| 6002_create_Login_User_TestDBA_Add_to_Roles.sql | <li>Create LOGIN, USER for: **[Login_Test_DBA]** <br><li>Add Login and User to database-roles | Y | ? | ? |
| 6003_Login_and_Test_DBA.sql | LOGIN as [Login_Test_DBA]<br>Try to connect to target-database  | Y | ? | ? |
| 6004_Create_USER_for_Test_DBA_<BR>OnTargetDatabase.sql | Create USER for [Login_Test_DBA] in the target database<br>Create database-role in the target database<br>Grant permissions to database-role<br>add user into database-role | Y | ? | ? |
| 6005_Login_and_Test_DBA_On_<BR>TargetDatabase.SQL |  LOGIN as [Login_Test_DBA]<br>Connect to target-database<br>Try to select from tables in the target database  | Y | ? | ? |
| 6006_GRANT_datareader_to_Test_DBA_<BR>OnTargetDatabase.sql | Grant db_datareader to the database-role | Y | ? | ? |
| 6010_AUDIT_DBA_Create_Server_Audit.sql | LOGIN as [Login_Test_DBA]<br>Create Server-Audit<br>Start Server-Audit  | Y | ? | ? |
| 6100_B3_validate_wrapper_code.sql | **TO BE REVIEWED** we may not need this wrapper-code and the test for the wrapper-code | Y | ? | ? |
| 6200_A1_B_SQLServer_on_VM_Login_<BR>with_DBA_for_BACKUP_and_take_backups.sql | LOGIN as [Login_Test_DBA]<br>Executes Full/Differential/LOG backup of the target database  | Y | ? | ? |
| 6200_A2_B_SQLServer_on_VM_login_<BR>with_DBA_for_RESTORE_and_restore_databases.sql |  LOGIN as [Login_Test_DBA]<br>Executes Restore into a new database from FULL/Differential/LOG backup of the target database  | Y | ? | ? |
| 6200_B1_B_1_test_fails_DBA_with_<BR>db_ddlAdmin_index_Maintenance.sql | LOGIN as [Login_Test_DBA]<br>Try to perform DDL maintenance | Y | ? | ? |
| 6200_B1_B_2_Grant_db_ddladmin_<BR>toTest_DBA_on_target_database.sql | Grant **db_ddladmin** to [Login_Test_DBA] | Y | ? | ? |
| 6200_B1_B_3_Grant_ALTER_ANY_<BR>SENSITIVITY_CLASSIFICATION_to_Test_DBA.SQL | Grant **SENSITIVITY_CLASSIFICATION** to [Login_Test_DBA]  | Y | ? | ? |
| 6200_B1_C_test_succeed_DBA_with_<BR>db_ddlAdmin_statistics_maintenance.sql | LOGIN as [Login_Test_DBA]<br>Execute Statistics maintenance | Y | ? | ? |
| 6200_B2_B_4_test_succeed_DBA_with_<BR>db_ddladmin_index_Maintenance.sql | LOGIN as [Login_Test_DBA]<br>Execute Index maintenance | Y | ? | ? |
| 6200_D1_SKIP_SKIP_SKIP_D_test_DBCC_wrapper.sql | **TO BE REVIEWED** | Y | ? | ? |
| 6200_D27_B_test_DBA_with_ServerAdmin.sql | LOGIN as [Login_Test_DBA]<br>issue CHECKPOINT<br>Issue sp_lock<br>Issue sp_who | Y | ? | ? |
| 6300_B1_A_grant_AlterAnyUser_to_Test_DBA.sql | Grant **ALTER ANY USER** to LOGIN [Login_Test_DBA]<br>Create few LOGINS to be tested on next scripts  | Y | ? | ? |
| 6300_B1_B_Test_DBA_to_create_users.sql | LOGIN as [Login_Test_DBA]<br>Create database users from LOGINs previously created | Y | ? | ? |
| 6300_B1_C_Test_DBA_to_grant_users.sql | **TO BE REVIEWED** LOGIN as [Login_Test_DBA]<br>Try to add new users into db_datareader<br>Grant UPDATE/SELECT on Schemas to new users | Y | ? | ? |
| 6300_C1_B_Test_DBA_to_Create_Roles_<BR>GrantPermissions_AddMembers.sql | LOGIN as [Login_Test_DBA]<br>Create new roles<br>Grant SELECT/INSERT/UPDATE/DELETE/REFERENCES on SCHEMAS for these new roles<br>Add Members to the roles | Y | ? | ? |
| 6300_C1_D_Test_DBA_to_DROP_Members<BR>FromRoles_Roles.sql | LOGIN as [Login_Test_DBA]<br>Alter Roles to drop users<br>Drop roles | Y | ? | ? |
| 6300_C1_E_drop_Users.sql | LOGIN as [Login_Test_DBA]<br>Drop users from target-database | Y | ? | ? |
| 6400_A2_C_Test_DBA_ERRORLOG.SQL | LOGIN as [Login_Test_DBA]<br>Read ERRORLOG | Y | ? | ? |
| 6400_B1_B1_Test_DBA_Performance.sql | LOGIN as [Login_Test_DBA]<Br>Execute queries based on DMVs to retrieve Performance/Telemetry | Y | ? | ? |
| 6400_C1_E_Test_DBA_for_QueryStore.sql | LOGIN as [Login_Test_DBA]<Br>Execute queries on Query-Store<br>Force an Execution Plan to a query<br>Change Query-Store Storage Settings | Y | ? | ? |
| 6400_E1_C1_A_Test_DBA_to_create_<BR>XEvents.sql | LOGIN as [Login_Test_DBA]<Br>Create Extended Event Server-Session<Br>Start / Stop Server-Session<BR>Read from Extended Events catalog Views<br>Read from Extended Events DMV<br>  | Y | ? | ? |
| 6400_E1_C1_C_Test_DBA_to_read_<BR>XEvents_fromRingBuffer.sql | LOGIN as [Login_Test_DBA]<Br>Read Extended Event entries from Ring-Buffer | Y | ? | ? |
| 6500_B1_AlterColumn.sql | LOGIN as [Login_Test_DBA]<Br>Modify Tables and Columns<br>Drop/Create/Alter Indexes | Y | ? | ? |
| 6500_B4_A_Create_Drop_Schemas.sql | LOGIN as [Login_Test_DBA]<Br>Create/Drop Schemas | Y | ? | ? |

