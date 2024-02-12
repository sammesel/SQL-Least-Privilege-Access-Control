-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, @@servername, db_name()
GO
USE SQLSecurityDemoDB
GO

-- get the @@SPID, you'll use this value on the script [400_B1_C4_DBA_monitor_and_Kill_Blocking_Session.sql]
SELECT @@SPID

SELECT	
	* 
FROM	
	Sales.SalesOrderDetail 
WHERE
		CarrierTrackingNumber = '9429-430D-89'