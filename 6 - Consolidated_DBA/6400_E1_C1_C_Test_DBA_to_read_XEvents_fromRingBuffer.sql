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


SET NUMERIC_ROUNDABORT ON

-- Get the target data
DECLARE @target_data xml;
SELECT @target_data = CONVERT(xml, target_data)
FROM sys.dm_xe_sessions AS s
JOIN sys.dm_xe_session_targets AS t
ON t.event_session_address = s.address
WHERE s.name = N'DBA_Server_XEvents_Test'
AND t.target_name = N'ring_buffer';

-- Parse the event data
;WITH src AS
(
    SELECT xeXML = xm.s.query('.')
    FROM @target_data.nodes('/RingBufferTarget/event') AS xm(s)
)
SELECT
    [TimeStamp] = src.xeXML.value('(/event/@timestamp)[1]', 'datetime2'),
    [EventName] = src.xeXML.value('(/event/@name)[1]', 'varchar(50)'),
    [Duration] = src.xeXML.value('(/event/data[@name="duration"]/value)[1]', 'bigint'),
    [DatabaseName] = src.xeXML.value('(/event/data[@name="database_name"]/value)[1]', 'varchar(128)')
FROM src
ORDER BY [TimeStamp] DESC;

