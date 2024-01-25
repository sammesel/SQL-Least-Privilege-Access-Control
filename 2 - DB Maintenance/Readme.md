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
| 200_A1_A_create_DBA_for_Backup.sql |  | 
| 200_A1_B_Login_with_DBA_for_BACKUP_and_take_backups.sql |  | 
| 200_A1_C_create_Enlarged_table_in_AdventureWorks.sql |  | 
| 200_A1_D_update_Enlarged_table_in_AdventureWorks.sql |  | 
| 200_A2_A_create_DBA_for_RESTORE.sql |  | 
| 200_A2_B_login_with_DBA_for_RESTORE_and_restore_databases.sql |  | 
| 200_A2_C_CleanUp.sql |  | 
| 200_B1_A_x03C0B_Create_DBA_with_db_ddlAdmin.sql |  | 
| 200_B1_B_x03C0C_test_DBA_with_db_ddlAdmin_index_Maintenance.sql |  | 
| 200_B1_C_x03C0D_test_DBA_with_db_ddlAdmin_statistics_Maintenance.sql |  | 
| 200_B1_D_x03C0E_DROP_DBA_with_db_ddlAdmin.sql |  | 
| 200_D1_A_x03A_create_DBA_without_DBOWNER.sql |  | 
| 200_D1_B_x04A_create_elevated_logins_roles.sql |  | 
| 200_D1_C_x04B_create_elevated_SPs.sql |  | 
| 200_D1_D_Test_SPs.sql |  | 
| 200_D1_E_CleanUp.sql |  | 
| 200_D27_A_x03C1_Create_DBA_with_ServerAdmin.sql |  | 
| 200_D27_B_x03C2_test_DBA_with_ServerAdmin.sql |  | 
| 200_D27_C_CleanUp.sql |  | 
