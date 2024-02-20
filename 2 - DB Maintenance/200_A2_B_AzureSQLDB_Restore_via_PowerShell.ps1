## ========================================================================================================================================================
## RESTORE
## ========================================================================================================================================================

# The input parameters for the script
$ServerInstance = "YourServerInstance" # The name of the SQL Server instance where you want to restore the database
$DatabaseName = "YourDatabaseName" # The name of the database to be restored
$BacpacFile = "YourBacpacFile.bacpac" # The path to the BACPAC file
$Credential = Get-Credential # The credential object for the SQL Server login

# Import the SQL Server PowerShell module
Import-Module -Name SqlServer

# Restore the database from the BACPAC file using the Restore-SqlDatabase cmdlet
Restore-SqlDatabase -ServerInstance $ServerInstance -Database $DatabaseName -BackupFile $BacpacFile -Credential $Credential






# The input parameters for the script
$ResourceGroup = 'azuresql-db-mi-demos'
$AzureSQLDB_ServerName = 'azuresql-db-server001'
$AzureSQLDB_DatabaseName= 'SQLSecurityDemoDB'


$RestoreDatabaseName = "SQLSecurityDemoDB_Restored" # The name of the database to be restored
$BacpacName = "via_ps_SQLSecurityDemoDB_02082024.bacpac"
$StorageUri = "https://$StorageAccountName.blob.core.windows.net/sql-backup-and-log-files/$BacpacName"

$StorageUri = "https://st4dbxferdatalogbackups.blob.core.windows.net/sql-backup-and-log-files/SQLSecurityDemoDB-2024-2-8-22-38.bacpac"

$StorageAccountName = "st4dbxferdatalogbackups"
$StorageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName $ResourceGroup  -Name $StorageAccountName).Value[0]
# $StorageKey = "YourStorageAccountKey" # The access key of the Storage Account where the BACPAC file is stored

$Credential = Get-Credential # The credential object for the SQL Server login

# Import the SQL Server PowerShell module
## Import-Module -Name SqlServer

# Restore the database from the BACPAC file using the Restore-SqlDatabase cmdlet
Restore-SqlDatabase -ServerInstance $AzureSQLDB_ServerName  -Database $RestoreDatabaseName -StorageKey $StorageAccountKey -StorageUri $StorageUri -Credential $Credential

Restore-SqlDatabase 
