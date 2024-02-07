-- ================================================================================= --
-- LOGIN as:		
--				HR_Manager
--				OperationsManager
--				SalesManager
--				SalesPerson
-- use password:	'<password-place-holder>'
-- ================================================================================= --

SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO
use [SQLSecurityDemoDB]
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
GO

-- if testing access for HR_Manager:
SELECT * FROM [HumanResources].[Department]
SELECT * FROM [HumanResources].[Employee]
SELECT * FROM [HumanResources].[EmployeeDepartmentHistory]
SELECT * FROM [HumanResources].[EmployeePayHistory]
SELECT * FROM [HumanResources].[JobCandidate]
SELECT * FROM [HumanResources].[Shift]



-- if testing access for OperationsManager:
SELECT * FROM [Production].[BillOfMaterials]
SELECT * FROM [Production].[Culture]
SELECT * FROM [Production].[Document]
SELECT * FROM [Production].[Illustration]
SELECT * FROM [Production].[Location]
SELECT * FROM [Production].[Product]
SELECT * FROM [Production].[ProductCategory]
SELECT * FROM [Production].[ProductCostHistory]
SELECT * FROM [Production].[ProductDescription]
SELECT * FROM [Production].[ProductDocument]
--...
--...
--...
SELECT * FROM [Production].[UnitMeasure]
SELECT * FROM [Production].[WorkOrder]
SELECT * FROM [Production].[WorkOrderRouting]


-- if testing access for SalesManager:
SELECT * FROM [Sales].[CountryRegionCurrency]
SELECT * FROM [Sales].[CreditCard]
SELECT * FROM [Sales].[Currency]
SELECT * FROM [Sales].[Currency]
SELECT * FROM [Sales].[CurrencyRate]
-- ...
-- ...
-- ...
SELECT * FROM [Sales].[SpecialOffer]
SELECT * FROM [Sales].[SpecialOfferProduct]
SELECT * FROM [Sales].[Store]


-- if testing access for SalesPerson:
SELECT * FROM [Sales].[CountryRegionCurrency]
SELECT * FROM [Sales].[CreditCard]
SELECT * FROM [Sales].[Currency]
SELECT * FROM [Sales].[Currency]
SELECT * FROM [Sales].[CurrencyRate]
-- ...
-- ...
-- ...
SELECT * FROM [Sales].[SpecialOffer]
SELECT * FROM [Sales].[SpecialOfferProduct]
SELECT * FROM [Sales].[Store]
