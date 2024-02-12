-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

USE SQLSecurityDemoDB
go
select *
from sales.salesorderheader
where 1=2


select AccountNumber, count(*)
from sales.salesorderheader
GROUP BY AccountNumber
ORDER BY 2 desc

select Status, count(*)
from sales.salesorderheader
GROUP BY Status
ORDER BY 2 desc

select SalesPersonID, count(*)
from sales.salesorderheader
GROUP BY SalesPersonID
ORDER BY 2 desc

select TerritoryID, count(*)
from sales.salesorderheader
GROUP BY TerritoryID
ORDER BY 2 desc

select ShipMethodID, count(*)
from sales.salesorderheader
GROUP BY ShipMethodID
ORDER BY 2 desc

select ShipMethodID, count(*)
from sales.salesorderheader
GROUP BY ShipMethodID
ORDER BY 2 desc


select *
from sales.salesorderheader
WHERE SalesPersonID IS NULL

declare @sid int = 277
select *
from sales.salesorderheader
WHERE SalesPersonID = @sid

declare @sid int = 285
select *
from sales.salesorderheader
WHERE SalesPersonID = @sid


CREATE or ALTER PROCEDURE [Sales].[spTaxRateByState]
    @CountryRegionCode NVARCHAR(3)
AS 
    SET NOCOUNT ON ;
 
    SELECT  [st].[SalesTaxRateID],
            [st].[Name],
            [st].[TaxRate],
            [st].[TaxType],
            [sp].[Name] AS StateName
    FROM    [Sales].[SalesTaxRate] st
            JOIN [Person].[StateProvince] sp ON [st].[StateProvinceID]
             = [sp].[StateProvinceID]
    WHERE   [sp].[CountryRegionCode] = @CountryRegionCode
    ORDER BY [StateName]
GO

EXEC [Sales].[spTaxRateByState] @CountryRegionCode = 'US'
go 40
sp_recompile '[Sales].[spTaxRateByState]'
EXEC [Sales].[spTaxRateByState] @CountryRegionCode = 'UK'

