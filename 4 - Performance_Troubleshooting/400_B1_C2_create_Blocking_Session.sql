-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user, @@servername, db_name()
GO
USE SQLSecurityDemoDB
GO

--SELECT CarrierTrackingNumber,COUNT(*)  FROM Sales.SalesOrderDetail SOD 
--GROUP BY CarrierTrackingNumber
--ORDER BY 2 DESC
--SELECT *  FROM Sales.SalesOrderDetail SOD WHERE 1=2


BEGIN TRANSACTION
	UPDATE 
		Sales.SalesOrderDetail 
	SET
		OrderQty = OrderQty * 1.000
	WHERE
		CarrierTrackingNumber = '9429-430D-89'
		
		rollback transaction