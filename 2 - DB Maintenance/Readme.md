# Database Maintenance

## This folder contains scripts to demonstrate the use of ACCESS CONTROL in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing them to perform Database maintenance.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

Use the following scripts in the order they appear in the table below:

## NOTE: all scripts display at the very top the **login name** that should be used for that script. 

| Script | Description |
| ----------- | ----------- |
| 200_A1_A_create_DBA_for_Backup.sql | Create a login who will perform backup operations | 
| 200_A1_B_Login_with_DBA_for_BACKUP_and_take_backups.sql | Login as Backup operator.<br> Verify the backup operator doesn't have access to tables. <br> Perform FULL backup on databases: <ul><li>master</li><li>AdventureWorks</li></ul>  | 
| 200_A1_C_create_Enlarged_table_in_AdventureWorks.sql | Creates and populate a new table  | 
| 200_A1_D_update_Enlarged_table_in_AdventureWorks.sql | update rows in the new table | 
| 200_A1_E_update_Enlarged_table_in_AdventureWorks.sql | Clean-up Login and User for Backup Operator | 
| 200_A2_A_create_DBA_for_RESTORE.sql | Create a login who will perform restore operations | 
| 200_A2_B_login_with_DBA_for_RESTORE_and_restore_databases.sql | Login as Restore operator.<br> Perform Restore on database: <ul><li>AdventureWorks</li></ul> | 
| 200_A2_C_CleanUp_RestoredDatabase.sql | Clean-up entries on MSDB<br>Drops restored database  | 
| 200_A2_S_CleanUp_Login_User.sql | Clean-up Login and User for Restore operator | 
| 200_B1_A_Create_DBA_with_db_ddlAdmin.sql | Creates a Login and User for DDL-Admin | 
| 200_B1_B_test_DBA_with_db_ddlAdmin_index_Maintenance.sql | Login as DDL-Admin.<br>Executes statements to: <ul><li>Create a Table</li><li>Altetr Table</li><li>Access Data from created table</li><li>Add (document) Extended Properties to the table</li><li>try to select data from the created table</li><li>try to drop created table</li><li>try to overpower masking settings</li><li>Try to select data from other schemas/tables</li><li>Creates Indexes</li><li>Alter Indexes</li><li>Drop Indexes</li><li>Alter Indexes</li><li>Create Views</li></ul> | 
| 200_B1_C_test_DBA_with_db_ddlAdmin_statistics_Maintenance.sql | Login as DDL-Admin.<br>Executes statements to: <ul><li>Create Statistics</li><li>Update Statistics</li><li>Drop Statistics</li></ul>|
| 200_B1_D_DROP_DBA_with_db_ddlAdmin.sql |  | 
| 200_D1_A_x03A_create_DBA_without_DBOWNER.sql |  | 
| 200_D1_B_x04A_create_elevated_logins_roles.sql |  | 
| 200_D1_C_x04B_create_elevated_SPs.sql |  | 
| 200_D1_D_Test_SPs.sql |  | 
| 200_D1_E_CleanUp.sql |  | 
| 200_D27_A_x03C1_Create_DBA_with_ServerAdmin.sql |  | 
| 200_D27_B_x03C2_test_DBA_with_ServerAdmin.sql |  | 
| 200_D27_C_CleanUp.sql |  | 
