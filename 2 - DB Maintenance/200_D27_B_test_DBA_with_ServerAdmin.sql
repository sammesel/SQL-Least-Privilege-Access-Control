-- ================================================================================= --
-- LOGIN as:		DBA_with_ServerAdmin
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


	-- Can user access objects in production SCHEMA?
	-- NO
	SELECT * FROM [Production].[Location]
	SELECT * FROM [Production].[Product]
	SELECT * FROM [Production].[ProductCategory]
	SELECT * FROM [Production].[ProductDescription]
	SELECT * FROM [Production].[ProductReview]
	SELECT * FROM [Production].[ScrapReason]
	SELECT * FROM [Production].[UnitMeasure]
	-- does user access objects in other SCHEMAs?
	-- NO
	SELECT * FROM HumanResources.Employee
	SELECT * FROM HumanResources.Department
	SELECT * FROM HumanResources.JobCandidate
	SELECT * FROM HumanResources.vEmployee
	SELECT * FROM Person.Address
	SELECT * FROM Person.EmailAddress
	SELECT * FROM Person.Password
	SELECT * FROM Person.Person
	SELECT * FROM Person.PhoneNumberType
	SELECT * FROM Purchasing.Vendor
	SELECT * FROM Sales.CreditCard
	SELECT * FROM Sales.CurrencyRate
	SELECT * FROM Sales.SalesOrderHeader
	SELECT * FROM Sales.SalesTaxRate

	-- AS DBA_with_ServerAdmin Remove UNMASK permission
	-- CAN'T DO IT
	REVOKE UNMASK TO DBA_with_ServerAdmin;
	GRANT  UNMASK TO DBA_with_ServerAdmin;

	-- CAN DBA_for_DBCC run DBCC SHOWSTATISTICS?
	-- yes
	DBCC SHOW_STATISTICS ("HumanResources.Employee", PK_Employee_BusinessEntityID);
	GO
	DBCC SHOW_STATISTICS ("HumanResources.Employee", PK_Employee_BusinessEntityID) WITH HISTOGRAM;
	GO
	-- CAN DBA_for_DBCC run DBCC_SHOWCONTIG?
	-- NO
	DBCC SHOWCONTIG ('HumanResources.Employee');
	GO
	-- CAN DBA_for_DBCC run DBCC SHRINKDATABASE?
	-- NO
	DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
	GO

-- RUN the following statements
shutdown


--checkpoint: this requires db_owner or db_backupoperator
CHECKPOINT  

-- sp_lock, sp_who 
-- yes
sp_lock 
sp_who 

-- using Object Explorer execute the following actions by right-clicking the instance:
Start, Stop, Pause, Resume, Restart the Database Engine, SQL Server Agent, or SQL Server Browser Service


