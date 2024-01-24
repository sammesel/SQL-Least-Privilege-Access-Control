# Auditing

## This folder contains instructions on how to review contents with PII and PHI and setup data masking, data classification, and work with Auditing resources available in SQL Server

It is assumed you know how to use SQL Server Data Discovery and Classification tool. A tutorial is available at [MS LEARN](https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver16&tabs=t-sql)

use the following scripts in the order they appear in the table below:

| Script | Description |
| ----------- | ----------- |
| 010 - CREATE AUDIT SERVER.sql                                  | Stops and Drops existing <named> Server-Audit.<br> Creates <named> Server-Audit    | 
| 020 - AUDIT SERVER SPEC.sql                                    | Drops an existing <named> Server-Audit-Specification.<br> Creates <named> Server-Audit-Specification    | 
| 030 - AUDIT Database Spec.sql                                  | Stops and Drops an existing <named> Database-Audit-Specification.<br> Creates <named> Database-Audit-Specification    | 
| 040 - ENABLE AUDITING.sql                                      | Enables (starts) Server-Audit and Database-Audit specifications   |
| 050 - DATA CLASSIFICATION.sql                                  | Drops previously created SENSITIVITY CLASSIFICATION on Columns.<br> Adds  SENSITIVITY CLASSIFICATION to columns with PII and PHI data   |
| 060 - ALTER Database Audit Spec after data classification.sql  | Disables <named> Database-Audit-Specification.<br> Alters <named> Database-Audit-Specification to add events that deal with SENSITIVE classified data.<br> Re-enables <named> Database-Audit-Specification.  |
| 070 - List_of_columns_with_data_classification.sql             | Lists and Validates SENSITIVE CLASSIFICATION is added to columns with PII and PHI data   |
| 080 - SQLServer_DataDiscoveryClassification_Tool.sql           | URL pointing to [MS Learn](https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver16&tabs=t-sql) showing how to use SSMS UI tool to work with SENSITIVE CLASSIFIED data   |
| 090 - Apply_DataMasking_to_data_Classified_Columns.sql         | Applies Dynamic-Data-Masking using DEFAULT function to columns.<br> Lists all Columns and properties with Dynamic-Data-Masking.<br> Lists Tables that contain columns with Dynamic-Data-Masking    |
| 100 - CREATE_EndUser_to_select_Masked_Columns.sql              | Creates an End-User to be test Dynamic-Data-Masking.<br> Adds this user to db_datareader and db_datawriter Database-Roles.    |
| 110 - Test_EndUser_selecting_Masked_Columns.sql                | script to validate End-User cannot see raw-data, only Masked-Data.<br>**Make sure to change connection to use new End-User Login/password**    |
| 120 - Observe Auditing Records.SQL                             |    |
| 130 - CleanUp_EndUser.sql                                      |    |
| 140 - Stop_Auditing_Capture.SQL                                |    |
