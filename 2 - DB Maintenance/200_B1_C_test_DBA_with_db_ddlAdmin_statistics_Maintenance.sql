-- ================================================================================= --
-- LOGIN as:		DBA_With_DB_DDLAdmin
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
go
use SQLSecurityDemoDB
go
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- DROP STATISTICS 
DROP STATISTICS Person.Person.ContactMail1     

-- CREATE STATISTICS with SAMPLE number PERCENT
CREATE STATISTICS ContactMail1
    ON Person.Person (BusinessEntityID, EmailPromotion)
    WITH SAMPLE 5 PERCENT;

-- DROP STATISTICS 
DROP STATISTICS Person.Person.NamePurchase
-- CREATE STATISTICS with SAMPLE number PERCENT
CREATE STATISTICS NamePurchase
    ON Person.Person (BusinessEntityID, EmailPromotion)
    WITH FULLSCAN, NORECOMPUTE;


-- DROP STATISTICS 
DROP STATISTICS Person.Person.ContactPromotion1

-- CREATE STATISTICS to create filtered statistics
CREATE STATISTICS ContactPromotion1
    ON Person.Person (BusinessEntityID, LastName, EmailPromotion)
WHERE EmailPromotion = 2
WITH SAMPLE 50 PERCENT;
GO


-- DROP STATISTICS 
DROP STATISTICS Person.Person.NamePurchase2
-- CREATE STATISTICS with FULLSCAN and PERSIST_SAMPLE_PERCENT
CREATE STATISTICS NamePurchase2
    ON Person.Person (BusinessEntityID, EmailPromotion)
    WITH FULLSCAN, PERSIST_SAMPLE_PERCENT = ON;


-- update statistics
-- all statistics on a table
UPDATE STATISTICS Sales.SalesOrderDetail;  
GO

-- Update the statistics for a specific index
UPDATE STATISTICS Sales.SalesOrderDetail AK_SalesOrderDetail_rowguid;  
GO


-- DROP STATISTICS 
DROP STATISTICS Production.Product.Products
-- using 50 percent sampling
CREATE STATISTICS Products
    ON Production.Product ([Name], ProductNumber)
    WITH SAMPLE 50 PERCENT
-- Time passes. The UPDATE STATISTICS statement is then executed.
UPDATE STATISTICS Production.Product(Products)
    WITH SAMPLE 50 PERCENT;

-- using FULLSCAN and NORECOMPUTE
UPDATE STATISTICS Production.Product(Products)  
    WITH FULLSCAN, NORECOMPUTE;  
GO


-- CREATE and DROP 
-- Create the statistics groups.  
CREATE STATISTICS VendorCredit  
    ON Purchasing.Vendor (Name, CreditRating)  
    WITH SAMPLE 50 PERCENT  
CREATE STATISTICS CustomerTotal  
    ON Sales.SalesOrderHeader (CustomerID, TotalDue)  
    WITH FULLSCAN;  
GO  
DROP STATISTICS Purchasing.Vendor.VendorCredit, Sales.SalesOrderHeader.CustomerTotal;
