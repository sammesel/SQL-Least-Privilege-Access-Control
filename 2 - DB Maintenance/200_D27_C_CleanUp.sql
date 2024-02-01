-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- CLEAN UP
PRINT 'Droping User: DBA_with_ServerAdmin'
DROP USER DBA_with_ServerAdmin;

use master
DROP LOGIN DBA_with_ServerAdmin;
