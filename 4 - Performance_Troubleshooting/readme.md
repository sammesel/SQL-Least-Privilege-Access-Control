# Performance Troubleshooting

## This folder contains scripts to demonstrate the use of ACCESS CONTROL and/or WRAPPER CODE in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing DBAs to perform Performance Troubleshooting tasks.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

Use the following scripts in the order they appear in the table below:

| Script | Description | SQL Server on VM | Azure SQL DB | Azure SQL MI |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 400_A1_test_DBAs_sys_log_on_AzureSQLDB.sql | This script is applicable for **Azure SQL Database** only.<br> Read EVENT-LOG records  | N | N | Y |
| 400_A2_A_Create_Internal_LoginUserRole_for_errorlog.sql | Create Login and User for an **ErrorLog-Principal**<br>Create a ROLE for **ErrorLog-Principal**<br>Grant:<ul><li>access to stored procedures: *xp_readerrorlog* and *sp_readerrorlog*</li><li>VIEW ANY ERROR LOG</li><li>Grant CONTROL to the Role</li><li>Grant ALTER to the role</li><li>Grant VIEW SERVER STATE to the login</li></ul> | Y | Y | ? |
| 400_A2_B_create_wrapper_code_for_errorlog.sql| Create wrapper stored procedures for:<ul><li>*sp_readerrorlog*</li><li>*sp_cycle_errorlog*</li></ul>   | Y | Y | ? |
| 400_A2_C_Test_LOGIN_internal_principal_errorlog.sql | Test executing wrapper code  | Y | Y | ? |
| 400_A2_D_DROP_WrapperCode_UserLogin.sql | Clean-Up  | Y | Y | ? |
| 400_A2_Z_Explanation.sql | Auxiliary queries to explain the grants given to the Login  | Y | Y | ? |
| 400_B1_A_Create_DBA_with_ServerPerformance.sql | Create Login **PerformanceTroubleshooting-DBA**<br>Create Role **PerformanceTroubleshooting-Role**<br>Add DBA into Role<br>Grant permisions to Role | Y | Y | ? |
| 400_B1_B1_Test_DMVs_DBA_With_Performace<br>Troubleshooting.sql | Login as **PerformanceTroubleshooting-DBA**<br><ul><li>Try to add self to **db_datareader** database-role</li><li>Try to SELECT data from tables</li><li>Execute SELECT from performance related DMVs</li></ul> | Y | Y | ? |
| 400_B1_B2_Test_ErrorLog_DBA_With_<br>PerformaceTroubleshooting.sql | Login as **PerformanceTroubleshooting-DBA**<br><ul><li>Execute xp_readerrorlog</li><li>Execute sys.sp_enumerrorlogs</li></ul> | Y | Y | ? |
| 400_B1_C1_AzureSQL_DB_Grant_Alter<br>AnyConnection_to_DBA_with_ServerPerformance.sql | -- in development -- | ? | ? | ? |
| 400_B1_C1_SQLServer_on_VM_Grant_<br>AlterAnyConnection_to_DBA_with_ServerPerformance.sql| Grant additional to allow DBA to KILL running sessions | Y | Y | ? |
| 400_B1_C2_create_Blocking_Session.sql | Simmulate long running transaction that places an Exclusive Lock (Block) on rows that are needed on next script  | Y | Y | ? |
| 400_B1_C3_create_Blocked_Session.sql | Issue SELECT statement (Shared Lock) on rows that are blocked by previous script | Y | Y | ? |
| 400_B1_C4_DBA_monitor_and_Kill_Blocking_Session | Login as **PerformanceTroubleshooting-DBA**  | Y | Y | ? |
| **400_B1_D_DROP_DBA_With_Performace<br>Troubleshooting.sql** | Clean-up Login / User / Role **PerformanceTroubleshooting-DBA**  | Y | Y | ? |
| 400_C1_A_Create_DBA_for_QueryStore.sql | Create Login User and Role for **QueryStore-DBA**<br>Grant VIEW DATABASE STATE to Role<br>Create *dba_tools_QueryStore* Schema for **QueryStore-SPs**<br>Grant EXECUTE on *dba_tools_QueryStore* Schema to the Role | Y | Y | ? |
| 400_C1_B_QUERY_STORE_create_<br>elevated_logins_roles.sql | Create Login User and Role for an internal-principal<br> Grant ALTER DB permission to Role<br>  | Y | Y | ? |
| 400_C1_C_QUERY_STORE_create_<br>WrapperCode.sql | Create Stored Procedures under the permissions of the internal-principal :<ul><li>up_sp_query_store_set_storage - to modify QAuery Store  storage size</li><li>up_sp_query_store_force_plan - to force a Query-ID to use a given Plan-Id</li></ul> | Y | Y | ? |
| 400_C1_D_Demo_Query_Store_Query<br>WithMultiplePlans.sql | Creates a Stored Procedure that selects from 2 tables using a parameter for filter.<br> Executes this Stored Procedure 2 times with different parameters to generate entries in the Query Store | Y | Y | ? |
| 400_C1_E_Test_DBA_for_QueryStore.sql | Login as **QueryStore-DBA** to perform tests:<ul><li>Try to select from tables</li><li>Perform SELECT statement on Query Store tables</li></li>Try to execute sp_query_store_force_plan</li><li>Execute Wrapper Code to force plan</li><li>Try to ALTER DATABASE to change Query Store storage size</li><li>Execute Wrapper Code to change Query Store storage size</li></ul>   | Y | Y | ? |
| 400_C1_F_DROP_DBA_for_QueryStore.sql.sql | Clean-up | Y | Y | ? |
| 400_E1_A_ExtendedEvent_Security_SQL2022.sql | Explains permissions introduced with SQL Server 2022 to manage **Extended Events** permissions   | Y | Y | ? |
| 400_E1_B1_A_Create_DBA_with_<br>ALTER_ANY_EVENT_SESSION.sql | Create Login User Role to a principal who Creates/Alters/Drops Extended Event **sessions**   | Y | Y | ? |
| 400_E1_B1_B_Create_DBA_with_<br>VIEW_SERVER_PERFORMANCE_STATE_for_XEVENTS.sql | Create Login User Role to a principal who Reads Extended Event **sessions**  | Y | Y | ? |
| 400_E1_C1_A_Login_DBA_with_<br>ALTER_ANY_EVENT_SESSION_to_create_session.sql | Login as **DBA-CreateXevents** to Create and Start an Xevent **session**   | Y | Y | ? |
| 400_E1_C1_B_Login_DBA_with_<br>VIEW_SERVER_PERFORMANCE_STATE_to_read_Xevents.sql | Login as **DBA-ReadXevents** to Read data captured on the Xevent **session**    | Y | Y | ? |
| 400_E1_D1_A_DROP_DBA_with_<br>ALTER_ANY_EVENT_SESSION.sql | Clean-Up **DBA-CreateXevents** principal and objects    | Y | Y | ? |
| 400_E1_D1_A_DROP_DBA_with_<br>VIEW_SERVER_PERFORMANCE_STATE.sql | Clean-Up **DBA-ReadsXevents** principal and objects    | Y | Y | ? |
