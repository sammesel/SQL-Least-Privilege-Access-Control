# Object Management

## This folder contains scripts to demonstrate the use of ACCESS CONTROL in one of the formats below to restrict DBAs of having access to PII and PHI data, and at the same time allowing them to perform object maintenance Tasks.
<ul>
  <li>Server-Roles</li>
  <li>Database-Roles</li>
  <li>Custom-Roles</li>
</ul>

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

| Script | Description | SQL Server on VM | Azure SQL MI | Azure SQL DB |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 500_B1_AlterColumn.sql | Login as **DBA_With_DB_DDLAdmin** created on script [200_B1_A_Create_DBA_with_db_ddlAdmin.sql]<br>Performs operations to alter table by<ul><li>Add/Alter/Drop column</li><li>Add/Drop Constraint</li><li>Change Compression Type</li><li>Change Lock Escalation</li><li>Perform Index Maintenance</li></ul> |  Y | Y | ? |
| 500_B4_A_Create_drop_schemas.sql | Login as **DBA_With_DB_DDLAdmin** created on script [200_B1_A_Create_DBA_with_db_ddlAdmin.sql]<br>to:<ul><li>create Schema</li><li>Create a table inside the schema</li><li>Drop Table/Schema</li><li>Create/Drop VIEW</li></ul> |  Y | Y | ? |
