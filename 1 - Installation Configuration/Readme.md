# Installation-Configuration

## This folder contains instructions on how to create wrapper code related to operations that require higher permissions and will be executed as Stored-Procedures

Use the following scripts in the order they appear in the table below:

## NOTE: all scripts display at the very top the **login name** that should be used for that script. 

| Script | Description |
| ----------- | ----------- |
| 100_B1_create_Login_User.sql | Creates a high-privilege Login and corresponding User account on Master. This account is used on following scripts to create wrapper code | 
| 100_B2_wrapper_create_sp_configure.sql | | 
| 100_B3_wrapper_validate_sp_configure.sql | | 
| 100_B4_DROP_Objects.sql | | 
| 100_B5_Drop_User_Login.sql | | 
