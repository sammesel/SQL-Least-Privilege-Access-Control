# Auditing

## This folder contains instructions on how to review contents with PII and PHI and setup data masking, data classification, and work with Auditing resources available in SQL Server

It is assumed you know how to use SQL Server Data Discovery and Classification tool. A tutorial is available at [MS LEARN](https://learn.microsoft.com/en-us/sql/relational-databases/security/sql-data-discovery-and-classification?view=sql-server-ver16&tabs=t-sql)

use the following scripts in the order they appear in the table below:

| Script | Description |
| ----------- | ----------- |
| 010 - CREATE AUDIT SERVER.sql                                  | Stops and Drops existing <named> Server-Audit.<br> Creates <named> Server-Audit    | 
| 020 - AUDIT SERVER SPEC.sql                                    | Drops an existing <named> Server-Audit-Specification.<br> Creates <named> Server-Audit-Specification    | 
| 030 - AUDIT Database Spec.sql                                  |    |
| 040 - ENABLE AUDITING.sql                                      |    |
| 050 - DATA CLASSIFICATION.sql                                  |    |
| 060 - ALTER Database Audit Spec after data classification.sql  |    |
| 070 - List_of_columns_with_data_classification.sql             |    |
| 080 - SQLServer_DataDiscoveryClassification_Tool.sql           |    |
| 090 - Apply_DataMasking_to_data_Classified_Columns.sql         |    |
| 100 - CREATE_EndUser_to_select_Masked_Columns.sql              |    |
| 110 - Test_EndUser_selecting_Masked_Columns.sql                |    |
| 120 - Observe Auditing Records.SQL                             |    |
| 130 - CleanUp_EndUser.sql                                      |    |
| 140 - Stop_Auditing_Capture.SQL                                |    |
