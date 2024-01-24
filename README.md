# SQL-Least-Privilege-Access-Control

This is a solution to implement SQL Server security, by removing rights of DBAs to SELECT data from tables
The implementation is structured having the following principles:

- 1st: Identification of columns with PII or PHI data that need to be masked

  - masking these columns
  - Setting these columns to be audited with DATA CLASSIFICATION access
  - Set SQL Server Auditing on the instance
  - Set SQL Server Database auditing for the database containing that data

- 2nd: Identify common Database Admin tasks and define privileges needed for those tasks. The solution developed with this repo considers the following possibilities:
  - BREAK GLASS. Where the DBA requires a system admin account to perform the job. This includes but is not limited to:
    - Configure AlwaysON Availability Group
    - Setup Replication
    - Setting Resource Governor
  - Access Control. Activities that can be performed by a DBA that require permissions that can be granted using
    - Server Roles
    - Database Roles
    - Custom Roles
  - Wrapper Code. Activities that can be performed by executing Stored Procedure code developed for single purpose, like:
    - running DBCC commands
    - setting or changing QUERY STORE properties
  

  This solution prioritized finding Access Control options, as these are easy to implement, and backward compatible with future SQL Server versions

  It is recommended first to work with the contents on the AUDITING folder, and then use the contents on the other folders as needed

  note: the database used is a copy of the AdventureWorks sample database

  This Sample Code is provided for the purpose of illustration only and is not intended
  to be used in a production environment.  THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE
  PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT
  NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR
  PURPOSE.  We grant You a nonexclusive, royalty-free right to use and modify the Sample Code
  and to reproduce and distribute the object code form of the Sample Code, provided that You
  agree: 
    (i) to not use Our name, logo, or trademarks to market Your software product in which
    the Sample Code is embedded; 
    (ii) to include a valid copyright notice on Your software product in which the Sample 
    Code is embedded; 
    and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and against 
    any claims or lawsuits, including attorneys fees, that arise or result from the use or distribution 
    of the Sample Code.

