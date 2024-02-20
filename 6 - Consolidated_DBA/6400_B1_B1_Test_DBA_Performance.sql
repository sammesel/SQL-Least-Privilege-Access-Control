-- ================================================================================= --
-- LOGIN as:		[Login_Test_DBA]
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, db_name()
GO

-- now showing the DBA can get into performance troubleshooting by running common DBA queries:
SELECT * FROM sys.dm_os_performance_counters
SELECT * FROM sys.dm_exec_requests
SELECT * FROM sys.dm_exec_query_stats order by execution_count desc
 
-- sys.dm_exec_query_stats
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-stats-transact-sql?view=sql-server-ver16#permissions

-- FINDING TOP n QUERIES
SELECT TOP 5 query_stats.query_hash AS Query_Hash,   
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS Avg_CPU_Time,  
    MIN(query_stats.statement_text) AS Sample_Statement_Text
FROM   
    (
	SELECT 
		QS.*,   
		SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,  
		((CASE statement_end_offset   
			WHEN -1 THEN DATALENGTH(ST.text)  
			ELSE QS.statement_end_offset END   
            - QS.statement_start_offset)/2) + 1) AS statement_text  
     FROM 
		sys.dm_exec_query_stats AS QS  
		CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST 
	WHERE ST.Text not like '%sys.%'
	) as query_stats  
GROUP BY query_stats.query_hash  
ORDER BY 2 DESC;  


-- Returning row count aggregates for a query
SELECT qs.execution_count,  
    SUBSTRING(qt.text,qs.statement_start_offset/2 +1,   
                 (CASE WHEN qs.statement_end_offset = -1   
                       THEN LEN(CONVERT(nvarchar(max), qt.text)) * 2   
                       ELSE qs.statement_end_offset end -  
                            qs.statement_start_offset  
                 )/2  
             ) AS query_text,   
     qt.dbid, dbname= DB_NAME (qt.dbid), qt.objectid,   
     qs.total_rows, qs.last_rows, qs.min_rows, qs.max_rows  
FROM sys.dm_exec_query_stats AS qs   
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt   
WHERE 
	qt.text like '%SELECT%'   
	and
	qt.text NOT like '%sys.%'   
ORDER BY qs.execution_count DESC;

-- find out all sessions running
SELECT * from sys.dm_exec_sessions 
WHERE Session_id > 50
	AND 
	(
		program_name = 'OSTRESS'
		or
		program_name = 'Microsoft SQL Server Management Studio - Query'
	)

SELECT t.*
FROM sys.dm_exec_requests AS r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE session_id = @@SPID-- modify this value with your actual spid


-- Obtain information about the top five queries by average CPU time
SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time],  
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,   
        ((CASE qs.statement_end_offset  
          WHEN -1 THEN DATALENGTH(st.text)  
         ELSE qs.statement_end_offset  
         END - qs.statement_start_offset)/2) + 1) AS statement_text  
FROM sys.dm_exec_query_stats AS qs  
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st  
ORDER BY total_worker_time/execution_count DESC;


-- Provide batch-execution statistics
SELECT s2.dbid,   
    s1.sql_handle,    
    (SELECT TOP 1 SUBSTRING(s2.text,statement_start_offset / 2+1 ,   
      ( (CASE WHEN statement_end_offset = -1   
         THEN (LEN(CONVERT(nvarchar(max),s2.text)) * 2)   
         ELSE statement_end_offset END)  - statement_start_offset) / 2+1))  AS sql_statement,  
    execution_count,   
    plan_generation_num,   
    last_execution_time,     
    total_worker_time,   
    last_worker_time,   
    min_worker_time,   
    max_worker_time,  
    total_physical_reads,   
    last_physical_reads,   
    min_physical_reads,    
    max_physical_reads,    
    total_logical_writes,   
    last_logical_writes,   
    min_logical_writes,   
    max_logical_writes    
FROM sys.dm_exec_query_stats AS s1   
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2    
WHERE s2.objectid is null   
ORDER BY s1.sql_handle, s1.statement_start_offset, s1.statement_end_offset;



-- all locks 
SELECT * FROM sys.dm_tran_locks
WHERE request_owner_type = N'TRANSACTION'
--    AND request_owner_id = < copied transaction_id >;
GO

-- blocked requests
SELECT session_id,
    status,
    blocking_session_id,
    wait_type,
    wait_time,
    wait_resource,
    transaction_id
FROM sys.dm_exec_requests
WHERE status = N'suspended';
GO

-- existing requests sorted by CPU
SELECT
    [req].[session_id],
    [req].[start_time],
    [req].[cpu_time] AS [cpu_time_ms],
    OBJECT_NAME([ST].[objectid], [ST].[dbid]) AS [ObjectName],
    SUBSTRING(
        REPLACE(
            REPLACE(
                SUBSTRING(
                    [ST].[text], ([req].[statement_start_offset] / 2) + 1,
                    ((CASE [req].[statement_end_offset]
                            WHEN -1 THEN DATALENGTH([ST].[text])
                            ELSE [req].[statement_end_offset]
                        END - [req].[statement_start_offset]
                        ) / 2
                    ) + 1
                ), CHAR(10), ' '
            ), CHAR(13), ' '
        ), 1, 512
    ) AS [statement_text]
