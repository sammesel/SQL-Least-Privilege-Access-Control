-- https://learn.microsoft.com/en-us/sql/t-sql/statements/add-sensitivity-classification-transact-sql?view=sql-server-ver16

-- ================================================================================= --
-- LOGIN as:		sa
-- use password:	'<password-place-holder>'
-- ================================================================================= --
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user
USE SQLSecurityDemoDB
GO
SELECT USER_NAME(), SUSER_NAME() , session_user , system_user


DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CurrencyRate].[CurrencyRateID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CurrencyRate].[CurrencyRateDate]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Purchasing].[PurchaseOrderHeader].[TaxAmt]
GO

ADD SENSITIVITY CLASSIFICATION TO [Purchasing].[PurchaseOrderHeader].[TaxAmt] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CurrencyRate].[CurrencyRateDate] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CurrencyRate].[CurrencyRateID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

USE [SQLSecurityDemoDB]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesTaxRate].[TaxRate]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesTaxRate].[SalesTaxRateID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesOrderHeader].[TaxAmt]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesOrderHeader].[CurrencyRateID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesOrderHeader].[CreditCardID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesOrderHeader].[CreditCardApprovalCode]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[SalesOrderHeader].[AccountNumber]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[PersonCreditCard].[CreditCardID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CurrencyRate].[CurrencyRateID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CurrencyRate].[CurrencyRateDate]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CreditCard].[ExpYear]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CreditCard].[ExpMonth]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CreditCard].[CreditCardID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CreditCard].[CardType]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Sales].[CreditCard].[CardNumber]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Purchasing].[Vendor].[AccountNumber]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Purchasing].[PurchaseOrderHeader].[TaxAmt]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Production].[ProductReview].[EmailAddress]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[PhoneNumberType].[PhoneNumberTypeID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[PersonPhone].[PhoneNumberTypeID]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[PersonPhone].[PhoneNumber]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Person].[LastName]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Person].[FirstName]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Password].[PasswordSalt]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Password].[PasswordHash]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[EmailAddress].[EmailAddress]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Address].[PostalCode]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Address].[City]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Address].[AddressLine2]
GO

DROP SENSITIVITY CLASSIFICATION FROM [Person].[Address].[AddressLine1]
GO

DROP SENSITIVITY CLASSIFICATION FROM [HumanResources].[Employee].[NationalIDNumber]
GO

DROP SENSITIVITY CLASSIFICATION FROM [HumanResources].[Employee].[BirthDate]
GO

DROP SENSITIVITY CLASSIFICATION FROM [dbo].[ErrorLog].[UserName]
GO

-- DROP SENSITIVITY CLASSIFICATION FROM [dbo].[Contacts2].[ContactEmail]
-- GO

-- DROP SENSITIVITY CLASSIFICATION FROM [dbo].[Contacts].[ContactEmail]
--GO

--ADD SENSITIVITY CLASSIFICATION TO [dbo].[Contacts].[ContactEmail] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
--GO

--ADD SENSITIVITY CLASSIFICATION TO [dbo].[Contacts2].[ContactEmail] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
--GO

ADD SENSITIVITY CLASSIFICATION TO [dbo].[ErrorLog].[UserName] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credentials', information_type_id = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59');
GO

ADD SENSITIVITY CLASSIFICATION TO [HumanResources].[Employee].[BirthDate] WITH (label = 'Confidential - GDPR', label_id = '989adc05-3f3f-0588-a635-f475b994915b', information_type = 'Date Of Birth', information_type_id = '3de7cc52-710d-4e96-7e20-4d5188d2590c');
GO

ADD SENSITIVITY CLASSIFICATION TO [HumanResources].[Employee].[NationalIDNumber] WITH (label = 'Confidential - GDPR', label_id = '989adc05-3f3f-0588-a635-f475b994915b', information_type = 'National ID', information_type_id = '6f5a11a7-08b1-19c3-59e5-8c89cf4f8444');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Address].[AddressLine1] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Address].[AddressLine2] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Address].[City] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Address].[PostalCode] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[EmailAddress].[EmailAddress] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Password].[PasswordHash] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credentials', information_type_id = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Password].[PasswordSalt] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credentials', information_type_id = 'c64aba7b-3a3e-95b6-535d-3bc535da5a59');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Person].[FirstName] WITH (label = 'Confidential - GDPR', label_id = '989adc05-3f3f-0588-a635-f475b994915b', information_type = 'Name', information_type_id = '57845286-7598-22f5-9659-15b24aeb125e');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[Person].[LastName] WITH (label = 'Confidential - GDPR', label_id = '989adc05-3f3f-0588-a635-f475b994915b', information_type = 'Name', information_type_id = '57845286-7598-22f5-9659-15b24aeb125e');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[PersonPhone].[PhoneNumber] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[PersonPhone].[PhoneNumberTypeID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Person].[PhoneNumberType].[PhoneNumberTypeID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Production].[ProductReview].[EmailAddress] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Contact Info', information_type_id = '5c503e21-22c6-81fa-620b-f369b8ec38d1');
GO

ADD SENSITIVITY CLASSIFICATION TO [Purchasing].[PurchaseOrderHeader].[TaxAmt] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Purchasing].[Vendor].[AccountNumber] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CreditCard].[CardNumber] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CreditCard].[CardType] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CreditCard].[CreditCardID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CreditCard].[ExpMonth] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646', rank = Medium);
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CreditCard].[ExpYear] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CurrencyRate].[CurrencyRateDate] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[CurrencyRate].[CurrencyRateID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[PersonCreditCard].[CreditCardID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesOrderHeader].[AccountNumber] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesOrderHeader].[CreditCardApprovalCode] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesOrderHeader].[CreditCardID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Credit Card', information_type_id = 'd22fa6e9-5ee4-3bde-4c2b-a409604c4646');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesOrderHeader].[CurrencyRateID] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesOrderHeader].[TaxAmt] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesTaxRate].[SalesTaxRateID] WITH (label = 'Confidential - GDPR', label_id = '989adc05-3f3f-0588-a635-f475b994915b', information_type = 'National ID', information_type_id = '6f5a11a7-08b1-19c3-59e5-8c89cf4f8444');
GO

ADD SENSITIVITY CLASSIFICATION TO [Sales].[SalesTaxRate].[TaxRate] WITH (label = 'Confidential', label_id = '331f0b13-76b5-2f1b-a77b-def5a73c73c2', information_type = 'Financial', information_type_id = 'c44193e1-0e58-4b2a-9001-f7d6e7bc1373');
GO




