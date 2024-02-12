/*******************************************************************
Query Store access to sp_query_store_force_plan, demo solution
Accompanying article: Using Query Store with least privileges instead of db_owner to archive Separation of Duties

Test Script to simulate actions for the TuningTeam

07/24/2019 Andreas Wolter, Microsoft

Applies to: SQL Server, Azure SQL Database, Azure SQL Database Managed Instance

*******************************************************************/

-- in Azure SQL Database remove the "USE Database" statements and open a new connection if necessary

-- ================================================================================= --
-- LOGIN as:		DBA_for_QueryStore
-- use password:	'<P@ssw0rd-Pl@c3-H0ld3r>'
-- ================================================================================= --
-- make sure to login as [DBA_for_QueryStore]
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO


-- these are the permissions of the current user
SELECT * FROM sys.fn_my_permissions(NULL, 'DATABASE')

-- does [DBA_for_QueryStore] have SELECT on tables ?
	-- does user access objects in the Production SCHEMA?
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


-- Testing to use some of the Query Store DMVs
SELECT 
	*  
FROM 
	sys.query_store_plan AS query_store_plan  
	JOIN sys.query_store_query AS query_store_query  
		ON query_store_plan.query_id = query_store_query.query_id  
	JOIN sys.query_store_query_text AS query_store_query_text  
		ON query_store_query.query_text_id = query_store_query_text.query_text_id ;  

SELECT 
	query_store_plan.query_id, count(*)  
FROM 
	sys.query_store_plan AS query_store_plan  
	JOIN sys.query_store_query AS query_store_query  
		ON query_store_plan.query_id = query_store_query.query_id  
	JOIN sys.query_store_query_text AS query_store_query_text  
		ON query_store_query.query_text_id = query_store_query_text.query_text_id
GROUP BY
	query_store_plan.query_id
HAVING 
	COUNT(*)>1

/*
** IF THERE ARE NO QUERIES with MORE THAN 1 PLAN:
**	open another session, login as sa and 
**		1st) create the SP [Sales].[spTaxRateByState]
**		2nd) EXECUTE the stored procedure [Sales].[spTaxRateByState] with parameter @CountryRegionCode = 'US'
**		3rd) recompile the stored procedure '[Sales].[spTaxRateByState]'
**		4th) EXECUTE the stored procedure [Sales].[spTaxRateByState] with parameter @CountryRegionCode = 'UK'
**
CREATE OR ALTER PROCEDURE [Sales].[spTaxRateByState]
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
GO 50
sp_recompile '[Sales].[spTaxRateByState]'
GO
EXEC [Sales].[spTaxRateByState] @CountryRegionCode = 'UK'
GO 100


** Another query that will generate multiple plans:
select *
from sales.salesorderheader
WHERE SalesPersonID = 277
GO
select *
from sales.salesorderheader
WHERE SalesPersonID = 285



** 
*/


SELECT * 
FROM sys.query_store_plan
-- <replace with a query-id that has more than 1 plan - from above query>
WHERE query_id = 178

	

-- Negative Test to force a plan directly
EXECUTE sp_query_store_force_plan
		@query_id	=  178
	,	@plan_id	=  14
GO
--> this shall not work because it requires the ALTER-Permission on the Database

-- Testing to force a plan via custom wrapper procedure
EXEC tools_QueryStore.up_sp_query_store_force_plan
	-- Change parameter values to fit to your system
		@query_id = 178
	,	@plan_id = 14;  
--> Error 12402, "Query with provided query_id (X) is not found in the Query Store for database (Y)" would indicate that the permissions are correct, just the parameter values make no sense.

-- Negative Test to change database directly
ALTER DATABASE [SQLSecurityDemoDB]
	SET QUERY_STORE (MAX_STORAGE_SIZE_MB = 200)
--> this should also not be possible

-- Positive Test to change query Store storage via wrapper code
EXEC tools_QueryStore.up_sp_query_store_set_storage 50
