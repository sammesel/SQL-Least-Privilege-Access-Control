# Installation-Configuration

## This folder contains instructions on how to create wrapper code related to operations that require higher permissions and will be executed as Stored-Procedures


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

| Script | Description | SQL Server on VM | Azure SQL DB | Azure SQL MI |
| ----------- | ----------- | ----------- | ----------- | ----------- |
| 100_B1_create_Login_User.sql | Creates a high-privilege Login and corresponding User account on Master. This account is used on following scripts to create wrapper code |  Y | ? | ? |
| 100_B2_wrapper_create_sp_configure.sql | Creates a SCHEMA to contain a set of code (Stored Procedures).<br> Creates Sample Stored-Procedures to execute system stored procedure **sp_configure**.<ul><li>up_sp_configure_show_advanced_options activates the display of advanced options.</li><li>up_sp_configure lists SQL Server configuration.</li><li>up_sp_configure_option_value validates parameters to avoid SQL-Injection and executes **sp_configure** to change the option with the given value - for basic configurations only.</li><li>up_sp_configure_advanced_option_value is similar to up_sp_configure_option_value but only for advanced options</li></ul>   |  Y | ? | ? |
| 100_B3_validate_wrapper_code.sql | uses a login to call wrapper code|  Y | ? | ? |
| 100_B4_DROP_Objects.sql | Drops all Stored-Procedures related to **sp_configure** and the tools schema |  Y | ? | ? |
| 100_B5_Drop_User_Login.sql | Drops the high-privilege Login |  Y | ? | ? |
