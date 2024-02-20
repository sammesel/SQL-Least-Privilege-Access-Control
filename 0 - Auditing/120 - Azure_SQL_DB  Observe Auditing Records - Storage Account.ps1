<#
There are different ways to read from audit records in Azure SQL Database 
--------------------------------------------------------------------------

depending on where you store the audit logs. You can store the audit logs in:
	- Log Analytics: You can use the Azure portal to view the audit logs and use Azure Monitor logs to run 
		advanced searches and queries on your audit log data1.
	- Event Hubs: You can use a stream to consume events and write them to a target, and use tools that process 
		the Apache Avro format to read the audit logs2.
	- Azure storage: You can use a tool such as Azure Storage Explorer to explore the audit logs, or 
		use the integrated database query editor to run SQL queries on the audit log files3.

	For more information, you can refer to the documentation or this web page. I hope this helps. 

	-- https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-analyze-audit-logs?view=azuresql
	-- https://learn.microsoft.com/en-us/azure/azure-sql/database/auditing-overview?view=azuresql
	-- https://techcommunity.microsoft.com/t5/azure-database-support-blog/azure-sql-db-and-log-analytics-better-together-part-3-query/ba-p/1034222

#>
