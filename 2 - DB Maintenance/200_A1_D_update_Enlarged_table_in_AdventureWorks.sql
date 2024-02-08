-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --

SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
go

use SQLSecurityDemoDB
go
select *
FROM Sales.SalesOrderHeaderEnlarged
go
UPDATE Sales.SalesOrderHeaderEnlarged
SET 
	 OrderDate = getdate()
	,DueDate = dateadd(dd,30,getdate())
	,ShipDate = dateadd(dd,7,getdate())
	,Status = 1
WHERE 
	SalesOrderID > 43680 AND 
	SalesOrderID < 51351
	
