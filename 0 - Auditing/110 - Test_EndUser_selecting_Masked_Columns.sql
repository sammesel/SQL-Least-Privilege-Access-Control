-- ================================================================================= --
-- LOGIN as:		user_datareader
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


SELECT TOP (50) AddressID,[AddressLine1],[City],[PostalCode],* FROM [Person].[Address]
SELECT TOP (50) BusinessEntityID,BirthDate,NationalIDNumber,* FROM HumanResources.Employee
SELECT TOP (50) [CreditCardID],[CardType],[CardNumber],[ExpMonth],[ExpYear] FROM [Sales].[CreditCard]
SELECT TOP (10) [BusinessEntityID],[PhoneNumber],[PhoneNumberTypeID] FROM [Person].[PersonPhone]
SELECT TOP (50) AddressID,[AddressLine2],[City],[PostalCode] FROM [Person].[Address]
SELECT TOP (50) BusinessEntityID,PasswordHash,PasswordSalt FROM Person.Password
SELECT TOP (50) BusinessEntityID,LastName,FirstName FROM Person.Person
SELECT TOP (50) SalesOrderId,AccountNumber FROM Sales.SalesOrderHeader
SELECT TOP (50) SalesOrderId,CreditCardApprovalCode,CreditCardID,CurrencyRateID FROM Sales.SalesOrderHeader
SELECT TOP (50) BusinessEntityID,AccountNumber FROM Purchasing.Vendor
SELECT * FROM Purchasing.Vendor WHERE BusinessEntityID=1596

-- to be used with new logins, to validate if they have access to these tables:
SELECT * FROM dbo.ErrorLog
SELECT * FROM HumanResources.Employee
SELECT * FROM Person.Address
SELECT * FROM Person.EmailAddress
SELECT * FROM Person.Password
SELECT * FROM Person.Person
SELECT * FROM Person.PhoneNumberType
SELECT * FROM Production.ProductReview
SELECT * FROM Purchasing.Vendor
SELECT * FROM Sales.CreditCard
SELECT * FROM Sales.CurrencyRate
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.SalesTaxRate

-- ========================================================================================= --
-- keep this session open until you execute next script to review AUDIT records
-- get this SESSION-ID and replace on line 21 of script [120 - Observe Auditing Records.SQL]
-- ========================================================================================== --
SELECT @@SPID
