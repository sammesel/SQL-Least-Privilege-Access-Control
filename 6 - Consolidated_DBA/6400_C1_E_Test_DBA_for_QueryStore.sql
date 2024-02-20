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

-- **************************************************************** --+
-- WITH this settings we don't need the wrapper-code for QUERY STORE --
-- **************************************************************** --+

-- these are the permissions of the current user
SELECT * FROM sys.fn_my_permissions(NULL, 'DATABASE')

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
WHERE query_id = 8457

	

-- Negative Test to force a plan directly
EXECUTE sp_query_store_force_plan
		@query_id	=  8457
	,	@plan_id	=  118
GO

-- Negative Test to change database directly
ALTER DATABASE [SQLSecurityDemoDB]
	SET QUERY_STORE (MAX_STORAGE_SIZE_MB = 200)
--> this should also not be possible

