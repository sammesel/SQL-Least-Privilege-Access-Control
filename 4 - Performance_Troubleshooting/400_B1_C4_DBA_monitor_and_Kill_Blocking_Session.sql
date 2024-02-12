-- ================================================================================= --
-- LOGIN as:		DBA_with_PerformanceTroubleshooting
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, @@servername, db_name()
GO

-- this script shows 2 methods to find who is blocking a session

-- METHOD 1: using sp_who
EXEC sp_who
-- search in the results for any rows that show a value <> 0 in the column blk (i.e. BLOCKED)
-- that's the session that is blocking the SPID on that row.
-- 
KILL 117


-- METHOD 2: troubleshooting. Analysing the queries and checking what is blocking a given session
-- 

-- in the next query, replace the value of the request_session_id using the @@SPID from the session
-- running the script [400_B1_C3_create_Blocked_Session.sql]
SELECT * 
FROM sys.dm_tran_locks 
WHERE 
	request_session_id = 112
	AND
	request_status = 'WAIT'


-- from previous query results get the resource that is being blocked, and replace the values on the query below
SELECT request_session_id,* 
FROM sys.dm_tran_locks 
WHERE 
	resource_type = 'PAGE'
	AND
	request_status = 'GRANT'
	AND
	resource_description = '1:16810' -- <<<-- REPLACE THIS VALUE
	AND
	resource_associated_entity_id = 72057594051035136 -- <<<-- REPLACE THIS VALUE


-- replace the query below with the request_session_id from previous query
KILL 122


-- return to tab of query [400_B1_C3_create_Blocked_Session.sql] to see it has been unblocked
