# Performance Troubleshooting

## This folder contains scripts to demonstrate the use of ACCESS CONTROL and/or WRAPPER CODE in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing DBAs to perform Performance Troubleshooting tasks.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

## NOTE: All scripts display at the very top the **login name** that should be used for that script.<br><ul>
<li>Use the same password when you created the login</li>
<li>Execute the Query to display the username to make sure you are using the correct persona</li>
<li>in case the script switches beteen *MASTER* and the *SQLSecurityDemoDB* databases, execute the query to display the username again, so you can see how that user is mapped</li>
<li>when testing these scripts on Azure SQL Database the USE command will fail, you need to switch the database manually on the SSMS toolbar</li>
<br>

Use the following scripts in the order they appear in the table below:

| Script | Description | SQL Server on VM | Azure SQL DB | Azure SQL MI |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 400_A1_test_DBAs_sys_log_on_AzureSQLDB.sql | This script is applicable for **Azure SQL Database** only.<br> Read EVENT-LOG records  | N | Y | ? |
| 400_A2_A_wrapper_create_sp_readerrorlog.sql | Create Login and User for an **ErrorLog-Principal**<br>Create a ROLE for **ErrorLog-Principal**<br>Grant:<ul><li>access to stored procedures: *xp_readerrorlog* and *sp_readerrorlog*</li><li>VIEW ANY ERROR LOG</li>Grant CONTROL to the Role<li></li><li>Grant ALTER to the role</li><li>Grant VIEW SERVER STATE to the login</li> | Y | ? | ? |
| 400_A2_B_Test_DBA_with_xp_errorlog.sql | Create wrapper stored procedures to:<ul><li>call *sp_readerrorlog*</li><li>call *sp_cycle_errorlog*</li></ul>   | Y | ? | ? |
| 400_A2_C_Test_WrapperCode.sql | Test executing wrapper code  | Y | ? | ? |
| 400_A2_D_DROP_WrapperCode_UserLogin.sql | Clean-Up  | Y | ? | ? |
| 400_A2_Z_Explanation.sql | Auxiliary queries to explain the grants given to the Login  | Y | ? | ? |
| 400_B1_A_Create_DBA_with_ServerPerformance.sql | Create Login **PerformanceTroubleshooting-DBA**<br>Create Role **PerformanceTroubleshooting-Role**<br>Add DBA into Role<br>Grant permisions to Role | Y | ? | ? |
| 400_B1_B1_Test_DMVs_DBA_With_PerformaceTroubleshooting.sql | Login as **PerformanceTroubleshooting-DBA**<br><ul><li>Try to add self to **db_datareader** database-role</li><li>Try to SELECT data from tables</li><li>Execute SELECT from performance related DMVs</li></ul> | Y | ? | ? |
| 400_B1_B2_Test_ErrorLog_DBA_With_PerformaceTroubleshooting.sql | Login as **PerformanceTroubleshooting-DBA**<br><ul><li>Execute xp_readerrorlog</li><li>Execute sys.sp_enumerrorlogs</li></ul> | Y | ? | ? |
| 400_B1_C_DROP_DBA_With_PerformaceTroubleshooting.sql | Clean-up Login / User / Role **PerformanceTroubleshooting-DBA**  | Y | ? | ? |
| 400_C1_A_Create_DBA_for_QueryStore.sql | Create Login User and Role for **QueryStore-DBA**<br>Grant VIEW DATABASE STATE to Role<br>Create Schema for **QueryStore-SPs**<br>Grant EXECUTE on Schema to the Role | Y | ? | ? |
| 400_C1_B_QUERY_STORE_create_elevated_logins_roles.sql |  | Y | ? | ? |
| 400_C1_C_QUERY_STORE_create_WrapperCode.sql |  | Y | ? | ? |
| 400_C1_D_Test_DBA_for_QueryStore.sql |  | Y | ? | ? |
| 400_C1_Z_DROP_DBA_for_QueryStore.sql.sql |  | Y | ? | ? |
| 400_E1_A_ExtendedEvent_Security_SQL2022.sql |  | Y | ? | ? |


