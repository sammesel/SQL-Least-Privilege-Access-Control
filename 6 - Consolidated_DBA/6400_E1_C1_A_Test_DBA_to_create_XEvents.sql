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

DROP EVENT SESSION [DBA_Server_XEvents_Test]  ON SERVER;
GO

CREATE EVENT SESSION [DBA_Server_XEvents_Test] ON SERVER 

ADD EVENT sqlserver.existing_connection(
    ACTION(package0.event_sequence,sqlserver.client_hostname,sqlserver.database_name,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)), 
ADD EVENT sqlserver.rpc_starting(SET collect_statement=(1)
    ACTION(package0.event_sequence,sqlserver.client_hostname,sqlserver.database_name,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)), 
ADD EVENT sqlserver.sp_statement_starting(
    ACTION(package0.event_sequence,sqlserver.client_hostname,sqlserver.database_name,sqlserver.query_hash,sqlserver.sql_text)), 
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(package0.event_sequence,sqlserver.client_hostname,sqlserver.database_name,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)), 
ADD EVENT sqlserver.sql_statement_starting(
    ACTION(package0.event_sequence,sqlserver.client_hostname,sqlserver.database_name,sqlserver.query_hash,sqlserver.sql_text))
/*
** FOR on-premises or VM use a file for demo purposes
*/
-- ADD TARGET package0.event_file(SET filename=N'E:\XEVENTS\DBA_XEvents_Test',max_file_size=(5120))
/*
** FOR Azure SQL Managed Instance use RING BUFFER for the demo purposes
** AND comment the line above for file target
*/
ADD TARGET package0.ring_buffer(SET max_memory=(1024))
GO

-- for syntax and examples on how to create Xtended Events on Azure SQL Mi with target as File or Ring Buffer
-- please check: 
--			https://learn.microsoft.com/en-us/azure/azure-sql/database/xevent-db-diff-from-svr?view=azuresql&tabs=sqldb
--			https://learn.microsoft.com/en-us/azure/azure-sql/database/xevent-code-ring-buffer?view=azuresql&tabs=sqldb
--			

/*
** References: 
**	Extended Events Dynamic Management Views:
**		https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/extended-events-dynamic-management-views?view=azuresqldb-current&viewFallbackFrom=sql-server-ver15
**		
**	Extended Events Catalog Views
**		https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/extended-events-catalog-views-transact-sql?view=sql-server-ver15
*/
-- THESE Queries will FAIL as we haven't provided VIEW SERVER STATE permissions
	SELECT *
	FROM sys.server_event_sessions

	SELECT *
	FROM sys.server_event_session_actions
	WHERE event_session_id = (
		SELECT event_session_id --, *
		FROM sys.server_event_sessions
		WHERE name = 'DBA_Server_XEvents_Test'
	)

	SELECT *
	FROM sys.server_event_session_events 
	WHERE event_session_id = (
		SELECT event_session_id --, *
		FROM sys.server_event_sessions
		WHERE name = 'DBA_Server_XEvents_Test'
	)

	SELECT *
	FROM sys.server_event_session_fields 
	WHERE event_session_id = (
		SELECT event_session_id --, *
		FROM sys.server_event_sessions
		WHERE name = 'DBA_Server_XEvents_Test'
	)

	SELECT *
	FROM sys.server_event_session_targets
	WHERE event_session_id = (
		SELECT event_session_id --, *
		FROM sys.server_event_sessions
		WHERE name = 'DBA_Server_XEvents_Test'
	)

	-- Obtain live session statistics   
	SELECT * FROM sys.dm_xe_sessions;  
	SELECT * FROM sys.dm_xe_session_events;  
	GO  



/*
** start session
*/
ALTER EVENT SESSION [DBA_Server_XEvents_Test] ON SERVER STATE = START


-- before stopping / dropping the XEvent session
-- execute script [6400_E1_C1_C_Test_DBA_to_read_XEvents_fromRingBuffer.sql] to read from it


/*
** stop session
*/
ALTER EVENT SESSION [DBA_Server_XEvents_Test] ON SERVER STATE = STOP
  
-- Add new events to the session  
ALTER EVENT SESSION [DBA_Server_XEvents_Test]  ON SERVER  
ADD EVENT sqlserver.database_transaction_begin,  
ADD EVENT sqlserver.database_transaction_end;  
GO

ALTER EVENT SESSION [DBA_Server_XEvents_Test] ON SERVER STATE = START


/*
** retrieve data from XEvents
*/
-- THIS Query will FAIL as we haven't provided VIEW SERVER STATE permissions
--	SELECT event_data = CONVERT(XML, event_data) 
--	FROM sys.fn_xe_file_target_read_file(N'"E:\XEVENTS\DBA_XEvents_Test*.xel', NULL, NULL, NULL);

-- WAIT until the end of all XEVENT tests 
/* 
** DROP SESSION
*/
DROP EVENT SESSION [DBA_Server_XEvents_Test]  ON SERVER;
GO


