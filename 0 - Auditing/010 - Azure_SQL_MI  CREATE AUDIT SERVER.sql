-- https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/auditing-configure?view=azuresql

/*
CREATE CREDENTIAL [<container_url>]
WITH IDENTITY='SHARED ACCESS SIGNATURE',
SECRET = '<SAS KEY>'
GO
*/

DROP CREDENTIAL [https://st4dbxferdatalogbackups.blob.core.windows.net/auditing]
GO
CREATE CREDENTIAL [https://st4dbxferdatalogbackups.blob.core.windows.net/auditing]
WITH IDENTITY='SHARED ACCESS SIGNATURE',
-- Remove the question mark (?) character from the beginning of the token
SECRET = 'sv=2022-11-02&ss=bfqt&srt=s&sp=rwdlactfx&se=2029-02-07T19:00:00Z&st=2024-02-07T19:00:00Z&spr=https&sig=FFygqAW10I5RrfcXVgxGpBZi2xYPo7D4HhCSz0asLB8%3D'
GO

/*
CREATE SERVER AUDIT [<your_audit_name>]
TO URL (PATH ='<container_url>', RETENTION_DAYS = <integer>);
GO
*/


USE [master]
GO

DROP SERVER AUDIT [Instance_ServerAudit]
GO

CREATE SERVER AUDIT [Instance_ServerAudit]
TO URL  (PATH = N'https://st4dbxferdatalogbackups.blob.core.windows.net/auditing/') WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = '140a2a9d-af1a-4b68-9ddc-15facb06b416', OPERATOR_AUDIT = OFF)
GO
ALTER SERVER AUDIT [Instance_ServerAudit] WITH (STATE = OFF)
GO

-- starts the Server-Audit :
ALTER SERVER AUDIT [Instance_ServerAudit]
WITH (STATE = ON);  
GO  

-- SKIP to script [020 - AUDIT SERVER SPEC.sql]