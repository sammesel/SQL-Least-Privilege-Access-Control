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

	-- can DBA list existing schemas"
	-- NO
	select * from sys.schemas

	CREATE SCHEMA lab

	-- add a table into LAB schema

	create table Lab.Test (
		test_id int not null,
		test_name char(30) not null,
		test_date date not null)

	-- can DBA drop schema?
	-- no because it has contents
	DROP SCHEMA lab

	DROP TABLE Lab.Test
	DROP SCHEMA lab


	-- create view:
	-- can DBA CREATE view?
	-- YES
	DROP VIEW Sales.vOrders2
	GO
	CREATE VIEW Sales.vOrders2
	  WITH SCHEMABINDING
	AS
	  SELECT SUM(UnitPrice * OrderQty * (1.00 - UnitPriceDiscount)) AS Revenue,
		OrderDate, ProductID, COUNT_BIG(*) AS COUNT
	  FROM Sales.SalesOrderDetail AS od, Sales.SalesOrderHeader AS o
	  WHERE od.SalesOrderID = o.SalesOrderID
	  GROUP BY OrderDate, ProductID;
	GO

	-- can DBA drop view?
	DROP VIEW Sales.vOrders