FROM
    [sys].[dm_exec_requests] AS [req]
    CROSS APPLY [sys].dm_exec_sql_text([req].[sql_handle]) AS [ST]
ORDER BY
    [req].[cpu_time] DESC;
GO

-- sys.dm_exec_query_plan
-- find out all sessions running
SELECT * from sys.dm_exec_sessions 
WHERE Session_id > 50
	AND program_name = 'OSTRESS'


USE master;  
GO  
SELECT * FROM sys.dm_exec_requests  
WHERE session_id = 104;  
GO

-- sys.dm_exec_query_plan
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-query-plan-transact-sql?view=azuresqldb-current&viewFallbackFrom=sql-server-ver16

-- Retrieve every query plan from the plan cache
USE master;  
GO  
SELECT * 
FROM sys.dm_exec_cached_plans AS cp 
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle);  
GO
-- Retrieve information about the top five queries by average CPU time
SELECT TOP 5 total_worker_time/execution_count AS [Avg CPU Time],  
   plan_handle, query_plan   
FROM sys.dm_exec_query_stats AS qs  
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle)  
ORDER BY total_worker_time/execution_count DESC;  
GO

-- sys.dm_exec_cached_plans
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-cached-plans-transact-sql?view=azuresqldb-current

-- Returning the batch text of cached entries that are reused
SELECT usecounts, cacheobjtype, objtype, text   
FROM sys.dm_exec_cached_plans   
CROSS APPLY sys.dm_exec_sql_text(plan_handle)   
WHERE usecounts > 1   
ORDER BY usecounts DESC;  
GO

-- Returning the SET options with which the plan was compiled
SELECT plan_handle, pvt.set_options, pvt.sql_handle  
FROM (  
      SELECT plan_handle, epa.attribute, epa.value   
      FROM sys.dm_exec_cached_plans   
      OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa  
      WHERE cacheobjtype = 'Compiled Plan'  
      ) AS ecpa   
PIVOT (MAX(ecpa.value) FOR ecpa.attribute IN ("set_options", "sql_handle")) AS pvt;  
GO

-- Returning the memory breakdown of all cached compiled plans
SELECT plan_handle, ecp.memory_object_address AS CompiledPlan_MemoryObject,   
    omo.memory_object_address, type, page_size_in_bytes   
FROM sys.dm_exec_cached_plans AS ecp   
JOIN sys.dm_os_memory_objects AS omo   
    ON ecp.memory_object_address = omo.memory_object_address   
    OR ecp.memory_object_address = omo.parent_address  
WHERE cacheobjtype = 'Compiled Plan';  
GO


-- sys.dm_os_memory_objects
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-memory-objects-transact-sql?view=azuresqldb-current
SELECT SUM (pages_in_bytes) as 'Bytes Used', type   
FROM sys.dm_os_memory_objects  
GROUP BY type   
ORDER BY 'Bytes Used' DESC;  
GO


-- SQL Server Operating System Related Dynamic Management Views
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sql-server-operating-system-related-dynamic-management-views-transact-sql?view=azuresqldb-current
SELECT * FROM sys.dm_os_buffer_descriptors
SELECT * FROM sys.dm_os_buffer_pool_extension_configuration
SELECT * FROM sys.dm_os_child_instances
SELECT * FROM sys.dm_os_cluster_nodes
SELECT * FROM sys.dm_os_cluster_properties
SELECT * FROM sys.dm_os_dispatcher_pools
SELECT * FROM sys.dm_os_enumerate_fixed_drives
SELECT * FROM sys.dm_os_host_info
SELECT * FROM sys.dm_os_hosts
SELECT * FROM sys.dm_os_latch_stats
SELECT * FROM sys.dm_os_loaded_modules
SELECT * FROM sys.dm_os_memory_brokers
SELECT * FROM sys.dm_os_memory_cache_clock_hands
SELECT * FROM sys.dm_os_memory_cache_counters
SELECT * FROM sys.dm_os_memory_cache_entries
SELECT * FROM sys.dm_os_memory_cache_hash_tables
SELECT * FROM sys.dm_os_memory_clerks
SELECT * FROM sys.dm_os_memory_nodes
SELECT * FROM sys.dm_os_nodes
SELECT * FROM sys.dm_os_performance_counters
SELECT * FROM sys.dm_os_process_memory
SELECT * FROM sys.dm_os_schedulers
SELECT * FROM sys.dm_os_server_diagnostics_log_configurations
SELECT * FROM sys.dm_os_spinlock_stats
SELECT * FROM sys.dm_os_stacks
SELECT * FROM sys.dm_os_sys_info
SELECT * FROM sys.dm_os_sys_memory
SELECT * FROM sys.dm_os_tasks
SELECT * FROM sys.dm_os_threads
SELECT * FROM sys.dm_os_virtual_address_dump
SELECT * FROM sys.dm_os_volume_stats(null,null)
SELECT * FROM sys.dm_os_waiting_tasks
SELECT * FROM sys.dm_os_wait_stats
SELECT * FROM sys.dm_os_windows_info
SELECT * FROM sys.dm_os_workers
