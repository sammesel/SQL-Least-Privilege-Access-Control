# Installation-Configuration

## This folder contains instructions on how to create wrapper code related to operations that require higher permissions and will be executed as Stored-Procedures

Use the following scripts in the order they appear in the table below:

## NOTE: all scripts display at the very top the **login name** that should be used for that script. 

| Script | Description |
| ----------- | ----------- |
| 100_B1_create_Login_User.sql | Creates a high-privilege Login and corresponding User account on Master. This account is used on following scripts to create wrapper code | 
| 100_B2_wrapper_create_sp_configure.sql | Creates a SCHEMA to contain a set of code (Stored Procedures).<br> Creates Sample Stored-Procedures to execute system stored procedure **sp_configure**.<br> up_sp_configure_show_advanced_options activates the display of advanced options.<br> tools.up_sp_configure lists SQL Server configuration.<br> up_sp_configure_option_value validates parameters to avoid SQL-Injection and executes **sp_configure** to change the option with the given value - for basic configurations only.<br> up_sp_configure_advanced_option_value is similar to up_sp_configure_option_value but only for advanced options   | 
| 100_B3_wrapper_validate_sp_configure.sql | | 
| 100_B4_DROP_Objects.sql | | 
| 100_B5_Drop_User_Login.sql | | 
