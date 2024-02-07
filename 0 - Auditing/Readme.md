# Auditing

## This folder contains instructions on how to review contents with PII and PHI and setup data masking, data classification, and work with Auditing resources available in SQL Server

It is assumed you know how to use SQL Server Data Discovery and Classification tool. A tutorial is available at [MS LEARN](https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver16&tabs=t-sql)


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

| Script | Description  | SQL Server on VM | Azure SQL MI | Azure SQL DB |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 010 - Azure_SQL_MI  CREATE AUDIT SERVER.sql                    | **This script is for an AZURE SQL MI only**<br>Stops and Drops existing <named> Server-Audit.<br> Creates <named> Server-Audit    |  N | Y | ? |
| 010 - SQLServer_on_VM CREATE AUDIT SERVER.sql                  | **This script is for SQL Server running on VM only**<br>Stops and Drops existing <named> Server-Audit.<br> Creates <named> Server-Audit    |  Y | N | ? |
| 010 - CREATE AUDIT SERVER.sql                                  | Stops and Drops existing <named> Server-Audit.<br> Creates <named> Server-Audit    |  Y | Y | ? |
| 020 - AUDIT SERVER SPEC.sql                                    | Drops an existing <named> Server-Audit-Specification.<br> Creates <named> Server-Audit-Specification    |  Y | Y | ? |
| 030 - AUDIT Database Spec.sql                                  | Stops and Drops an existing <named> Database-Audit-Specification.<br> Creates <named> Database-Audit-Specification    |  Y | Y | ? |
| 040 - ENABLE AUDITING.sql                                      | Enables (starts) Server-Audit and Database-Audit specifications   | Y | Y | ? |
| 050 - DATA CLASSIFICATION.sql                                  | Drops previously created SENSITIVITY CLASSIFICATION on Columns.<br> Adds  SENSITIVITY CLASSIFICATION to columns with PII and PHI data   | Y | Y | ? |
| 060 - ALTER Database Audit Spec after data classification.sql  | Disables <named> Database-Audit-Specification.<br> Alters <named> Database-Audit-Specification to add events that deal with SENSITIVE classified data.<br> Re-enables <named> Database-Audit-Specification.  | Y | Y | ? |
| 070 - List_of_columns_with_data_classification.sql             | Lists and Validates SENSITIVE CLASSIFICATION is added to columns with PII and PHI data   | Y | Y | ? |
| 080 - SQLServer_DataDiscoveryClassification_Tool.sql           | URL pointing to [MS Learn](https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver16&tabs=t-sql) showing how to use SSMS UI tool to work with SENSITIVE CLASSIFIED data   | Y | Y | ? |
| 090 - Apply_DataMasking_to_data_Classified_Columns.sql         | Applies Dynamic-Data-Masking using DEFAULT function to columns.<br> Lists all Columns and properties with Dynamic-Data-Masking.<br> Lists Tables that contain columns with Dynamic-Data-Masking    | Y | Y | ? |
| 100 - CREATE_EndUser_to_select_Masked_Columns.sql              | Creates an End-User to be test Dynamic-Data-Masking.<br> Adds this user to db_datareader and db_datawriter Database-Roles.    | Y | Y | ? |
| 110 - Test_EndUser_selecting_Masked_Columns.sql                | script to validate End-User cannot see raw-data, only Masked-Data.<br>**Make sure to change connection to created End-User Login/password**    | Y | Y | ? |
| 120 - Azure_SQL_MI  Observe Auditing Records - Storage Account.SQL  | **This script is for an AZURE SQL MI only**<br>Review AUDIT entries made by End-User   | N | Y | ? |
| 120 - SQLServer_on_VM Observe Auditing Records.SQL                  | **This script is for SQL Server running on VM only**<br>Review AUDIT entries made by End-User   | Y | N | ? |
| 130 - CleanUp_EndUser.sql                                      | After testing End-User and checking the AUDIT entries, DROP End-User user and Login  | Y | Y | ? |
| 140 - Stop_Auditing_Capture.SQL                                | This script is to be used as very last script, after testing the complete solution (**not only the Scripts on the AUDITING folder**) stop and drop Audit resources  | Y | Y | ? |
