----------------------------------------------------------
-- LOGIN as		UserMary1
-- use password: '<password-place-holder>'
----------------------------------------------------------
-- if it fails it is because of an updated password. Try from the following list:
-- PASSWORD = 'uDwf*+zj:~Wxg/)$k5`vR7';
-- PASSWORD = 'A4L7]xwD}&5G!2f?K@)^ng';
-- PASSWORD = 'p]&`K!a%S7fb$8#BqwH)X<';
-- PASSWORD = 'F&92u_s.?%hH~C4zA`,^+5';
-- PASSWORD = 'vmS28^4.(XNdM/U3?Y"5&n';
----------------------------------------------------------
-- LOGIN as		UserJohn2
-- use password: '<password-place-holder>'
----------------------------------------------------------

SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
use SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- START:
-- does user access objects in the HumanResources SCHEMA?
-- YES
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


-- AS user try Removing the UNMASK permission
-- -- REVOKE GRANT UNMASK will fail
REVOKE UNMASK TO UserMary1;
GRANT  UNMASK TO UserMary1;

-- CAN the user run DBCC SHOWSTATISTICS?
DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID);
GO
DBCC SHOW_STATISTICS ("Sales.SalesTaxRate", PK_SalesTaxRate_SalesTaxRateID) WITH HISTOGRAM;
GO
-- CAN DBA run DBCC_SHOWCONTIG?
DBCC SHOWCONTIG ('Sales.SalesTaxRate');
GO
-- CAN DBA run DBCC SHRINKDATABASE?
DBCC SHRINKDATABASE (SQLSecurityDemoDB, 10);
GO
